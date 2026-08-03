
function stars(t)
	for i=0,100 do
		circ(math.random(240),
			(math.random(136)+t/200)%136,
			math.random()*1.5,
			(4+math.random(2)//1*8)*math.abs(math.sin(t/math.random(2000))//1)
			)
	end
end

F4ships = {
	{"F4_Ship02",10,130,.14,-.3,{1,18,-18,38, 7,18,-20,40}},
	{"F4_Ship03",80,160,.16,-.3,{1,30,-18,38, 11,30,-20,40}},
	{"F4_Ship01",70,160,.1,-.4,{2,40,-12,50, 27,42,-12,50}},
}

function drawTrail(posx,posy,dx,dy)
	for i=0,3 do
		local col=4
		if math.random()>.5	then col = math.random(12,15) end
		line(posx+math.random(3)-1,posy,posx+dx+math.random(3)-1,posy+dy,col)
	end
end

clouds = {}
maxclouds=3000

function Frame04(t)
	cls()

	local tt=1

	-- dithering

	math.randomseed(1)
	stars(t)
	
	math.randomseed(t)

	for i=1,#clouds do
		circ(clouds[i][1]+math.sin(t/2000+i)*2,clouds[i][2],clouds[i][3],clouds[i][4])
	end

	-- update
	for i=1,#F4ships do
		F4ships[i][2] = F4ships[i][2] + F4ships[i][4]*tt
		F4ships[i][3] = F4ships[i][3] + F4ships[i][5]*tt

		drawSprite(F4ships[i][1],F4ships[i][2],F4ships[i][3])
		
		-- draw trails
		for j=1,#F4ships[i][6],4 do
			drawTrail(
				F4ships[i][2]+F4ships[i][6][j],
				F4ships[i][3]+F4ships[i][6][j+1],
				F4ships[i][6][j+2],
				F4ships[i][6][j+3])

			-- generate new clouds
			if math.random()>.5 and #clouds < maxclouds then
				clouds[#clouds+1] = {
											F4ships[i][2]+F4ships[i][6][j],
											F4ships[i][3]+F4ships[i][6][j+1],
											math.random(4),
											math.random(12,14) }
			end
		end

	end

	--print(#clouds)

end
