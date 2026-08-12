
function C2_DoorOpenAnim(t,st,et,x,y)
	local idx = 11
	if t<=st then t=st end
	if t>=et then t=et end
	local door_id = 1+6*((t-st)/(et-st))//1
	--print(door_id,0,0,12)
	local spr_id = "C2_Door_"..string.format("%02d", door_id)
	local w=sprites[spr_id].w
	local h=sprites[spr_id].h
	local tw=71
	local th=50
	local ox=x+(tw-w)/2
	local oy=y+(th-h)/2
	drawSprite(spr_id,ox,oy)
end

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

	for i=10,0,-1 do

		local doorx = i*118-100-t/60

		if i == 2 then
			C2_DoorOpenAnim(t,1400,2000,(doorx+12)//1,54) 
		else
			drawSprite("C2_Door_01",doorx+15,61)
		end

		drawSprite("C2_ShipbgSprite",doorx,0)

		if i == 2 then
			if t//120%3 ~= 0 then drawSprite("C2_Lights",doorx+23,52) end
		else
			drawSprite("C2_Lights",doorx+23,52)
		end


--		drawSprite("C2_ShipCon_01",t,65)
	end
end
