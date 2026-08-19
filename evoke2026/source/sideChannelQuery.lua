-- provides a system of querying the song / timing
-- driven by the side channel data provided by the somatic song.

-- side channel strings are colon-delimited; events are per-part.
-- that way a row can have multiple side-channel events.

--#pragma once


-- Case-insensitive exact-part match for colon-delimited side-channel values.
function SideChannelContainsPart(state, part)
	if not state or not state.sideChannel then
		return false
	end

	local key = part:lower()
	for valuePart in state.sideChannel:gmatch("[^:]+") do
		if valuePart:lower() == key then
			return true
		end
	end
	return false
end


gSideChannelDatabase = nil

-- converts pattern-local row to absolute songRow. should be provided by Somatic but ... welp.
local function SideChannelDatabase_GetAbsoluteRow(patternIndex, patternRow)
	assert(patternIndex >= 0 and patternRow >= 0, "SideChannelDatabase_GetAbsoluteRow invalid patternIndex/patternRow")
	assert(patternIndex < #SOMATIC_MUSIC_DATA.patternOrder, "SideChannelDatabase_GetAbsoluteRow patternIndex OOB")
	local orderStartRow = gSideChannelDatabase.orderStartRows[patternIndex + 1]
	if orderStartRow == nil then
		return nil
	end
	return orderStartRow + patternRow
end

-- adds an event to the database for a given part
-- done as precalc at init, not runtime events.
local function SideChannelDatabase_AddPartEvent(part, event)
	local key = part:lower()
	local partEvents = gSideChannelDatabase.eventsByPart[key]
	if partEvents == nil then
		partEvents = {}
		gSideChannelDatabase.eventsByPart[key] = partEvents
	end
	table.insert(partEvents, event)
end

-- precalc a sensible mapping based on SOMATIC_MUSIC_DATA.
-- this avoids having to keep playback state, which means more deterministic occurrence matching
-- when skipping around in the song.
function InitSideChannelDatabase()
	gSideChannelDatabase = {
		events = {}, -- ordered list of all events, by absolute songRow
		eventsByPart = {}, -- ordered list of occurrences, by part
		orderStartRows = {}, -- maps patternIndex to absolute songRow of first row of that pattern.
		scopeStartRow = 0, -- state: absolute songRow of the start of the current query scope.
		lastCallbackRow = nil,
		lastCallbackWallFrame = nil, -- don't use demoframe; this is intended for a single frame in any case. also demoFrame doesn't exist LUL.
	}

	local songRow = 0
	-- todo: somatic should provide this.
	local rowsPerBeat = SOMATIC_MUSIC_DATA.rowsPerBeat
	local beatsPerMinute = SOMATIC_MUSIC_DATA.tempo * 6 / SOMATIC_MUSIC_DATA.speed
	local millisPerBeat = 60000 / beatsPerMinute

	for orderIndex = 0, #SOMATIC_MUSIC_DATA.patternOrder - 1 do
		gSideChannelDatabase.orderStartRows[orderIndex + 1] = songRow

		local patternDataIndex = SOMATIC_MUSIC_DATA.patternOrder[orderIndex + 1]
		local patternSideChannel = SOMATIC_MUSIC_DATA.sideChannel[patternDataIndex]
		local orderRows = SOMATIC_MUSIC_DATA.orderRows[orderIndex + 1] or SOMATIC_MUSIC_DATA.rowsPerPattern

		if patternSideChannel then
			for patternRow = 0, orderRows - 1 do
				local value = patternSideChannel[patternRow]
				if value and value ~= "" then
					local absoluteRow = songRow + patternRow
					local demoBeats = absoluteRow / rowsPerBeat

					-- event shape:
					local event = {
						value = value, -- side channel string
						absoluteRow = absoluteRow, -- song row
						demoBeats = demoBeats, -- abs song beats
						demoMillis = demoBeats * millisPerBeat, -- etc...
						patternIndex = orderIndex,
						patternRow = patternRow,
					}
					table.insert(gSideChannelDatabase.events, event)

					-- populate per-part lookup
					local seenParts = {}
					for part in value:gmatch("[^:]+") do
						local key = part:lower()
						if not seenParts[key] then
							seenParts[key] = true
							SideChannelDatabase_AddPartEvent(key, event)
						end
					end
				end
			end
		end

		songRow = songRow + orderRows
	end
end

-- Starts a scene-local query scope. The start position is inclusive, so a
-- marker on the first row of a scene belongs to that scene.
function BeginSideChannelScope(patternIndex, patternRow)
	assert(patternIndex >= 0 and patternRow >= 0, "BeginSideChannelScope invalid patternIndex/patternRow")
	local absoluteRow = SideChannelDatabase_GetAbsoluteRow(patternIndex, patternRow)
	gSideChannelDatabase.scopeStartRow = absoluteRow
end

-- called by main. we use SOMATIC_MUSIC_DATA for timing calc; this just ensures correct exact trigger frame.
function SideChannelDatabase_SomaticRowHandler(somaticState)
	gSideChannelDatabase.lastCallbackRow =
		SideChannelDatabase_GetAbsoluteRow(somaticState.demoPatternIndex, somaticState.demoPatternRow)
	gSideChannelDatabase.lastCallbackWallFrame = somaticState.wallFrame
end

-- init a new result struct. this is the shape.
local function SideChannelDatabase_ClearHit(result)
	result.count = 0
	result.hasHit = false
	result.justHit = false
	result.sinceBeats = nil -- can be negative for future!
	result.sinceMillis = nil
	result.hitDemoBeats = nil
	result.hitDemoMillis = nil
	result.hitPatternIndex = nil
	result.hitPatternRow = nil
end

-- combines event + somaticState, returning a result struct.
-- take an event, and generate a result struct given the current runtime timing state.
-- is aware of scope. scope is used to calculate occurrence count and ignore events that
-- would otherwise bleed from the previous scene.
local function SideChannelDatabase_FillResult(result, somaticState, events, occurrence)
	SideChannelDatabase_ClearHit(result)
	assert(somaticState ~= nil, "SideChannelDatabase_FillResult somaticState nil")
	assert(events ~= nil, "SideChannelDatabase_FillResult events nil")

	local currentRow = SideChannelDatabase_GetAbsoluteRow(somaticState.demoPatternIndex, somaticState.demoPatternRow)
	if currentRow == nil or currentRow < gSideChannelDatabase.scopeStartRow then
		return result
	end

	local occurrenceEvent = nil
	local latestPastEvent = nil
	local firstFutureEvent = nil
	local scopedOccurrence = 0
	for _, event in ipairs(events) do
		if event.absoluteRow >= gSideChannelDatabase.scopeStartRow then
			scopedOccurrence = scopedOccurrence + 1
			if event.absoluteRow <= currentRow then
				result.count = result.count + 1
				latestPastEvent = event
			elseif firstFutureEvent == nil then
				firstFutureEvent = event
			end

			if occurrence ~= nil and scopedOccurrence == occurrence then
				occurrenceEvent = event
			end

			if event.absoluteRow > currentRow
				and (occurrence == nil or occurrenceEvent ~= nil)
			then
				break
			end
		end
	end

	if occurrence == nil then
		occurrenceEvent = latestPastEvent or firstFutureEvent
	end
	if occurrenceEvent then
		result.hasHit = occurrenceEvent.absoluteRow <= currentRow
		result.sinceBeats = somaticState.demoBeats - occurrenceEvent.demoBeats
		result.sinceMillis = somaticState.demoMillis - occurrenceEvent.demoMillis
		result.hitDemoBeats = occurrenceEvent.demoBeats
		result.hitDemoMillis = occurrenceEvent.demoMillis
		result.hitPatternIndex = occurrenceEvent.patternIndex
		result.hitPatternRow = occurrenceEvent.patternRow
		result.justHit = result.hasHit
			and occurrenceEvent.absoluteRow == currentRow
			and occurrenceEvent.absoluteRow == gSideChannelDatabase.lastCallbackRow
			and somaticState.wallFrame == gSideChannelDatabase.lastCallbackWallFrame
	end

	return result
end

-- Returns aggregate state for exact colon-delimited part occurrences.
-- sinceBeats and sinceMillis are negative before the requested occurrence.
function QuerySideChannelPart(somaticState, part, occurrenceIndex)
	local key = part:lower()
	local events = gSideChannelDatabase.eventsByPart[key]
	return SideChannelDatabase_FillResult({}, somaticState, events, occurrenceIndex)
end

-- sequencer transition helper:
-- trigger condition on given sidechannel part & occurrence (within current scope)
-- occurrence is optional; nil = "any".
-- returns:
-- shouldEnter, itemStartTiming
-- where itemStartTiming is the sceneTiming at the moment of the trigger.
function SeqTriggerOnSideChannel(part, occurrenceIndex)
	--assert(occurrenceIndex >= 1, "SeqTriggerOnSideChannel occurrenceIndex invalid")
	return function(_, somaticState, sceneTiming)
		local marker = QuerySideChannelPart(somaticState, part, occurrenceIndex)
		if not marker.hasHit then
			return false
		end

		return true,
			{
				demoMillis = sceneTiming.demoMillis - marker.sinceMillis,
				demoBeats = sceneTiming.demoBeats - marker.sinceBeats,
				wallMillis = sceneTiming.wallMillis,
			}
	end
end
