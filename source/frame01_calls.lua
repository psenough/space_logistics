function drawSprite(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(posx+x,screenY,col) end
		end
	end
end

function drawSpriteRotated90(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenX = posx+(h-y-1)
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(screenX,posy+x,col) end
		end
	end
end

function drawSpriteRotated180(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+(h-y-1)
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(posx+x,screenY,col) end
		end
	end
end

function drawSpriteRotated270(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenX = posx+y
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(screenX,posy+(w-x-1),col) end
		end
	end
end

-- axis-aligned rotation index.
function drawSpriteWithAARotation(spr_id,posx,posy,rotIndex)
	if rotIndex == 0 then
		drawSprite(spr_id,posx,posy)
	elseif rotIndex == 1 then
		drawSpriteRotated90(spr_id,posx,posy)
	elseif rotIndex == 2 then
		drawSpriteRotated180(spr_id,posx,posy)
	elseif rotIndex == 3 then
		drawSpriteRotated270(spr_id,posx,posy)
	end
end

function drawDoorOpenAnim(t,st,et,x,y)
	local idx = 11
	if t<=st then t=st end
	if t>=et then t=et end
	local door_id = 11-10*((t-st)/(et-st))//1
	--print(door_id,0,0,12)
	local spr_id = "Door_"..string.format("%02d", door_id)
	local w=sprites[spr_id].w
	local h=sprites[spr_id].h
	local tw=53
	local th=64
	local ox=x+(tw-w)/2
	local oy=y+(th-h)
	drawSprite(spr_id,ox,oy)
	-- door light
	local doorlight_id = door_id//2+1
	--print(doorlight_id,0,0,12)
	if doorlight_id <= 5 then
		local sprl_id = "DoorLight_"..string.format("%02d", doorlight_id)
		local dw=sprites[sprl_id].w
		local dh=sprites[sprl_id].h
		local tdw=46
		local tdh=46
		local dx=x-40+(tdw-dw)
		local dy=oy
		drawSprite(sprl_id,dx,dy)
	end
end

function drawSpriteD(spr_id,spr_id2,x,y)
	local posx = x
	local posy = y
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local c2 = sprites[spr_id2].data
	local bkg = sprites[spr_id].bg
	for x=0,w-1 do
		for y=0,h-1 do
				local idx = x+y*w
				local col = c[idx]
				local col2 = c2[idx]
				if (col ~= bkg) then
						local dx=(posx+x)//1
						local dy=(posy+y)//1
						local dc=col
						if (dx/2+20+math.sin(dy*dx/12+(20000-time())/800)*30)/70 > 1 then
							dc=col2
						end
						pix(dx,dy,dc)
				end
		end
	end
end

function stars_side(t,x,y)
	for i=0,50 do
		circ((math.random(240)+x)%240,
			 (math.random(136)+y)%136,
			 math.random()*1.5,
			 (4+math.random(2)//1*8)*math.abs(math.sin(t/math.random(10000))//1)
			)
	end
end

function Frame01(t)

	local dooropen=18000
	local sceneX=t/105
	local sceneY=-t/65
	if sceneX > 220 then sceneX = 220 end
	if sceneY < -310 then sceneY = -310 end

	vbank(0)
	cls()
	math.randomseed(7)
	stars_side(1000+t,-sceneX,-sceneY)

	math.randomseed(t)

	local posGateX=310-sceneX
	local posGateY=-310-sceneY
	local posShipX=65-sceneX+t/66
	local posShipY=50+math.sin(t/8000)*2-sceneY-t/65
	tri(posGateX-40,posGateY,240,0,240,136,0)
	drawSprite("BgDither",posGateX-40,posGateY)
	drawDoorOpenAnim(t,dooropen,dooropen+1600,posGateX+53,posGateY+22)

	-- draw under to get black over stars
	if (t<(dooropen+200)) then
		drawSprite("Ship01",posShipX,posShipY)
	end

	vbank(1)
	cls()
	if (t<(dooropen+200)) then
		drawSprite("Ship01",posShipX,posShipY)
	else
		--drawSpriteD("Ship01","Ship02",posShipX,posShipY)
		drawSprite("Ship02",posShipX,posShipY)
	end
	--else
	-- drawSprite("Ship02",posShipX,posShipY)
	--end
	-- left throttle
	circ(posShipX+2,18+posShipY,math.random(2),math.random(3)+1)
	circ(posShipX,20+posShipY,math.random(2),math.random(2)+1)
	-- right throttle
	circ(posShipX+9,23+posShipY,math.random(3),math.random(3)+1)
	circ(posShipX+7,25+posShipY,math.random(2),math.random(2)+1)

	-- clip right
	rect(posGateX+102,0,100,136,0)
	-- clip top of gate
	tri(posGateX+10,posGateY, 240,0, 240,posGateY+62, 0)

	--if math.random() > 0.5 then	drawSprite("Logo",10,104) end

	drawSprite("Logo",10,104)
	for i=104,140 do
		if math.sin(time()/500+i)*math.sin(time()/400+i*3) > 0 then line(0,i,100,i,0) end
	end
	drawSprite("LogoBackdrop",0,4)

	vbank(0)

end