--#pragma once

-- allows a scene to have more granular sequencing for animation / state-keeping.

function CreateSequencer(seqDef)
	assert(#seqDef > 0, "sequencer requires at least one item")
	return {
		seqDef = seqDef,
		currentIndex = 0, -- 1-based; 0 = not started yet.
		seqTiming = { -- timing within the sequence item. reflects that of sceneTiming.
			demoMillis = 0, -- present in sceneTiming
			demoBeats = 0, -- present in sceneTiming
			wallMillis = 0, -- present in sceneTiming
		},
		seqItemStartTiming = nil, -- timing at the start of the current sequence item.
	}
end

function SwitchToSequencerItem(sequencer, index, sceneTiming, itemStartTiming)
	-- cleanup the old item.
	if sequencer.currentIndex > 0 then
		local oldItem = sequencer.seqDef[sequencer.currentIndex]
		if oldItem.cleanup then
			oldItem.cleanup(oldItem)
		end
	end

	sequencer.currentIndex = index
	sequencer.seqItemStartTiming = deepcopy(itemStartTiming)

	local newItem = sequencer.seqDef[index]
	if newItem.init then
		newItem.init(newItem)
	end
end

-- tick-update sequencer state.
-- sequencer = the sequencer state (from CreateSequencer())
-- somaticState = the somatic state containing absolute timing information from the music system.
-- sceneTiming = the scene timing, which is relative to the scene start.
function UpdateSequencer(sequencer, somaticState, sceneTiming)
	assert(sceneTiming ~= nil, "UpdateSequencer requires sceneTiming")
	if sequencer.currentIndex == 0 then
		SwitchToSequencerItem(sequencer, 1, sceneTiming, sceneTiming)
	end

	while sequencer.currentIndex < #sequencer.seqDef do
		local nextIndex = sequencer.currentIndex + 1
		local nextItem = sequencer.seqDef[nextIndex]
		local shouldEnter, itemStartTiming
		if nextItem.trigger then
			shouldEnter, itemStartTiming = nextItem.trigger(
				nextItem,
				somaticState,
				sceneTiming,
				sequencer
			)
		else
			shouldEnter = true
		end

		if not shouldEnter then
			break
		end
		SwitchToSequencerItem(sequencer, nextIndex, sceneTiming, itemStartTiming)
	end

	local seqItem = sequencer.seqDef[sequencer.currentIndex]
	sequencer.seqTiming.demoMillis = sceneTiming.demoMillis - sequencer.seqItemStartTiming.demoMillis
	sequencer.seqTiming.demoBeats = sceneTiming.demoBeats - sequencer.seqItemStartTiming.demoBeats
	sequencer.seqTiming.wallMillis = sceneTiming.wallMillis	- sequencer.seqItemStartTiming.wallMillis
	if seqItem.tick then
		seqItem.tick(seqItem, somaticState, sequencer.seqTiming)
	end
end

function TriggerOnSceneBeat(triggerBeat)
	-- defines a trigger condition that fires at the given scene beat.
	return function (_, somaticState, sceneTiming)
		assert(type(somaticState) == "table" and somaticState.demoBeats ~= nil, "TriggerOnSceneBeat somaticState not right...")
		assert(type(sceneTiming) == "table" and sceneTiming.demoBeats ~= nil, "TriggerOnSceneBeat sceneTiming not right...")
		if sceneTiming.demoBeats >= triggerBeat then
			return true, sceneTiming
		end
		return false
	end
end

SeqNop = function() end
