
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
end

function Frame08(tt)
	cls()

	local t = (tt - F08_st)*.4
	--local tt=.4

	math.randomseed(234)
	stars_noscroll(t+10000)
	
	-- draw sprites
	for i=1,#Frame08_sprites do
		-- update
		local px = (Frame08_sprites[i][2] - t/50)%500-100
		local py = (Frame08_sprites[i][3] - t/120)%500-100
		
		-- draw
		drawSprite(Frame08_sprites[i][1],px,py)
	end


	--drawSprite("F8_Module_09",20,20)
	--drawSprite("F8_Ship_04",10,100)

end
