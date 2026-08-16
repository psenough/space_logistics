
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
	math.randomseed(t)

	cls()

	drawSprite("End_Moon",20,40)

	drawSprite("End_Planet",320-174,136-102)
	
	TwinkleTick(somaticState, "starz")
end
