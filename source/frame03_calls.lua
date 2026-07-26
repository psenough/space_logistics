
function drawFrame03_Ship(t,x,y)
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
end

local slabs = {
	{50,50,4,6,7},
	{140,50,7,6,8},
	{10,0,5,4,8},
	{55,-35,5,4,9},
	{160,-30,12,6,9},
	{110,-90,6,6,2},
	{300,-180,5,10,7},
	{410,-180,10,8,8}
}

function Frame03(t)
	cls()

	local tt=1
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
	drawSprite("BgDittering",0,0)

	local shipPosX=70
	local shipPosY=30
	drawFrame03_Ship(t,shipPosX,shipPosY)

	drawSprite("Beam",0,0)

end
