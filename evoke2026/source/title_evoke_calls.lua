
TEvoke_st=0

function TEvoke_init()
	TEvoke_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

function TEvoke(tt)

	local t = (tt - TEvoke_st)
	math.randomseed(t)

	cls()

	
	drawSprite("TEvoke_bg",0,0)
	

	local shipX = 30
	local shipY = 136-t//60
	drawSprite("TEvoke_Ship_01",shipX,shipY)
	rect(shipX+9,shipY+27,3,170-shipY,10)

	shipX = 10
	shipY = 236-t//50
	drawSprite("TEvoke_Ship_04",shipX,shipY)
	rect(shipX+1,shipY+22,2,170-shipY,10)
	rect(shipX+8,shipY+22,2,170-shipY,10)

	shipX = 160
	shipY = 136-t//40
	drawSprite("TEvoke_Ship_02",shipX,shipY)
	rect(shipX+3,shipY+16,2,170-shipY,10)
	rect(shipX+6,shipY+16,2,170-shipY,10)

	shipX = 210
	shipY = 166-t//60
	drawSprite("TEvoke_Ship_03",shipX,shipY)
	rect(shipX+5,shipY+27,2,170-shipY,10)
	rect(shipX+10,shipY+27,2,170-shipY,10)


	local logX = 5
	local logY = 10

	drawSprite("TEvoke_SpaceAirline_02",logX+189,logY-4)
	drawSprite("TEvoke_SpaceAirline_03",logX+168,logY+27)
	drawSprite("TEvoke_SpaceAirline_04",logX+0,logY+10)
	drawSprite("TEvoke_SpaceAirline_01",logX+30,logY+20)



	local checkX = 10
	local checkY = 60+math.sin(t/300)*8

	drawSprite("TEvoke_Checkingin_01",checkX+40,checkY)
	drawSprite("TEvoke_Checkingin_02",checkX,checkY-12)
	drawSprite("TEvoke_Checkingin_03",checkX+117,checkY-1)

end
