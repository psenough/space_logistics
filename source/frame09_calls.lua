
F09_st=0

function Frame09_init()
	F09_st = time()
end

function Frame09(tt)

	local t = (tt - F09_st)

	vbank(0)

	cls()
	drawSprite("F9_BG",0,0)
	
	local sx = t/30

	drawSprite("F9_Suitcase_01",sx,52)
	print("TPOLM",sx+10,76,1,false,1,true)

	drawSprite("F9_Suitcase_02",sx-200,52)
	print("POO-BRAIN",sx-200+66,74,8,false,1,true)

	drawSprite("F9_Suitcase_01",sx-400,52)
	print("RBBS",sx-400+56,96,1,false,1,true)

	drawSprite("F9_Suitcase_01",sx-600,52)
	print("Xenium\n 2026",sx-600+50,90,1,false,1,true)

	drawSprite("F9_Suitcase_02",sx-800,52)


	vbank(1)
	--cls()
	drawSprite("F9_ScannerBG",83,34)

	drawSprite("F9_Suitcase_Scan_01",sx,52)
	print("Spectrox",sx+8,76,6,false,1,true)
	print("Agenda",sx+88,76,6,false,1,true)
	print("Otomata Labs",sx+28,82,6,false,1,true)
	print("The Black Lotus",sx+48,88,6,false,1,true)
	print("Spectrals",sx+68,94,6,false,1,true)
	print("Accession",sx+8,94,6,false,1,true)
	print("Konsumer",sx+28,100,6,false,1,true)

	drawSprite("F9_Suitcase_Scan_02",sx-200,52)
	print("The Twitch Elite",sx-200+48,70,6,false,1,true)
	print("Slipstream",sx-200+28,76,6,false,1,true)
	print("SIMurai",sx-200+108,76,6,false,1,true)
	print("Damage",sx-200+48,82,6,false,1,true)
	print("Forsaken",sx-200+68,88,6,false,1,true)
	print("Marquee Design",sx-200+88,94,6,false,1,true)
	print("Joker",sx-200+28,100,6,false,1,true)

	drawSprite("F9_Suitcase_Scan_01",sx-400,52)
	print("Altair",sx-400+8,76,6,false,1,true)
	print("Abberation Creations",sx-400+28,82,6,false,1,true)
	print("Oftenhide",sx-400+48,88,6,false,1,true)
	print("Dreamweb",sx-400+68,94,6,false,1,true)
	print("Rift",sx-400+8,94,6,false,1,true)
	print("BionFX",sx-400+88,100,6,false,1,true)
	print("Elude",sx-400+28,100,6,false,1,true)

	drawSprite("F9_Suitcase_Scan_01",sx-600,52)
	print("Rabenauge",sx-600+8,76,6,false,1,true)
	print("Abyss Connection",sx-600+28,82,6,false,1,true)
	print("Haujobb",sx-600+48,88,6,false,1,true)
	print("K2",sx-600+88,100,6,false,1,true)
	print("Akronyme Analogiker",sx-600+8,94,6,false,1,true)
	print("Stargaze",sx-600+28,100,6,false,1,true)

	drawSprite("F9_Suitcase_Scan_02",sx-800,52)
	print("... and you!",sx-800+48,88,6,false,1,true)

	-- clip around
	rect(0,0,240,19,0)
	rect(0,19,74,117,0)
	rect(184,19,56,117,0)

	drawSprite("F9_Frame",0,51)
	drawSprite("F9_Scannerframe",73,19)

end
