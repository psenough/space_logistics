
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

function SphereScenes_1(tt)

	local t = (tt - SS_st)
	math.randomseed(t)

	cls()
	local frameRefX = -120+t//120
	local frameRefY = -t//120
	drawSprite("SS_Stage1_Frame03",frameRefX-185,frameRefY)
	drawSprite("SS_Stage1_Frame01",frameRefX,frameRefY)
	drawSprite("SS_Stage1_Frame02",frameRefX+185,frameRefY)
	drawSprite("SS_Stage1_Frame01",frameRefX+52,frameRefY+105)
	drawSprite("SS_Stage1_Frame01",frameRefX+52-185,frameRefY+105)
	drawSprite("SS_Stage1_Frame03",frameRefX+52+185,frameRefY+105)
	drawSprite("SS_Stage1_Frame03",frameRefX+104-185,frameRefY+210)
	drawSprite("SS_Stage1_Frame01",frameRefX+104,frameRefY+210)
	drawSprite("SS_Stage1_Frame02",frameRefX+104+185,frameRefY+210)

	-- start, end, id, posx, posy, dx, dy
	local welders = {
		{	0, 2000, nil, 100,100, 60, 0},
		{3000, 6000, nil, 180,104, 60, 0},
		{2000,10000, nil, 100, 50, 60,-33},
		{   0,    0, nil,  70,148,  0, 0},
		{1000,20000, nil, 170,194, 60, 0},
	}

	drawWelders(welders,frameRefX,frameRefY,t)

end


function SphereScenes_2(tt)

	local t = (tt - SS_st)
	math.randomseed(t)

	cls()
	local frameRefX = -120+t//120
	local frameRefY = -140+t//120 
	drawSprite("SS_Stage2_Frame01",frameRefX-185,frameRefY)
	drawSprite("SS_Stage2_Frame01",frameRefX,frameRefY)
	drawSprite("SS_Stage2_Frame02",frameRefX+185,frameRefY)
	drawSprite("SS_Stage2_Frame01",frameRefX+52,frameRefY+105)
	drawSprite("SS_Stage2_Frame01",frameRefX+52-185,frameRefY+105)
	drawSprite("SS_Stage2_Frame02",frameRefX+52+185,frameRefY+105)
	drawSprite("SS_Stage2_Frame02",frameRefX+104-185,frameRefY+210)
	drawSprite("SS_Stage2_Frame01",frameRefX+104,frameRefY+210)
	drawSprite("SS_Stage2_Frame02",frameRefX+104+185,frameRefY+210)

	-- start, end, id, posx, posy, dx, dy
	local welders = {
		{	0, 6000, nil, 100,100, 60, 0},
		--{6000,10000, nil, 110, 46, 60,-33},
		{   0, 1000, nil,  70,148,  0, 0},
		{   0, 1000, nil, 190,192, 60, 0},
		{6000,10000, nil, 170,202, 60, 0},
	}

	drawWelders(welders,frameRefX,frameRefY,t)

	drawSprite("SS_Ship_up",frameRefX+20+t//45,frameRefY+300-t//30)

end


function SphereScenes_3(tt)

	local t = (tt - SS_st)
	math.randomseed(t)

	cls()
	local frameRefX = 0---120+t//120
	local frameRefY = 0---140+t//120 
	drawSprite("SS_Stage2_Frame01",frameRefX-185,frameRefY)
	drawSprite("SS_Stage2_Frame01",frameRefX,frameRefY)
	drawSprite("SS_Stage2_Frame02",frameRefX+185,frameRefY)
	drawSprite("SS_Stage2_Frame01",frameRefX+52,frameRefY+105)
	drawSprite("SS_Stage2_Frame01",frameRefX+52-185,frameRefY+105)
	drawSprite("SS_Stage2_Frame02",frameRefX+52+185,frameRefY+105)
	drawSprite("SS_Stage2_Frame02",frameRefX+104-185,frameRefY+210)
	drawSprite("SS_Stage2_Frame01",frameRefX+104,frameRefY+210)
	drawSprite("SS_Stage2_Frame02",frameRefX+104+185,frameRefY+210)
	-- todo: match these one by one
	drawSprite("SS_Stage3_02",frameRefX-185,frameRefY)
	drawSprite("SS_Stage3_01",frameRefX,frameRefY)
	drawSprite("SS_Stage3_04",frameRefX+185,frameRefY)
	drawSprite("SS_Stage3_03",frameRefX+52,frameRefY+105)
	drawSprite("SS_Stage3_06",frameRefX+52-185,frameRefY+105)
	drawSprite("SS_Stage3_04",frameRefX+52+185,frameRefY+105)
	drawSprite("SS_Stage3_05",frameRefX+104-185,frameRefY+210)
	drawSprite("SS_Stage3_05",frameRefX+104,frameRefY+210)
	drawSprite("SS_Stage3_02",frameRefX+104+185,frameRefY+210)


	-- start, end, id, posx, posy, dx, dy
	local welders = {
		{	0, 6000, nil, 100,100, 60, 0},
		--{6000,10000, nil, 110, 46, 60,-33},
		{   0, 1000, nil,  70,148,  0, 0},
		{   0, 1000, nil, 190,192, 60, 0},
		{6000,10000, nil, 170,202, 60, 0},
	}

	drawWelders(welders,frameRefX,frameRefY,t)

	drawSprite("SS_Ship_up",20+t//45,136-t//30)

end

