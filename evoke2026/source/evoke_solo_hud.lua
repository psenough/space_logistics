
Solo_particleGradients = {
	{ 8,7,6,5 }, -- greens
	{ 8,9,10,11 }, -- blues
	{1,1,2,3,4},-- red-yellow
}

Solo_starfieldGradient =  { 0, 8, 15, 9 }


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

-- because i will change the max row count i need to accumulate emitted cell coords rather than calculate realtime
Solo_lastShapeEmissionColumn = nil
Solo_lastShapeEmissionRow = nil

function Solo_EmitShape(maxRows, sceneTime)
    local areaX = 19
    local areaY = 11
    local areaW = 160
    local eventsPerRow = 17
    local eventWidth = 7-- areaW / eventsPerRow // 1
    local eventStrideX = 8
    local eventHeight = 7-- eventWidth
    local eventStrideY = 8
    --local eventSeq = #Solo_shapes -- melEvent.count - 1
    --local row = ((eventSeq / eventsPerRow) // 1) % maxRows
    --local col = eventSeq % eventsPerRow

    -- advance & find a column/row for this shape


    if Solo_lastShapeEmissionColumn == nil then
        Solo_lastShapeEmissionColumn = 0
        Solo_lastShapeEmissionRow = 0
    else
        Solo_lastShapeEmissionColumn = Solo_lastShapeEmissionColumn + 1
        if Solo_lastShapeEmissionColumn >= eventsPerRow then
            Solo_lastShapeEmissionColumn = 0
            Solo_lastShapeEmissionRow = (Solo_lastShapeEmissionRow + 1) % maxRows
        end
    end

    local col = Solo_lastShapeEmissionColumn
    local row = Solo_lastShapeEmissionRow

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
            if fadeT < -1 then -- let go into negative to allow beat pulses to revive it.
                -- remove this; assume this is the first shape in the list (oldest)
                table.remove(Solo_shapes, 1)
            else
                --fadeT = fadeT ^ 2
                -- pulse on beat.
                local pulseT = ((sceneTime.demoBeats + 1) % 2)
                pulseT = pulseT ^ 2
                pulseT = 1 - pulseT
                pulseT = pulseT * 0.3
                fadeT = (fadeT * 1.25) + pulseT -- make pop more on beat
                fadeT = clamp01(fadeT) ^ 2
                rectWithFadeToBlack(x, y, eventWidth, 6, color, fadeT) -- uh does this render wrong dimensions ? 
                -- carve out a 7x7 heart
                --          .xx.xx.   1,2,3
                --          xxxxxxx
                --          xxxxxxx
                --          .xxxxx.   4,5
                --          ..xxx..   6,7, 8,9
                --          ...x...
                pix(x, y, 0) -- 1
                pix(x + 3, y, 0) -- 2
                pix(x + 6, y, 0) -- 3

                pix(x, y + 3, 0) -- 4
                pix(x + 6, y + 3, 0) -- 5

                pix(x + 0, y + 4, 0) -- 6
                pix(x + 1, y + 4, 0) -- 7
                pix(x + 5, y + 4, 0) -- 8
                pix(x + 6, y + 4, 0) -- 9

                pix(x + 0, y + 5, 0)
                pix(x + 1, y + 5, 0)
                pix(x + 2, y + 5, 0)
                pix(x + 4, y + 5, 0)
                pix(x + 5, y + 5, 0)
                pix(x + 6, y + 5, 0)

                -- pix(x + eventWidth - 1, y, 0)
                -- pix(x, y + eventHeight - 1, 0)
                -- pix(x + eventWidth - 1, y + eventHeight - 1, 0)
            end
        end
    }
end

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
            local emitCount = melEvent.justHit and 1 or 0

            local maxRows = 1

            -- after trill note, emit on every row and ignore row max
            if sceneTime.demoBeats > 64 and sceneTime.demoBeats <= 69 then
                maxRows = 100
                emitCount = 4
            end

            for i=1, emitCount do
                Solo_EmitShape(maxRows, sceneTime)
            end
        end
    }
}

