
C01_st=0

function Construction01_init()
	C01_st = time()
end

function Construction01(tt)

	local t = (tt - C01_st)

	cls()
	
	local sx = t/30
	if sx < 57 then
		drawSprite("C1_Door_02",31-sx,14) -- left
		drawSprite("C1_Door_01",79+sx,11) -- right
	end
	drawSprite("C1_Bg",0,0)
	

end
