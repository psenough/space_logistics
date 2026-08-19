
F09_st=0

function Frame09_init()
	F09_st = time()
end

function Frame09(tt)

	local t = (tt - F09_st)

	vbank(0)

	cls()
	drawSprite("F9_BG",0,0)
	
	local sx = -t/20

	local px = sx+200

	drawSprite("F9_Suitcase_01",px,52)
	print("TPOLM",px+10,76,1,false,1,true)

	px = px+200
	drawSprite("F9_Suitcase_02",px,52)
	print("POO-BRAIN",px+66,74,8,false,1,true)

	px = px+200
	drawSprite("F9_Suitcase_01",px,52)
	print("RBBS",px+56,96,1,false,1,true)

	px = px+200
	drawSprite("F9_Alien_01",px,40)
	
	px = px+100
	drawSprite("F9_Suitcase_02",px,52)
	print("Evoke 2026",px+66,74,8,false,1,true)
	
	px = px+200
	drawSprite("F9_Duck_02",px,56)
	
	px = px+100
	drawSprite("F9_Suitcase_01",px,52)
	print("TPOLM",px+10,76,1,false,1,true)

	px = px+200
	drawSprite("F9_Suitcase_02",px,52)
	print("POO-BRAIN",px+66,74,8,false,1,true)
	
	px = px+200
	drawSprite("F9_Suitcase_01",px,52)
	print("RBBS",px+56,96,1,false,1,true)

	px = px+200
	drawSprite("F9_Suitcase_01",px,52)



	vbank(1)
	--cls()
	drawSprite("F9_ScannerBG",83,34)
	
	sx = sx + 200
	drawSprite("F9_ESuitcase_02",sx,52)

	sx = sx + 200
	drawSprite("F9_ESuitcase_03",sx,52)

	sx = sx + 200
	drawSprite("F9_ESuitcase_01",sx,52)

	sx = sx + 200
	drawSprite("F9_Alien_02",sx,40)

	sx = sx + 100
	drawSprite("F9_ESuitcase_04",sx,52)

	sx = sx + 200
	drawSprite("F9_Duck_01",sx,56)

	sx = sx + 100
	drawSprite("F9_Suitcase_Scan_01",sx,52)
	print("Spectrox",sx+8,76,6,false,1,true)
	print("Agenda",sx+88,76,6,false,1,true)
	print("Otomata Labs",sx+28,82,6,false,1,true)
	print("The Black Lotus",sx+48,88,6,false,1,true)
	print("Spectrals",sx+68,94,6,false,1,true)
	print("Accession",sx+8,94,6,false,1,true)
	print("Konsumer",sx+28,100,6,false,1,true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_02",sx,52)
	print("The Twitch Elite",sx+48,70,6,false,1,true)
	print("Slipstream",sx+28,76,6,false,1,true)
	print("SIMurai",sx+108,76,6,false,1,true)
	print("Damage",sx+48,82,6,false,1,true)
	print("Forsaken",sx+68,88,6,false,1,true)
	print("Marquee Design",sx+88,94,6,false,1,true)
	print("Joker",sx+28,100,6,false,1,true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_01",sx,52)
	print("Altair",sx+8,76,6,false,1,true)
	print("Abberation Creations",sx+28,82,6,false,1,true)
	print("Oftenhide",sx+48,88,6,false,1,true)
	print("Dreamweb",sx+68,94,6,false,1,true)
	print("Rift",sx+8,94,6,false,1,true)
	print("BionFX",sx+88,100,6,false,1,true)
	print("Elude",sx+28,100,6,false,1,true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_01",sx,52)
	print("Rabenauge",sx+8,76,6,false,1,true)
	print("Abyss Connection",sx+28,82,6,false,1,true)
	print("Haujobb",sx+48,88,6,false,1,true)
	print("K2",sx+88,100,6,false,1,true)
	print("Akronyme Analogiker",sx+8,94,6,false,1,true)
	print("Stargaze",sx+28,100,6,false,1,true)

	sx = sx + 200
	drawSprite("F9_Suitcase_Scan_02",sx,52)
	print("... and you!",sx+48,88,6,false,1,true)

	-- clip around
	rect(0,0,240,19,0)
	rect(0,19,74,117,0)
	rect(184,19,56,117,0)

	drawSprite("F9_Frame",0,51)
	drawSprite("F9_Scannerframe",73,19)

end
