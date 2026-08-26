
SS_st=0

function SphereScenes_init()
	SS_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

local SS_sprites = {
	{"SS_Stage1_Frame01",0,-0,1},
	{"SS_Stage1_Frame02",350,-80,1},
	{"ContainerRed",640,-230,1},
	{"ContainerSmall_01",140,-120,1},
	{"ContainerSmall_01",170,-100,1},
	{"Beam",250,-200,2}
}

function welder(x,y,t)
	local id = t//60%6+1
	local spr_id1 = "SS_Welder_"..string.format("%02d", id)
	drawSprite(spr_id1,x,y)
end

function welderL(x,y,t)
	local id = t//60%6+1
	local spr_id1 = "SS_Welder_"..string.format("%02d", id)
	drawSpriteFlipH(spr_id1,x,y)
end

function drawWelders(welders,frameRefX,frameRefY,t)
	for i=1,#welders do
		local w = welders[i]
		if t<w[1] then
			welder(frameRefX+w[4],frameRefY+w[5],t)
		elseif t>w[2] then
			local dx = 0
			if w[6] ~= 0 then dx = (w[2]-w[1])//w[6] end
			local dy = 0
			if w[7] ~= 0 then dy = (w[2]-w[1])//w[7] end
			welder(frameRefX+w[4]+dx,frameRefY+w[5]+dy,t)
		else
			local dx = 0
			if w[6] ~= 0 then dx = (t-w[1])//w[6] end
			local dy = 0
			if w[7] ~= 0 then dy = (t-w[1])//w[7] end
			drawSprite("SS_Welder_06",
					frameRefX+w[4]+dx,
					frameRefY+w[5]+dy)
		end
	end
end

SS_sunGradient = { 12,4,3,2,1,2,3,4 }

function RenderSun(cx,cy,r,grad,t)
	local invR = 1 / r
	local phase = t * -0.00017
	local scale = 3+math.sin(t/20000)*2

	-- don't put these in the shader for performance.
	local phasev2 = phase * 1.6 
	local phasev3 = phase * 0.61
	local scalev1 = scale * 9
	local scalev2 = scale * 12
	local scalev3 = scale * 7

	ShadeCircleBayerHack(cx, cy, r, grad, function(screenX, screenY)
		local x = (screenX - cx) * invR -- normalize
		local y = (cy - screenY) * invR
		local z = sqrt(1 - x*x - y*y) -- unit sphere

		local waves =
			sin(scalev1*x + 5*y + phase) +
			sin(scalev2*z - 7*y - phasev2) +
			sin(scalev3*(x + z + y) + phasev3)

		return z * (waves + 2) * 0.5
	end,t)
end

