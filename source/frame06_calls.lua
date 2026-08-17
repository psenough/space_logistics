
function dust(x,y,seed,c)
	dx=x+math.sin(time()/1000+seed)*25+math.sin(time()/500+11+seed)*20
	dy=y+math.sin(time()/1000+seed)*10+math.sin(time()/800+1+seed)*20
	pix(dx,dy,c)
end

F06_st = 0

function Frame06_init()
	F06_st = time()
end

function Frame06(tt)

	cls(3)
	drawSprite("F6_BG_Ditter",0,0)
	drawSprite("F6_Ship",0,0)

	local paths = {
		{ st = 400, endt = 1600, pivots={{129,73,30},{150,109,10},{250,13,0}}},
		{ st = 100, endt = 2100, pivots={{127,74,30},{214,114,10},{49,156,0}}},
		{ st = 1200, endt = 3000, pivots={{127,74,30},{179,111,10},{249,133,0}}},
		{ st = 2400, endt = 4000, pivots={{127,74,30},{173,100,10},{250,16,0}}},
		{ st = 3000, endt = 5000, pivots={{128,73,30},{152,122,10},{-10,146,0}}},
		{ st = 3500, endt = 6000, pivots={{131,72,30},{192,115,10},{250,45,0}}},
		{ st = 3600, endt = 6000, pivots={{129,73,30},{161,112,10},{250,24,0}}},
	}

	local linegrad = {1,4,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2} 
	
	local t = tt - F06_st
	for p=1,#paths do
		local linestart = paths[p].st
		local lineend = paths[p].endt
		local linepath = paths[p].pivots
		if t > linestart and t < lineend then
			
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
					if c > 1 and c < #linegrad then
						line(lastx,lasty,px,py,linegrad[c])
					end
					count = count + 1
					lastx = px
					lasty = py
				end
			end
		end
	end

	math.randomseed(1)
	for i=0,250 do	
		dust((200+math.random()*100-t/20)%255,
					0+math.random()*150,
					math.random()*50,
					3)
	end

end
