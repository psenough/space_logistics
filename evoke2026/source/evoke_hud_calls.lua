
--Evoke_HUD_st=0
Evoke_HUD_faceSequencer = nil
Evoke_HUD_logoSequencer = nil

Evoke_HUD_logoSequenceDef = {
	{
		tick = function(seqItem, somaticState, seqTiming)
			drawSprite("EHUD_Logo",40,40)
		end
	},
	{
		trigger = SeqTriggerOnSideChannel("melBrhythm"),
		tick = SeqNop
	}
} 

function Evoke_HUD_drawFaces(offset1, offset2, offset3)
	local posy = 40
	drawSprite("EHUD_Oni",30+offset1[1],posy+offset1[2])
	drawSprite("EHUD_ps",75+offset2[1],posy+5+offset2[2])
	drawSprite("EHUD_tenfour",110+offset3[1],posy+offset3[2])
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
			Evoke_HUD_drawFaces({0,bonk*20},{0,abonk*20},{0,bonk*20})
		end
	},
	{
		trigger = SeqTriggerOnSideChannel("melody"),
		tick = function(seqItem, somaticState, seqTiming)
			local t = seqTiming.demoMillis
			local offset1 = {sin(t*0.003)*4,sin(t*0.005)*4}
			local offset2 = {sin(t*0.004)*4,sin(t*0.003)*4}
			local offset3 = {sin(t*0.005)*4,sin(t*0.002)*4}
			Evoke_HUD_drawFaces(offset1,offset2,offset3)
		end
	}
}


function Evoke_HUD_init()
	Evoke_HUD_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	Evoke_HUD_logoSequencer = CreateSequencer(Evoke_HUD_logoSequenceDef)
	Evoke_HUD_faceSequencer = CreateSequencer(Evoke_HUD_faceSequenceDef)
end

function Evoke_HUD(tt, _, somaticState, sceneTime)

	--local t = (tt - Evoke_HUD_st)
	math.randomseed(sceneTime.demoMillis)

	cls()

	drawSprite("EHUD_HUD",0,0)

	-- if t<6000 then
	-- 	drawSprite("EHUD_Logo",40,40)
	-- else

	-- 	local posy = 40
	-- 	local bonk = t//300%2
	-- 	local abonk = 1-bonk

	-- 	drawSprite("EHUD_Oni",30,posy+bonk*20)

	-- 	drawSprite("EHUD_ps",75,posy+5+abonk*20)

	-- 	drawSprite("EHUD_tenfour",110,posy+bonk*20)
	-- end

	UpdateSequencer(Evoke_HUD_logoSequencer, somaticState, sceneTime)
	UpdateSequencer(Evoke_HUD_faceSequencer, somaticState, sceneTime)

	drawSprite("EHUD_TicA_extra",188,14)
	local id = sceneTime.demoMillis//60%10+1 -- math.random(2)+1
	local spr_id1 = "EHUD_TicA_"..string.format("%02d", id)
	drawSprite(spr_id1,191,24)

end
