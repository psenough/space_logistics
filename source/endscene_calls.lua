
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

	drawSprite("End_Moon",20,40)

	drawSprite("End_Planet",320-174,136-102)
	
end
