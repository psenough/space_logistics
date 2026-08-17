--#include "sprite.lua"

function drawDoorOpenAnim(t,st,et,x,y)
	local idx = 11
	if t<=st then t=st end
	if t>=et then t=et end
	local door_id = 11-10*((t-st)/(et-st))//1
	--print(door_id,0,0,12)
	local spr_id = "F1_Door_"..string.format("%02d", door_id)
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
		local sprl_id = "F1_DoorLight_"..string.format("%02d", doorlight_id)
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

function Frame01(tt, demoBeats, somaticState, sceneTiming)
	
	local dooropen=20000
	local t = sceneTiming.demoMillis
	local sceneX=t/105
	local sceneY=-t/75
	if sceneX > 220 then sceneX = 220 end
	if sceneY < -310 then sceneY = -310 end

	vbank(0)
	cls()
	math.randomseed(7)
	stars_side(1000+t,-sceneX,-sceneY)

	math.randomseed(t)

	local posGateX=310-sceneX
	local posGateY=-310-sceneY
	local posShipX=65-sceneX+t/76
	local posShipY=50+math.sin(t/8000)*2-sceneY-t/75
	tri(posGateX-40,posGateY,240,0,240,136,0)
	drawSprite("F1_BgDither",posGateX-40,posGateY)
	drawDoorOpenAnim(t,dooropen,dooropen+1600,posGateX+53,posGateY+22)

	-- draw under to get black over stars
	if (t<(dooropen+200)) then
		drawSprite("F1_Ship01",posShipX,posShipY)
	end

	vbank(1)
	cls()
	if (t<(dooropen+200)) then
		drawSprite("F1_Ship01",posShipX,posShipY)
	else
		drawSprite("F1_Ship02",posShipX,posShipY)
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

	-- mask the sprite entereing the hangar
	drawSprite("F1_GateMask",posGateX-39,posGateY)


	local rowmatch = {
	{0,4},{0,5},{0,7},{0,10},{0,11},{0,12},{0,17},{0,22},{0,23},{0,24},{0,28},{0,29},{0,31},{0,34},{0,35},{0,36},{0,37},{0,39},{0,42},{0,43},{0,44},{0,48},{0,49},{0,51},{0,54},{0,55},{0,56},{0,60},{0,61},{0,63},
	{1,0},{1,1},{1,3},{1,6},{1,7},{1,8},{1,13},{1,18},{1,19},{1,20},{1,24},{1,25},{1,27},{1,30},{1,31},{1,32},{1,37},{1,39},{1,42},{1,43},{1,44},{1,48},{1,49},{1,51},{1,54},{1,55},{1,56},{1,60},{1,61},{1,63},
	{2,0},{2,1},{2,3},{2,6},{2,7},{2,8},{2,13},{2,18},{2,19},{2,20},{2,24},{2,25},{2,27},{2,30},{2,31},{2,32},{2,37},{2,39},{2,42},{2,43},{2,44},{2,48},{2,49},{2,51},{2,54},{2,55},{2,56},{2,60},{2,61},{2,63},
	{3,32},{3,37},{3,39},{3,42},{3,43},{3,44},{3,48},{3,49}
	}
	
	local pat = somaticState.demoPatternIndex
	local row = somaticState.demoPatternRow
	
	if t > 1200 then
		local drawlogo2 = true
		local drawlogo = true
		local drawback = true
		for i=1,#rowmatch do
			dp = rowmatch[i]
			if (dp[1] == pat) and (dp[2] == row) then
				local witch = i%3
				if witch == 0 then drawlogo2 = false end
				if witch == 1 then drawlogo = false end
				drawback = false
				break
			end
		end
		if drawlogo2 then C03_DrawSpriteStripped("F1_Logo02", 12, 74, t) end --drawSprite("F1_Logo02",12,74) end
		if drawlogo then C03_DrawSpriteStripped("F1_Logo",12,104,t+2000) end
		if drawback then drawSprite("F1_LogoBackdrop",0,4) end
	end

	TwinkleTick(somaticState, "starz")

	vbank(0)

end