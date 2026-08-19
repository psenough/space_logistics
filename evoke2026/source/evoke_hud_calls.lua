--#include "particleTrail1.lua"

Evoke_HUD_variation = nil
Evoke_HUD_faceSequencer = nil
Evoke_HUD_logoSequencer = nil

Evoke_HUD_particleTrails = nil -- bottom logo ones.
Evoke_HUD_particlesEnabled = true

Evoke_HUD_circleParticles = nil -- circle around faces.
Evoke_HUD_circleParticlesEnabled = false

Evoke_HUD_particleGradients = {
	{ 8,7,6,5 }, -- greens
	{ 8,9,10,11 }, -- blues
	{1,2,3,4},-- red-yellow
}

Evoke_HUD_logoSequenceDef = {
	{
		tick = function(seqItem, somaticState, seqTiming)
			drawSprite("EHUD_Logo",40,40)
			Evoke_HUD_particlesEnabled = true
			Evoke_HUD_circleParticlesEnabled = false
		end
	},
	{
		trigger = SeqTriggerOnSideChannel("melBrhythm"),
		tick = function()
			Evoke_HUD_particlesEnabled = false
			Evoke_HUD_circleParticlesEnabled = true
		end
	}
} 

function Evoke_HUD_drawFaces(offset1, offset2, offset3, sceneTime)
	local posy = 40
	drawSprite("EHUD_Oni",30+offset1[1],posy+offset1[2])
	drawSprite("EHUD_ps",75+offset2[1],posy+5+offset2[2])
	drawSprite("EHUD_tenfour",110+offset3[1],posy+offset3[2])
	DrawMarchingAntsRect(8, 9, 156, 113, 4, sceneTime.demoMillis * 0.01, 7, 0)
end

Evoke_HUD_faceSequenceDef = {
	{
		tick = SeqNop,
	},
	{
		trigger = SeqTriggerOnSideChannel("melBrhythm"),
		tick = function(seqItem, somaticState, seqTiming)
			local accent = QuerySideChannelPart(somaticState, "melBrhythm")
			local bonk = accent.count % 2
			local abonk = 1-bonk
			Evoke_HUD_drawFaces({0,bonk*20},{0,abonk*20},{0,bonk*20}, seqTiming)
		end
	},
	{
		--TriggerAlways
		trigger = SeqTriggerOnSideChannel("melody"),
		tick = function(seqItem, somaticState, seqTiming)
			local t = seqTiming.demoMillis
			local offset1 = {sin(t*0.003)*4,sin(t*0.005)*4}
			local offset2 = {sin(t*0.004)*4,sin(t*0.003)*4}
			local offset3 = {sin(t*0.005)*4,sin(t*0.002)*4}
			Evoke_HUD_drawFaces(offset1,offset2,offset3, seqTiming)
		end
	}
}


-- variation
-- "initial"
function Evoke_HUD_init(variation)
	Evoke_HUD_variation = variation

	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	Evoke_HUD_logoSequencer = CreateSequencer(Evoke_HUD_logoSequenceDef)
	Evoke_HUD_faceSequencer = CreateSequencer(Evoke_HUD_faceSequenceDef)
	do
		Evoke_HUD_particleTrails = {}
		local particleCount = 2

		for i=1,particleCount do
			local particleTrail = CreateParticleTrail({
		-- 	-- total hud area:
		-- 	-- areaX = 8,
		-- 	-- areaY = 9,
		-- 	-- areaW = 156,
		-- 	-- areaH = 113,
				areaX = 40,
				areaY = 88+8,
				areaW = 89,
				areaH = 16,
				seed = i,
				--gradient = Evoke_HUD_particleGradients[((i-1) % #Evoke_HUD_particleGradients) + 1],
				gradient = Evoke_HUD_particleGradients[1],
			})
			table.insert(Evoke_HUD_particleTrails, particleTrail)
		end
	end

	do
		Evoke_HUD_circleParticles = {}
		local particleCount = 3
		local margin = 4
		for i=1,particleCount do
			local particleTrail = CreateParticleTrail({
				areaX = 8 + margin + (i * 3 - 5),
				areaY = 9 + margin,
				areaW = 113 - 2*margin,--156 - 2*margin, -- make circle.
				areaH = 113 - 2*margin,
				seed1 = i,
				seed2 = i, -- circular motion.
				gradient = Evoke_HUD_particleGradients[1],
			})
			table.insert(Evoke_HUD_circleParticles, particleTrail)
		end
	end
end

function Evoke_HUD(tt, _, somaticState, sceneTime)

	--local t = (tt - Evoke_HUD_st)
	math.randomseed(sceneTime.demoMillis)

	cls()

	drawSprite("EHUD_HUD",0,0)

	UpdateSequencer(Evoke_HUD_logoSequencer, somaticState, sceneTime)
	UpdateSequencer(Evoke_HUD_faceSequencer, somaticState, sceneTime)

	local variationHasParticles = Evoke_HUD_variation == "initial" -- only enable particles for initial HUD.

	if variationHasParticles and Evoke_HUD_particlesEnabled then
		for i, particleTrail in ipairs(Evoke_HUD_particleTrails) do
			UpdateParticleTrail(particleTrail, somaticState, sceneTime)
		end
	end

	-- these don't look good.
	-- if Evoke_HUD_circleParticlesEnabled then
	-- 	for i, particleTrail in ipairs(Evoke_HUD_circleParticles) do
	-- 		UpdateParticleTrail(particleTrail, somaticState, sceneTime)
	-- 	end
	-- end

	drawSprite("EHUD_TicA_extra",188,14)
	local id = sceneTime.demoMillis//60%10+1 -- math.random(2)+1
	local spr_id1 = "EHUD_TicA_"..string.format("%02d", id)
	drawSprite(spr_id1,191,24)

end
