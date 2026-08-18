
EndScene_st=0

function EndScene_init()
	EndScene_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	TwinkleSetStarPositions({
		{ 167,32 },
		{ 18,100 },
		{ 62, 20 },
		{ 152, 60 },
		{ 200, 30 }})
end

function EndScene(tt, _, somaticState, sceneTime)

	local t = (tt - EndScene_st)

	vbank(0)
	-- cant use cls() on vbank0 because of optimization
	-- gradually hide the sun
	if t < 1000 then
		RenderSun(65,61, 8, { 12,4,3,2,1,3,4 }, t)
	elseif t < 2000 then
		RenderSun(65,61, 8, { 12,4,3,0,0,0,4 }, t)
	elseif t < 3000 then
		RenderSun(65,61, 8, { 12,4,0,0,3 }, t)
	elseif t < 4000 then
		RenderSun(65,61, 8, { 3,4,0,0,1 }, t)
	elseif t < 5000 then
		RenderSun(65,61, 8, { 3,2,0,0,1 }, t)
	elseif t < 6000 then
		RenderSun(65,61, 8, { 1,2,0,0,1 }, t)
	elseif t < 7000 then
		RenderSun(65,61, 8, { 0,1,0,1 }, t)
	else
		cls()
	end

	vbank(1)
	cls()
	math.randomseed(123)
	stars_side(10000+t,0,0)
	math.randomseed(t)

	local moonX = 10
	local moonY = 10
	drawSprite("End_Moon",moonX,moonY)
	if t > 7000 then drawSprite("End_Moon_Lights",moonX+7,moonY+8) end

	local planetX = 68
	local planetY = 34
	drawSprite("End_Planet",planetX,planetY)
	if t > 7000 then drawSprite("End_Planet_Lights",planetX+1,planetY+6) end

	local sat1X = 44
	local sat1Y = 80
	drawSprite("End_Sat_03",sat1X,sat1Y)

	local sat2X = 90
	local sat2Y = 40
	drawSprite("End_Sat_01",sat2X,sat2Y)

	local sat3X = 174-t/5000
	local sat3Y = 10
	drawSprite("End_Sat_02",sat3X,sat3Y)


	if t > 10000 then	
		drawSprite("End_LogoLines",0,0)
		drawSprite("End_ORing2",41,38)
		drawSprite("End_Title",37,44)
		circb(65,61,10,12)
		pix(65,61,12)
	end

	TwinkleTick(somaticState, "starz")
	vbank(0)
end