function SphereScenes_Timelapse(tt)

	local t = (tt - SS_st)
	local tl = t*20
	math.randomseed(t)

	--cls()
	vbank(0)
	RenderSun(120, 68, 120, SS_sunGradient, t)


	vbank(1)
	cls()
	local frameRefX = -120+t//120
	local frameRefY = -t//120
	if t<6000 then
		drawSprite("SS_Stage1_Frame03",frameRefX-185,frameRefY)
	else
		drawSprite("SS_Stage2_Frame01",frameRefX-185,frameRefY)
	end

	if t<7000 then
		drawSprite("SS_Stage1_Frame01",frameRefX,frameRefY)
	else
		drawSprite("SS_Stage2_Frame01",frameRefX,frameRefY)
	end

	if t<8000 then
		drawSprite("SS_Stage1_Frame02",frameRefX+185,frameRefY)
	else
		drawSprite("SS_Stage2_Frame02",frameRefX+185,frameRefY)
	end

	if t<9000 then
		drawSprite("SS_Stage1_Frame01",frameRefX+52,frameRefY+105)
	else
		drawSprite("SS_Stage2_Frame01",frameRefX+52,frameRefY+105)
	end

	if t<10000 then
		drawSprite("SS_Stage1_Frame01",frameRefX+52-185,frameRefY+105)
	else
		drawSprite("SS_Stage2_Frame01",frameRefX+52-185,frameRefY+105)
	end

	if t<11000 then
		drawSprite("SS_Stage1_Frame03",frameRefX+52+185,frameRefY+105)
	else
		drawSprite("SS_Stage2_Frame02",frameRefX+52+185,frameRefY+105)
	end
	
	if t<12000 then
		drawSprite("SS_Stage1_Frame03",frameRefX+104-185,frameRefY+210)
	else
		drawSprite("SS_Stage2_Frame02",frameRefX+104-185,frameRefY+210)
	end

	if t<13000 then
		drawSprite("SS_Stage1_Frame01",frameRefX+104,frameRefY+210)
	else
		drawSprite("SS_Stage2_Frame01",frameRefX+104,frameRefY+210)
	end

	if t<14000 then
		drawSprite("SS_Stage1_Frame02",frameRefX+104+185,frameRefY+210)
	else
		drawSprite("SS_Stage2_Frame02",frameRefX+104+185,frameRefY+210)
	end

	if t>15000 then drawSprite("SS_Stage3_03",frameRefX+76,frameRefY+25) end
	if t>15600 then drawSprite("SS_Stage3_03",frameRefX+82,frameRefY+13) end
	if t>17000 then drawSprite("SS_Stage3_01",frameRefX+53,frameRefY+13) end
	if t>18000 then drawSprite("SS_Stage3_04",frameRefX+135,frameRefY+12) end
	if t>18500 then drawSprite("SS_Stage3_03",frameRefX+134,frameRefY+118) end
	if t>15000 then drawSprite("SS_Stage3_04",frameRefX+171,frameRefY+153) end
	if t>17200 then drawSprite("SS_Stage3_03",frameRefX+186,frameRefY+181) end
	if t>19500 then drawSprite("SS_Stage3_04",frameRefX+266,frameRefY+13) end
	if t>16000 then drawSprite("SS_Stage3_02",frameRefX+250,frameRefY+118) end
	if t>19500 then drawSprite("SS_Stage3_03",frameRefX+258,frameRefY+118) end
	if t>19000 then drawSprite("SS_Stage3_02",frameRefX+257,frameRefY+132) end
	if t>20000 then drawSprite("SS_Stage3_03",frameRefX-51,frameRefY+118) end
	if t>15600 then drawSprite("SS_Stage3_01",frameRefX-80,frameRefY+118) end
	if t>16000 then drawSprite("SS_Stage3_01",frameRefX+1,frameRefY+117) end

	local paths = {
		{ st = 0, endt = 3000, pivots={{100,10,10},{200,10,10},{300,10,10},{250,10,10},{150,10,10}}},
		{ st = 1000, endt = 4000, pivots={{60,15,10},{80,15,10},{100,15,10},{120,15,10},{140,15,10},{160,15,10}}},
		{ st = 3000, endt = 5000, pivots={{180,14,10},{0,14,10},{50,14,10},{250,14,10}}},
		{ st = 0, endt = 3000, pivots={{100,100,10},{200,100,10},{250,100,10},{50,100,10},{-100,100,10},{-200,100,20}}},
		{ st = 1000, endt = 4000, pivots={{60,110,10},{150,110,10},{190,110,10},{290,110,20}}},
		{ st = 2000, endt = 8000, pivots={{180,104,10},{0,104,10},{50,104,10},{250,104,10}}},
		{ st = 1200, endt = 6000, pivots={{100,50,10},{130,7,10},{100,50,20},{80,100,20},{280,100,10}}},
		{ st = 3200, endt = 9000, pivots={{150,155,10},{180,112,10},{150,155,20},{130,205,20},{230,205,10}}},
		{ st = 4000, endt =12000, pivots={{180,210,20},{0,210,20},{50,210,10},{250,210,10}}},
		{ st = 4400, endt =12000, pivots={{0,0,20},{50,100,20},{220,100,10},{270,210,20}}},
		{ st = 4600, endt =14000, pivots={{50,105,20},{100,205,20},{270,205,10},{320,315,20}}},
		{ st = 6000, endt =14000, pivots={{200,260,10},{230,217,10},{200,260,20},{180,310,20}}},
		{ st = 8000, endt =14000, pivots={{-100,210,20},{-60,210,20},{50,210,20},{100,210,20},{50,210,10},{-60,210,10}}},
		{ st =13000, endt =20000, pivots={{-100,210,20},{-60,210,20},{50,210,20},{100,210,20},{50,210,10},{-60,210,10}}},
		{ st =16000, endt =22000, pivots={{-85,260,10},{-55,217,10},{-85,260,20},{-105,310,20}}},
	}

	for p=1,#paths do
		local linestart = paths[p].st
		local lineend = paths[p].endt
		local linepath = paths[p].pivots
		if t > linestart and t < lineend+1000 then
			
			local st = lineend - linestart
			local pt = t - linestart
			local steps = 0
			for i=1,#linepath-1 do
				steps = steps + linepath[i][3]
			end
			
			local cstep = (pt/st)*steps//1
			
			local count = 1
			local lastx = linepath[1][1]
			local lasty = linepath[1][2]

			for i=1,#linepath-1 do
				local refx = (linepath[i+1][1]-linepath[i][1])/linepath[i][3]
				local refy = (linepath[i+1][2]-linepath[i][2])/linepath[i][3]
				for s=1,linepath[i][3] do
					local px = linepath[i][1]+refx*s
					local py = linepath[i][2]+refy*s
					local c = (cstep-count)//1 
					if c == 1 then 
						if px > lastx then
							welder(frameRefX+px,frameRefY+py,t)
						else
							welderL(frameRefX+px,frameRefY+py,t)
						end
					end
					count = count + 1
					lastx = px
					lasty = py
				end
			end
		end
	end

	drawSprite("SS_Stage3_02",(frameRefX+tl//50)%800-140,frameRefY+100)
	drawSprite("SS_Welder_06",(frameRefX+tl//50)%800-150,frameRefY+100)
	drawSprite("SS_Welder_06",(frameRefX+tl//50)%800-155,frameRefY+110)

	drawSprite("SS_Stage3_02",(frameRefX+tl//60)%1000-40,frameRefY+200)
	drawSprite("SS_Welder_06",(frameRefX+tl//60)%1000-50,frameRefY+200)
	drawSprite("SS_Welder_06",(frameRefX+tl//60)%1000-55,frameRefY+210)

	drawSprite("SS_Stage3_02",(frameRefX+tl//50)%800-40,frameRefY+200)
	drawSprite("SS_Welder_06",(frameRefX+tl//50)%800-50,frameRefY+200)
	drawSprite("SS_Welder_06",(frameRefX+tl//50)%800-55,frameRefY+210)


	drawSprite("SS_Ship_up",20+tl//45,136-tl//30)
	drawSprite("SS_Ship_up",-60+tl//45,236-tl//30)

	drawSprite("SS_Ship_up",-200+tl//45,536-tl//30)
	drawSprite("SS_Ship_up",-300+tl//45,636-tl//30)

	drawSprite("SS_Ship_up",-400+tl//45,1036-tl//30)
	drawSprite("SS_Ship_up",-600+tl//45,1136-tl//30)

	drawSprite("SS_Ship_up",-600+tl//45,1336-tl//30)
	drawSprite("SS_Ship_up",-700+tl//45,1536-tl//30)

	vbank(0)

end