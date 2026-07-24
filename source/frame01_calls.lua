
function drawSprite(spr_id,x,y)
	local posx = x
	local posy = y
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for x=0,w-1 do
		for y=0,h-1 do
				local col = c[x+y*w]
				if (col ~= bkg) then pix(posx+x,posy+y,col) end
		end
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
	print(doorlight_id,0,0,12)
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
						if (dx/2+20+math.sin(dy*dx/14+time()/800)*30)/70 > 1 then
							dc=col2
						end
						pix(dx,dy,dc)
				end
		end
	end
end

function Frame01(t)
--	drawSprite("Arrow",50,50)
 cls()
 local rate=0.3
 local sceneX=100-t/20*rate
	local posGateX=sceneX+60+t/30*rate
	local posGateY=0
	local posShipX=sceneX+t/15*rate
	local posShipY=130-t/50*rate
	drawSprite("BgDither",posGateX,posGateY)
	--drawSprite("DoorLight",posGateX+12,posGateY+28)
	--drawSprite("Door",posGateX+38,posGateY+18)
	drawDoorOpenAnim(t,1000,3000,posGateX+53,posGateY+22)
	
	if (t<1200) then
		drawSprite("Ship01",posShipX,posShipY)
	else
	 drawSpriteD("Ship01","Ship02",posShipX,posShipY)
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

-- drawSprite("Arrow",posShipX,30+posShipY)
 
	drawSprite("Logo",10,96)
	drawSprite("LogoBackdrop",0,4)

end