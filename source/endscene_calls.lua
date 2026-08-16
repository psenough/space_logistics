
EndScene_st=0

function EndScene_init()
	EndScene_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

function EndScene(tt)

	local t = (tt - EndScene_st)
	math.randomseed(t)

	cls()
	math.randomseed(123)
	stars_side(10000+t,0,0)
	math.randomseed(t)

	local moonX = 10
	local moonY = 10
	drawSprite("End_Moon",moonX,moonY)
	drawSprite("End_Moon_Lights",moonX+7,moonY+8)

	local planetX = 68
	local planetY = 34
	drawSprite("End_Planet",planetX,planetY)
	drawSprite("End_Planet_Lights",planetX+1,planetY+6)

	local sat1X = 44
	local sat1Y = 80
	drawSprite("End_Sat_03",sat1X,sat1Y)

	local sat2X = 90
	local sat2Y = 40
	drawSprite("End_Sat_01",sat2X,sat2Y)

	local sat3X = 174-t/5000
	local sat3Y = 10
	drawSprite("End_Sat_02",sat3X,sat3Y)


--	drawSprite("End_LogoLines",0,0)
--	drawSprite("End_ORing2",41,38)
--	drawSprite("End_Title",37,44)
	circb(65,61,10,12)
	pix(65,61,12)
	

end
