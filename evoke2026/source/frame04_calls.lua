
-- falling stars
-- function stars(t)
-- 	for p = 1, 3 do
-- 		local speed = ((p + 1) / 400)
-- 		for i=0,50 do
-- 			circ((math.random(240) - t * 0.4 * speed) % 240, -- a bit of side mvmt feels more cinematic; nice contrary mvmt to the ships & clouds
-- 				(math.random(136) + t * speed)%136,
-- 				math.random()*1.5,
-- 				(4+math.random(2)//1*8)*math.abs(math.sin(t/math.random(10000))//1) -- twinkle
-- 				)
-- 		end
-- 	end
-- end

F4ships = nil
F4starfield = nil

F4shipsDefaults = {
	{"F4_Ship02",10,130,.14,-.3,{1,18,-18,38, 7,18,-20,40}},
	{"F4_Ship03",80,160,.16,-.3,{1,30,-18,38, 11,30,-20,40}},
	{"F4_Ship01",70,160,.1,-.4,{2,40,-12,50, 27,42,-12,50}},
}

clouds = {}
maxclouds=3000
cloudAngleBiasAmt01 = 0.4 -- how much bias to mix

-- similar to clouds
trailClouds = {}
trailCloudAngleBiasAmt01 = 0.9 -- how much bias to mix
trialGradient = { 8, 1, 2, 3, 4 }

function Frame04_init()
	math.randomseed(1000)
	clouds = {}
	trailClouds = {}
	F4ships = deepcopy(F4shipsDefaults)
	F4starfield = CreateStarField({
		numParallaxLayers = 4,
		density = 10,
		dxMin = -0.01,
		dxMax = -0.02,
		radiusMin = 0.5,
		radiusMax = 1
	})

	-- calc ship trajectory angles so clouds can follow
	for i=1,#F4ships do
		F4ships[i][7] = math.atan2(F4ships[i][5],F4ships[i][4])
	end
end

function Frame04(t)
	cls()

	local tt=1

	--math.randomseed(1000)
	--stars(t)
	UpdateStarField(F4starfield)
	RenderStarField(F4starfield, t)
	
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

	-- render trail clouds
	for i=1,#trailClouds do
		local cloud = trailClouds[i]
		local age = cloud.age
		-- gradient
		local gradientIndex = math.floor((1 - (age / cloud.lifetime)) * #trialGradient)
		local normAge = age / cloud.lifetime
		circ(
			cloud.x, -- x
			cloud.y, -- y
			(1 - normAge) * 2, -- radius
			trialGradient[math.max(1, math.min(#trialGradient, gradientIndex))] -- color
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

	-- update trail clouds
	for i=#trailClouds,1,-1 do
		local angleRad = trailClouds[i].angle
		local speed = trailClouds[i].speed
		trailClouds[i].x = trailClouds[i].x + math.cos(angleRad) * speed * tt
		trailClouds[i].y = trailClouds[i].y + math.sin(angleRad) * speed * tt

		trailClouds[i].age = trailClouds[i].age + tt -- age
		if trailClouds[i].x<-10 or trailClouds[i].x>250 or trailClouds[i].y<-10 or trailClouds[i].y>150 or trailClouds[i].age>=trailClouds[i].lifetime then
			table.remove(trailClouds,i) -- oob or ded
		end
	end

	-- update ships
	for i=1,#F4ships do
		F4ships[i][2] = F4ships[i][2] + F4ships[i][4]*tt
		F4ships[i][3] = F4ships[i][3] + F4ships[i][5]*tt

		drawSprite(F4ships[i][1],F4ships[i][2],F4ships[i][3])
		
		for j=1,#F4ships[i][6],4 do
			-- generate new trail clouds
			if math.random()>.5 and #clouds < maxclouds then
				local angleBiasRadians = F4ships[i][7]
				local ownAngle =  (math.random() * 2 * 3.14159)
				local cloudAngle = lerpAngular(ownAngle, angleBiasRadians, trailCloudAngleBiasAmt01)
				trailClouds[#trailClouds+1] = {
											x = F4ships[i][2]+F4ships[i][6][j],
											y = F4ships[i][3]+F4ships[i][6][j+1],
											lifetime = 100 + math.random(100),
											age = 0,
											angle = cloudAngle,
											speed = 0.05 + math.random() * 0.15,
										}
			end

			-- generate new gray clouds
			if math.random()>.5 and #clouds < maxclouds then
				local angleBiasRadians = F4ships[i][7]
				local cloudOwnAngle =  (math.random() * 2 * 3.14159)
				local cloudAngle = lerpAngular(cloudOwnAngle, angleBiasRadians, cloudAngleBiasAmt01)
				clouds[#clouds+1] = {
											F4ships[i][2]+F4ships[i][6][j],
											F4ships[i][3]+F4ships[i][6][j+1],
											math.random(4), -- radius
											math.random(12,14), -- color gradient
											cloudAngle,
											0.02 + math.random() * 0.05,-- speed
										}
			end
		end

	end

end
