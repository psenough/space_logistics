-- idea: cloud lifetimes could use a gradient + lifetime so they fade out instead of disappearing

function stars(t)
	for i=0,50 do
		circ(math.random(240),
			(math.random(136)+t/200)%136,
			math.random()*1.5,
			 (4+math.random(2)//1*8)*math.abs(math.sin(t/math.random(10000))//1)
			)
	end
end

F4ships = nil

F4shipsDefaults = {
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
cloudAngleBiasAmt01 = 0.5 -- how much bias to mix

function Frame04_init()
	clouds = {}
	F4ships = deepcopy(F4shipsDefaults)

	-- calc ship trajectory angles so clouds can follow
	for i=1,#F4ships do
		F4ships[i][7] = math.atan2(F4ships[i][5],F4ships[i][4])
	end
end

function Frame04(t)
	cls()

	local tt=1

	-- todo: vertical bands with dithering

	math.randomseed(1)
	stars(t)
	
	math.randomseed(t)

	for i=1,#clouds do
		-- render clouds
		circ(
			clouds[i][1],
			clouds[i][2],
			clouds[i][3],
			clouds[i][4]
		)
	end

	-- update clouds
	for i=#clouds,1,-1 do
		local angleRad = clouds[i][5]
		local speed = clouds[i][6]
		clouds[i][1] = clouds[i][1] + math.cos(angleRad) * speed * tt
		clouds[i][2] = clouds[i][2] + math.sin(angleRad) * speed * tt

		if clouds[i][1]<-10 or clouds[i][1]>250 or clouds[i][2]<-10 or clouds[i][2]>150 then
			table.remove(clouds,i) -- oob
		end
	end

	-- update ships
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
				local cloudAngleBiasRadians = F4ships[i][7]
				local cloudOwnAngle =  (math.random() * 2 * 3.14159)
				local cloudAngle = lerpScalar(cloudOwnAngle, cloudAngleBiasRadians, cloudAngleBiasAmt01)
				clouds[#clouds+1] = {
											F4ships[i][2]+F4ships[i][6][j],
											F4ships[i][3]+F4ships[i][6][j+1],
											math.random(4), -- radius
											math.random(12,14), -- color gradient
											cloudAngle,
											0.05 + math.random() * 0.15,-- speed
										}
			end
		end

	end

	--print(#clouds)

end