Solo_Stars = {}
Solo_StarSequence = 0

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
    Solo_lastShapeEmissionColumn = nil
    Solo_lastShapeEmissionRow = nil
    EvokeSoloDanceInit()

    Solo_Stars = {}
    Solo_StarSequence = 0
end

Solo_StarfieldArea = { x=9, y=9, w=156, h=90 }

function Solo_EmitStar(somaticState, sceneTime)
    -- take next y position.
    local distRand = math.random()
    local y01 = math.random()
    local star = {
        x = Solo_StarfieldArea.x,
        y = Solo_StarfieldArea.y + y01 * Solo_StarfieldArea.h,
        speed = lerpScalar(0.02, 0.08, distRand) * 0.5,
        strength = lerpScalar(0.5, 1.0, distRand),
    }

    -- diminish strength as y increases.
    star.strength = star.strength * (1 - y01 ^ 3  * 0.5)

    Solo_Stars[#Solo_Stars + 1] = star
    Solo_StarSequence = Solo_StarSequence + 1
end

function Solo_UpdateStars(somaticState, sceneTime)
    for i=#Solo_Stars,1,-1 do
        local star = Solo_Stars[i]
        star.x = star.x + star.speed * somaticState.demoDeltaMillis
        if star.x > Solo_StarfieldArea.x + Solo_StarfieldArea.w then
            table.remove(Solo_Stars, i)
        end
    end
end

function Solo_RenderStars()
    local lineLength = 12
    for i, star in ipairs(Solo_Stars) do
        hlineBayerGradient(star.x - lineLength, star.x, star.y, Solo_starfieldGradient, 0,star.strength)-- star.strength)
        --hlineBayerGradient(10,90, 20, Solo_starfieldGradient, 1,1)-- star.strength)
    end
end

function SoloTick(_, _, somaticState, sceneTime)
	cls()
	drawSprite("EHUD_HUD",0,0)

    --#if DEBUG
    AddHudMessage(string.format("sceneBeat=%.2f starcount=%d", sceneTime.demoBeats, #Solo_Stars))
    --#endif

    --"tic assist" corner.
	drawSprite("EHUD_TicA_extra",188,14)
	local id = sceneTime.wallMillis//60%10+1 -- math.random(2)+1
	local spr_id1 = "EHUD_TicA_"..string.format("%02d", id)
	drawSprite(spr_id1,191,24)

    Solo_UpdateStars(somaticState, sceneTime)

    if somaticState.demoDeltaMillis > 0 and math.random() < 0.03 then -- don't emit during pause.
        Solo_EmitStar(somaticState, sceneTime)
    end
    Solo_RenderStars()

    -- melody line
    --local logoFlash = QuerySideChannelPart(somaticState, "melody")

    UpdateSequencer(Solo_sequencer, somaticState, sceneTime)

    -- render shapes behind the orbit particle system
    for i, shape in ipairs(Solo_shapes) do
        shape.fn(somaticState, sceneTime)
    end

    -- not only for animation; this is required to call this to make sure new particles have computed fields.
    SetParticleOrbitEffectBias(Solo_orbitFx, Solo_orbitBaseInclination + sin(sceneTime.wallMillis * 0.001) * 0.1, Solo_orbitFx.biasAscendingNode, 0.995)
    UpdateParticleOrbitEffect(Solo_orbitFx)
    RenderParticleOrbitEffect(Solo_orbitFx, 87,64+30, false)
    RenderParticleOrbitEffect(Solo_orbitFx, 87,64+30, true)

    EvokeSoloDanceTick(somaticState, sceneTime)

    -- too busy.
    --DrawMarchingAntsRect(8, 9, 156, 113, 4, sceneTime.demoMillis * 0.01, 7, 0)

end

