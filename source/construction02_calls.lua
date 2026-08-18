
function drawSpriteClipLeft(spr_id,posx,posy,clipx)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		for x=clipx,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(posx+x,screenY,col) end
		end
	end
end

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

C02_doors = {
		{50000,50000,"C2_ShipCon_01",0},
		{50000,50000,"C2_ShipCon_01",0},
		{1400,2000,"C2_ShipCon_01",5000},
		{50000,50000,"C2_ShipCon_01",0},
		{10400,11000,"C2_ShipCon_01",14000},
		{50000,50000,"C2_ShipCon_01",0},
		{50000,50000,"C2_ShipCon_01",0}
	}

function Construction02(tt)

	local t = (tt - C02_st)
	math.randomseed(t)

	cls()

	for i=#C02_doors,1,-1 do

		local doorx = ((i-1)*118-100-t/50)//1
		
		-- draw door
		if (t > C02_doors[i][1]) then
			C2_DoorOpenAnim(t,C02_doors[i][1],C02_doors[i][2],(doorx+12)//1,54) 
		else
			drawSprite("C2_Door_02",doorx+15,61)
		end
		
		-- draw rest of the bay
		drawSprite("C2_ShipbgSprite",doorx,0)

		-- draw blinking lights
		if (t > C02_doors[i][1]-2000) and (t < C02_doors[i][2]+2000) then
			if t//120%3 ~= 0 then drawSprite("C2_Lights",doorx+23,52) end
		elseif (t < C02_doors[i][1]-2000) then
			drawSprite("C2_Lights",doorx+23,52)
		end
		-- lights will be off after ship has launched, this is normal

		-- draw ship coming out
		if (t > C02_doors[i][2]) then
			local stpos = doorx+(t-C02_doors[i][2])/30-49
			local ypos = 68+math.sin(t/2000+i*10)*2
			local clip = (64-(t-C02_doors[i][2])/30)//1
			if clip < 0 then clip = 0 end
			if (t > C02_doors[i][4]) then
				-- turn on thrusters
				stpos = stpos + (t - C02_doors[i][4])/20
				circ(stpos,ypos+7,math.random(2),math.random(3)+1)
			end
			if (t > C02_doors[i][1]+3600) then
				drawSpriteClipLeft("C2_ShipCon_01",stpos,ypos,clip)
			else
				drawSpriteClipLeft("C2_ShipCon_02",stpos,ypos,clip)
			end
			--print(doorx//1,doorx,0,12)
		end

	end
end
