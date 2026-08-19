
Evoke_HUD_st=0

function Evoke_HUD_init()
	Evoke_HUD_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

end

function Evoke_HUD(tt)

	local t = (tt - Evoke_HUD_st)
	math.randomseed(t)

	cls()

	drawSprite("EHUD_HUD",0,0)

	if t<6000 then
		drawSprite("EHUD_Logo",40,40)
	else

		local posy = 40
		local bonk = t//300%2
		local abonk = 1-bonk

		drawSprite("EHUD_Oni",30,posy+bonk*20)

		drawSprite("EHUD_ps",75,posy+5+abonk*20)

		drawSprite("EHUD_tenfour",110,posy+bonk*20)
	end

	drawSprite("EHUD_TicA_extra",188,14)
	local id = t//60%10+1 -- math.random(2)+1
	local spr_id1 = "EHUD_TicA_"..string.format("%02d", id)
	drawSprite(spr_id1,191,24)

end
