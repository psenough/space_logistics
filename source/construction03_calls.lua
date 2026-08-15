
C03_st=0

function Construction03_init()
	C03_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end


local C03_sprites = {
	{"C3_Element_01",200,0,1},
	{"C3_Element_02",200,-80,1},
	{"C3_Element_03",240,-120,1},
	{"C3_Element_03",40,-30,1},
	{"C3_Element_04",150,0,1},
	{"C3_Element_04",170,-150,1},
	{"C3_Element_05",360,-100,1},
	{"C3_Element_06",400,-130,1},
	{"C3_Element_07",620,-340,1},
	{"C3_Element_02",500,-300,1},
	{"C3_Element_05",280,-220,1},
	{"C3_Element_04",370,-400,1},
}


function Construction03(tt)

	local t = (tt - C03_st)
	math.randomseed(t)

	cls()

	drawSprite("C3_Bg_ditter",0,0)

	local it = 1

	-- draw sprites
	for i=1,#C03_sprites do
		-- update
		C03_sprites[i][2] = C03_sprites[i][2] - it*C03_sprites[i][4]
		if C03_sprites[i][2] < -200 then
			C03_sprites[i][2] = C03_sprites[i][2] + 500
		end
		C03_sprites[i][3] = C03_sprites[i][3] + it*C03_sprites[i][4]*.3
		if C03_sprites[i][3] > 140 then
			C03_sprites[i][3] = C03_sprites[i][3] - 500
		end
		
		-- draw
		drawSprite(C03_sprites[i][1],C03_sprites[i][2],C03_sprites[i][3])
	end

	local shipPosX=30+math.sin(time()/2000)*2
	local shipPosY=20+math.sin(time()/1000)*2

	drawSprite("C3_BigShip",shipPosX,shipPosY)

end
