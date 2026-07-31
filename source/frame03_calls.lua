
function drawShadowSprite(spr_id,x,y,mode)
	local posx = x
	local posy = y
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		for x=y%2,w-1,mode do
				local col = c[x+y*w]
				if (col ~= bkg) then pix(posx+x,posy+y,col) end
		end
	end
end

function drawFrame03_Ship(t,x,y)
	local mode = t//30%3
	if mode > 0 then 
		drawShadowSprite("Frame03_Ship_Shadow",x,y+80,mode)
	end
	drawSprite("Frame03_Ship",x,y)
	--left
	local jet_id1 = t//60%3+1 -- math.random(2)+1
	local spr_id1 = "Jet_Sprite_"..string.format("%02d", jet_id1)
	drawSprite(spr_id1,x-18,y+35)
	--right
	local jet_id2 = (t//60+1)%3+1 -- math.random(2)+1
	local spr_id2 = "Jet_Sprite_"..string.format("%02d", jet_id2)
	drawSprite(spr_id2,x+10,y+52)
end


function drawIsoSlab(posx,posy,uy,ux,c)
	local wx = 10
	local wy = 7
	local t1x = posx
	local t1y = posy
	local t2x = posx-wx*ux
	local t2y = posy+wy*ux
	local t3x = posx+wx*uy
	local t3y = posy+wy*uy
	local t4x = posx+wx*(uy-ux)
	local t4y = posy+wy*(uy+ux)
	
	tri(t1x,t1y,t2x,t2y,t3x,t3y,c)
	tri(t2x,t2y,t3x,t3y,t4x,t4y,c)

	if math.random()<.4 then
		line(t1x,t1y+2,t2x+4,t2y,0)
	end
	if math.random()<.4 then
		line(t1x,t1y+3,t3x-1,t3y+3,0)
	end
	if math.random()<.2 then
		line((t1x+t2x)/2+2,(t1y+t2y)/2,(t3x+t4x)/2,(t3y+t4y)/2-2,0)
	end
	if math.random()<.2 then
		line((t4x+t2x)/2,(t4y+t2y)/2+2,(t3x+t1x)/2,(t3y+t1y)/2,0)
	end
end


local slabs = {
	{50,50,4,6,7},
	{140,50,7,6,8},
	{10,0,5,4,8},
	{55,-35,5,4,9},
	{160,-30,12,6,9},
	{110,-90,6,6,2},
	{300,-180,5,10,7},
	{410,-180,10,8,8},
	{230,-80,5,6,6},
	{290,-40,10,6,7},
	{360,-90,2,4,2},
	{300,-300,10,8,6},
	{496,-290,3,17,7},
	{570,-290,8,7,2},
	{570,-400,4,5,6},
	{715,-395,5,14,7},
	{410,-400,5,12,9},
	{420,-450,6,2,9},
}

local Frame03_sprites = {
	{"Beam",400,-400,2},
	{"ContainerGrey",530,-300,1},
	{"ContainerRed",620,-530,1},
	{"ContainerSmall_01",380,-300,1},
	{"ContainerSmall_01",430,-350,1}
}

function Frame03(t)
	cls()
	math.randomseed(1)

	local tt=1
	-- draw slabs
	for i=1,#slabs do
		-- update
		slabs[i][1]=slabs[i][1] - tt
		if slabs[i][1] < -100 then
			slabs[i][1] = slabs[i][1] + 500
		end
		slabs[i][2]=slabs[i][2] + tt
		if slabs[i][2] > 140 then
			slabs[i][2] = slabs[i][2] - 500
		end
		
		-- draw
		local posx = slabs[i][1]
		local posy = slabs[i][2]
		local ux = slabs[i][3]
		local uy = slabs[i][4]
		local c = slabs[i][5]
		drawIsoSlab(posx,posy,ux,uy,c)
	end
	-- draw sprites
	for i=1,#Frame03_sprites do
		-- update
		Frame03_sprites[i][2]=Frame03_sprites[i][2] - tt*Frame03_sprites[i][4]
		if Frame03_sprites[i][2] < -100 then
			Frame03_sprites[i][2] = Frame03_sprites[i][2] + 500
		end
		Frame03_sprites[i][3]=Frame03_sprites[i][3] + tt*Frame03_sprites[i][4]
		if Frame03_sprites[i][3] > 140 then
			Frame03_sprites[i][3] = Frame03_sprites[i][3] - 500
		end
		
		-- draw
		drawSprite(Frame03_sprites[i][1],Frame03_sprites[i][2],Frame03_sprites[i][3])
	end

	drawSprite("BgDitterTop",0,0)
	drawSprite("BgDitterBottom",240-90,136-58)

	local shipPosX=70
	local shipPosY=30

	drawFrame03_Ship(t,shipPosX,shipPosY)

end
