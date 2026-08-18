
F08modX = 10

Frame08_sprites = {
	{"F8_Module_08",F08modX+30,70},	
	{"F8_Module_09",F08modX+66,82},	
	{"F8_Module_02",F08modX+100,102},
	{"F8_Module_03",F08modX+144,120},
	{"F8_Module_01",F08modX+200,144},
	{"F8_Module_06",F08modX+258,164},
	{"F8_Module_05",F08modX+220,188}, -- pipe
	{"F8_Module_02",F08modX+302,186},
	{"F8_Module_07",F08modX+348,204},
	{"F8_Module_08",F08modX+382,218},
	{"F8_Module_04",F08modX+338,242}, -- pipe
	{"F8_Module_03",F08modX+414,232},
	{"F8_Module_09",F08modX+468,252}
}

F08_st=0

function Frame08_init()
	F08_st = time()
	snapx = 0
	snapy = 0
end

function Frame08(tt)
	cls()

	local t = (tt - F08_st)*.4
	--local tt=.4

	math.randomseed(234)
	stars_noscroll(t+10000)
	
	local s2x = 0
	local s2y = 0

	-- draw sprites
	for i=1,#Frame08_sprites do
		-- update
		local px = (Frame08_sprites[i][2] - t/50)%500-100
		local py = (Frame08_sprites[i][3] - t/120)%500-100
		
		-- draw
		drawSprite(Frame08_sprites[i][1],px,py)

		if i == 6 then
			local s1y = py+50-t/50
			local cap = py+14
			if s1y < cap then s1y = cap end
			drawSprite("F8_Ship_03",px-80,s1y)
		end

		if i == 11 then
			s2x = px-40			
			s2y = py+50-t/30			
			local capt = 3600
			if t > capt then
				if snapx == 0 then snapx = s2x end
				if snapy == 0 then snapy = s2y end
				s2x=snapx+(t-capt)/15
				s2y=snapy+(t-capt)/40
			end
		end

	end

	math.randomseed(t)
	if snapx ~= 0 then
		circ(s2x,s2y+16,math.random(2),math.random(3)+3)
		circ(s2x+16,s2y+10,math.random(2),math.random(3)+3)
	end
	drawSprite("F8_Ship_02",s2x,s2y)

end
