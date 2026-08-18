
function dust(x,y,seed,c)
	dx=x+math.sin(time()/1000+seed)*25+math.sin(time()/500+11+seed)*20
	dy=y+math.sin(time()/1000+seed)*10+math.sin(time()/800+1+seed)*20
	pix(dx,dy,c)
end

F06_st = 0

function Frame06_init()
	F06_st = time()
	cls(3)
	--drawSprite("F6_BG_Ditter",0,0)
end

function Frame06(tt)

	--cls(3)
	drawSprite("F6_Ship",0,0)
	drawSprite("F6_BG_Ditter",0,0)

	local paths = {
		{ st = 0, endt = 2000, pivots={{130,73,30},{140,86,20},{149,93,10},{240,38,0}}},
		{ st = 0, endt = 2000, pivots={{129,73,30},{139,86,20},{148,93,10},{204,136,0}}},
		{ st = 0, endt = 2000, pivots={{128,73,30},{138,86,20},{147,93,10},{38,136,0}}},

		{ st = 0, endt = 2200, pivots={{130,73,30},{140,86,20},{159,103,10},{240,54,0}}},
		{ st = 0, endt = 2200, pivots={{129,73,30},{139,86,20},{158,103,10},{201,136,0}}},
		{ st = 0, endt = 2200, pivots={{128,73,30},{138,86,20},{157,103,10},{78,136,0}}},

		{ st = 1200, endt = 3600, pivots={{131,73,30},{141,86,20},{160,103,5},{160,123,5},{160,136,0}}},
		{ st = 1200, endt = 3600, pivots={{129,73,30},{139,86,20},{158,103,5},{158,123,5},{128,136,0}}},
		{ st = 1200, endt = 3600, pivots={{127,73,30},{137,86,20},{156,103,5},{156,123,5},{156,136,0}}},

		{ st = 2200, endt = 3600, pivots={{131,73,30},{141,86,20},{160,103,5},{180,103,5},{240,103,0}}},
		{ st = 2200, endt = 3600, pivots={{129,73,30},{139,86,20},{158,105,5},{178,105,5},{240,105,0}}},
		{ st = 2200, endt = 3600, pivots={{127,73,30},{137,86,20},{156,103,5},{176,103,5},{240,136,0}}},

		{ st = 3600, endt = 5200, pivots={{130,73,30},{140,86,20},{159,103,10},{240,54,0}}},
		{ st = 3600, endt = 5200, pivots={{129,73,30},{139,86,20},{158,103,10},{213,136,0}}},
		{ st = 3600, endt = 5200, pivots={{128,73,30},{138,86,20},{157,103,10},{78,136,0}}},

	}

	local linegrad = {1,4,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}  
	
	local t = tt - F06_st
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
