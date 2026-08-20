-- ship dance choreo system
-- random procedural mvmt looks lifeless so i find a minimal-ish way to compose a choreography.
-- main concept is that the "couple" dances around a shared center point.
-- so we animate the center point and describe how the ships relate to that center.
-- spring damping handles making it look more natural/human. not perfect but it allows composing
-- the choreo in a simple and expressive way for good-enough results.

--#pragma once
--#include "particleTrail1.lua"
--#include "sprite.lua"

-- dance moves start from previous move's target pose
-- params:
-- - name just for debug hud
-- - beats                     move duration
-- - centerX/Y                 TARGET center of couple in screen pix coords (where they'll be at the end of the move)
-- - separationX / separationY vector between the ships
-- - centerBendX/Y             deviation from the linear interpolation between center point.
--                             e.g. centerBendY = 4 will add a y offset of +4 at the midpoint. follows quadratic curve (0 at start, 1 at midpoint, 0 at end)
--                             without this they just interpolation positions and it looks robotic. adds arc to mvmt
-- - separationBendX/Y         same thing but affects the separation vector. so applying bend to separation
--                             means the ships will get closer/further apart in X/Y over the move.
-- - separationMode            "linear" or "polar"
-- - separationTurns           turns around center point (big arc, ships opposing)
-- - selfTurns			   turns around center point for each individual ship
-- - heading                   "tangent" (default, heading follows the travel path) or "hold" (just keep heading from previous move regardless of travel path)

EvokeSoloDance_startBeat = 0

-- entrance needs clipping.
EvokeSoloDance_stage = { x = 9, y = 9, w = 156, h = 90 }

-- spring damping: smaller response values = tighter.
-- dampingRatio=1 is critical damping; values
-- below 1 add overshoot, and values above 1 feel heavier.
EvokeSoloDance_damping = {
	position = {
		response = 1.5, -- beats
		dampingRatio = 0.8,
	},
	rotation = {
		response = 1.5, -- beats
		dampingRatio = 0.8,
	},
	headingSpeedThreshold = 0.05, -- pixels per beat; below this, keep the previous heading
	maxStepBeats = 0.01, -- spring substep
}

EvokeSoloDance_initialPose = {
	centerX = 83,
	centerY = 50,
	separationX = 188,
	separationY = -14,
}

EvokeSoloDance_moves = {
	-- {
	-- 	name = "test1", -- name = for debugging
	-- 	beats = 1, -- 2-6
	-- 	centerX = 86,
	-- 	centerY = 50,
	-- 	separationX = 58,
	-- 	separationY = 0,
	-- 	--centerBendY = -4,
	-- 	--separationBendY = 6,
	-- },
	-- {
	-- 	name = "test2", -- name = for debugging
	-- 	beats = 8, -- 2-6
	-- 	centerX = 66,
	-- 	centerY = 50,
	-- 	separationX = 40,
	-- 	separationY = 0,
	-- 	heading = "hold",
		
	-- 	--centerBendY = -9,
	-- 	separationBendY = 16,
	-- },
	{
		name = "enter", -- name = for debugging
		beats = 4.5, -- 2-6
		centerX = 86,
		centerY = 50,
		separationX = 58,
		separationY = -14,
		centerBendY = -4,
		separationBendY = 6,
	},
	{
		name = "shorthold", -- name = for debugging
		beats = 0.5, -- 6-8
		centerX = 86,
		centerY = 50,
		separationX = 58,
		separationY = -14,
		heading = "hold",
	},
	{
		name = "promenade", -- name = for debugging
		beats = 4, -- duration
		centerX = 98,
		centerY = 48,
		separationX = 54,
		separationY = -8,
		centerBendY = -6,
	},
	{
		name = "reject",
		beats = 4,
		centerX = 98,
		centerY = 50,
		separationX = 30,
		separationY = 2,
		centerBendX = 5,
		centerBendY = 2,
	},
	{
		name = "chase1",
		beats = 4,
		centerX = 86,
		centerY = 50,
		separationX = -34,
		separationY = 6,
		separationMode = "polar",
	},
	{
		name = "chase2",
		beats = 4,
		centerX = 78,
		centerY = 52,
		separationX = -36,
		separationY = -6,
		centerBendX = -6,
		centerBendY = 3,
	},
	{
		name = "twirl",
		beats = 6,
		centerX = 84,
		centerY = 50,
		separationX = -36,
		separationY = -6,
		separationMode = "polar",
		separationTurns = 1,
	},
	{
		name = "standoff",
		beats = 2,
		centerX = 84,
		centerY = 50,
		separationX = -36,
		separationY = -6,
	},
	{
		name = "kith",
		beats = 2,
		centerX = 86,
		centerY = 50,
		separationX = 58,
		separationY = -14,
		centerBendY = -5,
	},
	{
		name = "finale",
		beats = 4, -- scene beats 64-72
		centerX = 86,
		centerY = 50,
		separationX = 240,
		separationY = -58,
		separationMode = "polar",
		selfTurns = 3,
	}
}

EvokeSoloDance_shipDefs = {
	{
		sprite = "TEvoke_Ship_01",
		width = 20,
		height = 32,
		color = 3,
		trailGradient = { 0, 1, 2, 3, 4 },
	},
	{
		sprite = "TEvoke_Ship_04",
		width = 11,
		height = 22,
		color = 5,
		trailGradient = { 0, 7, 7, 6, 5 },
	},
}

EvokeSoloDance_cycleBeats = 0
EvokeSoloDance_shipStates = nil

-- 
function EvokeSoloDance_LocalBeat(sceneBeat)
	local danceBeat = sceneBeat - EvokeSoloDance_startBeat
	danceBeat = danceBeat * 0.5
	if danceBeat <= 0 then
		return 0
	end
	return math.min(danceBeat, EvokeSoloDance_cycleBeats)
end

function EvokeSoloDance_SamplePositions(sceneBeat)
	local danceBeat = EvokeSoloDance_LocalBeat(sceneBeat)
	local centerX = EvokeSoloDance_initialPose.centerX
	local centerY = EvokeSoloDance_initialPose.centerY
	local separationX = EvokeSoloDance_initialPose.separationX
	local separationY = EvokeSoloDance_initialPose.separationY
	local moveStartBeat = 0

	for moveIndex, move in ipairs(EvokeSoloDance_moves) do
		local moveEndBeat = moveStartBeat + move.beats
		local targetCenterX = move.centerX or centerX
		local targetCenterY = move.centerY or centerY
		local targetSeparationX = move.separationX or separationX
		local targetSeparationY = move.separationY or separationY

		if danceBeat <= moveEndBeat or moveIndex == #EvokeSoloDance_moves then
			local rawT = clamp01((danceBeat - moveStartBeat) / move.beats)
			local t = rawT -- could ease here; not necessary.
			local bendT = 4 * t * (1 - t) -- quad curve up and down (x=0=0; 1=1; 0.5=1)
			local sampledCenterX = lerpScalar(centerX, targetCenterX, t) + (move.centerBendX or 0) * bendT
			local sampledCenterY = lerpScalar(centerY, targetCenterY, t) + (move.centerBendY or 0) * bendT
			local sampledSeparationX
			local sampledSeparationY
			local angleModRadians = move.selfTurns and (move.selfTurns * 6.283 * t) or 0

			if move.separationMode == "polar" then
				local radius0 = math.sqrt(separationX * separationX + separationY * separationY)
				local radius1 = math.sqrt(targetSeparationX * targetSeparationX + targetSeparationY * targetSeparationY)
				local angle0 = math.atan2(separationY, separationX)
				local angle1 = math.atan2(targetSeparationY, targetSeparationX)
				local angleDiff = (angle1 - angle0 + math.pi) % 6.283 - math.pi
				local angle = angle0 + (angleDiff + (move.separationTurns or 0) * 6.283) * t
				local radius = lerpScalar(radius0, radius1, t)
				sampledSeparationX = math.cos(angle) * radius
				sampledSeparationY = math.sin(angle) * radius
			else
				sampledSeparationX = lerpScalar(separationX, targetSeparationX, t)
				sampledSeparationY = lerpScalar(separationY, targetSeparationY, t)
			end

			sampledSeparationX = sampledSeparationX + (move.separationBendX or 0) * bendT
			sampledSeparationY = sampledSeparationY + (move.separationBendY or 0) * bendT

			return
				sampledCenterX - sampledSeparationX * 0.5,
				sampledCenterY - sampledSeparationY * 0.5,
				sampledCenterX + sampledSeparationX * 0.5,
				sampledCenterY + sampledSeparationY * 0.5,
				angleModRadians,
				angleModRadians,
				moveIndex,
				moveStartBeat
		end

		centerX = targetCenterX
		centerY = targetCenterY
		separationX = targetSeparationX
		separationY = targetSeparationY
		moveStartBeat = moveEndBeat
	end
end

function EvokeSoloDance_GetShipPosition(shipIndex, sceneBeat)
	local x1, y1, x2, y2 = EvokeSoloDance_SamplePositions(sceneBeat)
	if shipIndex == 1 then
		return x1, y1
	end
	return x2, y2
end

function EvokeSoloDance_ResetShipStates(sceneBeat)
	EvokeSoloDance_shipStates = {}
	for i=1, #EvokeSoloDance_shipDefs do
		local x, y = EvokeSoloDance_GetShipPosition(i, sceneBeat)
		EvokeSoloDance_shipStates[i] = {
			x = x,
			y = y,
			velocityX = 0,
			velocityY = 0,
			rotation = 0,
			angularVelocity = 0,
			lastHeading = 0,
		}
	end
end

function EvokeSoloDance_UpdateShipState(shipIndex, targetX, targetY, angleModRadians, move, deltaBeats)
	local state = EvokeSoloDance_shipStates[shipIndex]
	assert(type(angleModRadians) == "number", "angleModRadians must be a number")
	state.x, state.velocityX = AdvanceSpring(
		state.x,
		state.velocityX,
		targetX,
		EvokeSoloDance_damping.position,
		deltaBeats,
		EvokeSoloDance_damping.maxStepBeats
	)
	state.y, state.velocityY = AdvanceSpring(
		state.y,
		state.velocityY,
		targetY,
		EvokeSoloDance_damping.position,
		deltaBeats,
		EvokeSoloDance_damping.maxStepBeats
	)

	local speedSquared = state.velocityX * state.velocityX + state.velocityY * state.velocityY
	local headingThreshold = EvokeSoloDance_damping.headingSpeedThreshold
	if move.heading ~= "hold" and speedSquared >= headingThreshold * headingThreshold then
		local rawHeading = math.atan2(state.velocityY, state.velocityX) + math.pi * 0.5
		rawHeading = rawHeading + angleModRadians
		state.lastHeading = UnwrapAngleNear(state.lastHeading, rawHeading)
	end

	state.rotation, state.angularVelocity = AdvanceSpring(
		state.rotation,
		state.angularVelocity,
		state.lastHeading,
		EvokeSoloDance_damping.rotation,
		deltaBeats,
		EvokeSoloDance_damping.maxStepBeats
	)
	return state
end

function EvokeSoloDanceInit()
	EvokeSoloDance_cycleBeats = 0
	for _, move in ipairs(EvokeSoloDance_moves) do
		EvokeSoloDance_cycleBeats = EvokeSoloDance_cycleBeats + move.beats
	end
	EvokeSoloDance_shipStates = nil
end

function EvokeSoloDanceTick(somaticState, sceneTime)
	if sceneTime.demoBeats < EvokeSoloDance_startBeat then
		return
	end

	local x1, y1, x2, y2, a1, a2, moveIndex, moveStartBeat = EvokeSoloDance_SamplePositions(sceneTime.demoBeats)
	assert(#EvokeSoloDance_shipDefs == 2, "dance assumes 2 ships")
	if EvokeSoloDance_shipStates == nil or somaticState.didSeek then
		EvokeSoloDance_ResetShipStates(sceneTime.demoBeats)
	end
	local deltaBeats = math.max(0, somaticState.demoDeltaBeats)
	PushClipRect(
		EvokeSoloDance_stage.x,
		EvokeSoloDance_stage.y,
		EvokeSoloDance_stage.w,
		EvokeSoloDance_stage.h
	)
	for i, shipDef in ipairs(EvokeSoloDance_shipDefs) do
		local targetX = i == 1 and x1 or x2
		local targetY = i == 1 and y1 or y2
		local angleMod = i == 1 and a1 or a2
		local state = EvokeSoloDance_UpdateShipState(
			i,
			targetX,
			targetY,
			angleMod,
			EvokeSoloDance_moves[moveIndex],
			deltaBeats
		)
		drawSpriteWithRotationAsMask(
			shipDef.sprite,
			(state.x - shipDef.width * 0.5) // 1,
			(state.y - shipDef.height * 0.5) // 1,
			state.rotation,
			shipDef.color
		)
	end
	PopClipRect()

	--#ifdef DEBUG
	AddHudMessage(string.format(
		"dance %d %s %.2f/%.2f",
		moveIndex,
		EvokeSoloDance_moves[moveIndex].name,
		EvokeSoloDance_LocalBeat(sceneTime.demoBeats) - moveStartBeat,
		EvokeSoloDance_moves[moveIndex].beats
	))
	--#endif
end
