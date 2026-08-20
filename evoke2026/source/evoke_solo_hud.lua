
Solo_particleGradients = {
	{ 8,7,6,5 }, -- greens
	{ 8,9,10,11 }, -- blues
	{1,1,2,3,4},-- red-yellow
}


Solo_darkGrayGradient = { 15,15,15, 15, 14 } -- grayscale (+12 bright white)
Solo_grayGradient = { 0,15,15, 15, 14, 13 } -- grayscale (+12 bright white)
Solo_redYellowGradient = { 0, 1, 2, 3, 4 } -- red-yellow
Solo_blueGradient = { 8, 8, 8, 8, 9,  9, 10 } -- blue (+11 bright cyan)
Solo_greenGradient = { 7,7, 7, 7, 6, 5 } -- green
Solo_greenGradientDarker = { 7,7, 7, 7, 6 } -- green

Solo_sequencer = nil
Solo_orbitFx = nil
Solo_orbitBaseInclination = nil
Solo_shapes = nil

Solo_sequenceDef = {
    {
        tick = function(seqItem, somaticState, seqTiming)
        -- blinking logo state update.
        local logoFlash = QuerySideChannelPart(somaticState, "introAccent")
        if logoFlash.hasHit then
            local timeSinceAccent = logoFlash.sinceMillis
            -- fade out over 1/4 second.
            local fadeT = clamp01(timeSinceAccent / 250)
            fadeT = fadeT ^4
            drawSpriteWithFadeIn("EHUD_Logo",40,40, 1 - fadeT)
            end
         end
    },
    {
        trigger = SeqTriggerOnSideChannel("melody"), -- when melody starts, fade in orbit particle system
        tick = function(seqItem, somaticState, seqTiming, sceneTime)

            -- update orbit particle effect.
            local targetCount = 1500
            local fill01 = clamp01(Solo_orbitFx.particleCount / targetCount)
            if fill01 < 1 then
                -- at first, add few particles. later add in bigger batches.
                local batchSize = lerpScalar(1, 100, fill01 ^ 1.2) // 1
                --AddHudMessage(string.format("adding %d particles; count=%d; f01=%.2f", batchSize, Solo_orbitFx.particleCount, fill01))
                for i=1, batchSize do 
                    AddParticleToOrbitEffect(Solo_orbitFx)
                    Solo_orbitFx.particleCount = Solo_orbitFx.particleCount + 1
                end
            end

            -- draw geometry.
            local melEvent = QuerySideChannelPart(somaticState, "melody")
            if melEvent.justHit then

                local areaX = 19
                local areaY = 11
                local areaW = 160
                local eventsPerRow = 17
                local maxRows = 4
                local eventWidth = 7-- areaW / eventsPerRow // 1
                local eventStrideX = 8
                local eventHeight = 3-- eventWidth
                local eventStrideY = 4
                local eventSeq = melEvent.count - 1
                local row = ((eventSeq / eventsPerRow) // 1) % maxRows
                local col = eventSeq % eventsPerRow
                local x = areaX + col * eventStrideX
                local y = areaY + row * eventStrideY
                local color = math.random(2,11)
                local startSceneBeat = sceneTime.demoBeats
                -- add a rect
                Solo_shapes[#Solo_shapes+1] = {
                    fn = function (somaticState, sceneTime)
                        --rect(x, y, 15, 15, color)
                        local age = sceneTime.demoBeats - startSceneBeat
                        -- rev lerp over 4 beats to fade out
                        local fadeT = 1 - (age / 8)
                        if fadeT > -1 then
                            fadeT = fadeT ^ 2
                            -- pulse on beat.
                            local pulseT = ((sceneTime.demoBeats + 1) % 2)
                            pulseT = pulseT ^ 2
                            pulseT = 1 - pulseT
                            pulseT = pulseT * 0.5
                            fadeT = fadeT + pulseT
                            rectWithFadeToBlack(x, y, eventWidth, eventHeight, color, fadeT)
                        end
                    end
                }
            end
        end
    }
}

function SoloInit()
    Solo_sequencer = CreateSequencer(Solo_sequenceDef)
    Solo_orbitFx = CreateParticleOrbitEffect({
        particleCount = 0,
        orbitRadiusMin = 20,
        orbitRadiusMax = 80,
        speedMin = -0.001,
        speedMax = -0.01,
        gradients = { Solo_blueGradient, Solo_greenGradient, Solo_redYellowGradient },
        biasInclination = -1.75,
        biasAscendingNode = -0.3,
    })
	Solo_orbitBaseInclination = Solo_orbitFx.biasInclination
    Solo_shapes = {}
end

function SoloTick(_, _, somaticState, sceneTime)
	cls()
	drawSprite("EHUD_HUD",0,0)

    --"tic assist" corner.
	drawSprite("EHUD_TicA_extra",188,14)
	local id = sceneTime.wallMillis//60%10+1 -- math.random(2)+1
	local spr_id1 = "EHUD_TicA_"..string.format("%02d", id)
	drawSprite(spr_id1,191,24)


    -- melody line
    --local logoFlash = QuerySideChannelPart(somaticState, "melody")

    UpdateSequencer(Solo_sequencer, somaticState, sceneTime)

    -- not only for animation; this is required to call this to make sure new particles have computed fields.
    SetParticleOrbitEffectBias(Solo_orbitFx, Solo_orbitBaseInclination + sin(sceneTime.wallMillis * 0.001) * 0.1, Solo_orbitFx.biasAscendingNode, 0.995)
    UpdateParticleOrbitEffect(Solo_orbitFx)
    RenderParticleOrbitEffect(Solo_orbitFx, 87,64+25, false)
    RenderParticleOrbitEffect(Solo_orbitFx, 87,64+25, true)

    -- render shapes.
    for i, shape in ipairs(Solo_shapes) do
        shape.fn(somaticState, sceneTime)
    end

    -- // todo dancing spaceships along top 80 px of hud area
    if sceneTime.demoBeats > 8 then
        drawSpriteWithRotationAsMask(TEvoke_ships[1][4], 45, 45, sceneTime.demoMillis * 0.003, 3)
        drawSpriteWithRotationAsMask(TEvoke_ships[2][4], 107, 30, sceneTime.demoMillis * -0.001, 5)
    end

    DrawMarchingAntsRect(8, 9, 156, 113, 4, sceneTime.demoMillis * 0.01, 7, 0)

end

