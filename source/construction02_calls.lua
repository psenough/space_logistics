
C02_st=0

function Construction02_init()
	C02_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

function Construction02(tt)

	local t = (tt - C02_st)
	math.randomseed(t)

	cls()

		
	drawSprite("C2_ShipbgSprite",200-t,0)
	
	drawSprite("C2_ShipCon_01",t,65)

end
