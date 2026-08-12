
C03_st=0

function Construction03_init()
	C03_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

function Construction03(tt)

	local t = (tt - C03_st)
	math.randomseed(t)

	cls()

	drawSprite("C3_Bg_ditter",0,0)

end
