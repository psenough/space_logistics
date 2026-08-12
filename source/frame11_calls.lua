--------------------------------------------------------------------------------------------------------
-- generic particle system
function UpdateParticle(p,dt)
	p.x = p.x + p.dx * dt
	p.y = p.y + p.dy * dt
	p.life = p.life - dt
end

function CreateParticlePool(maxParticles)
	local pool = {}
	pool.maxParticles = maxParticles or 1000
	pool.particles = {}
	return pool
end

-- p should be { x=,y=,dx=,dy=,life=, onDeath, should86= }
-- onDeath called when it outives lifetime.
-- should86 is a function that returns true if the particle should be removed (e.g. OOB)
-- p can contain other fields.
function AddParticleToPool(pool, p)
	-- if max capacity, remove oldest particle (ok fifo regardless of particle lifetime)
	p.age = 0
	if #pool.particles >= pool.maxParticles then
		table.remove(pool.particles, 1)
	end
	table.insert(pool.particles, p)
end

function UpdateParticlePool(pool, dt)
	for i = #pool.particles, 1, -1 do
		local p = pool.particles[i]
		UpdateParticle(p, dt)
		if p.life <= 0 then
			table.remove(pool.particles, i)
			if p.onDeath then
				p.onDeath(p)
			end
		elseif p.should86 and p.should86(p) then
			table.remove(pool.particles, i)
			if p.onDeath then
				p.onDeath(p)
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------
-- star system... reuse particle system.

StarGradient = { 15,14,13,12,4 }
--StarGradient = { 4, 12, 13, 14, 15 }
F11_Starfield = nil

function CreateStar(parallaxLayer01, init)
	local star = {
		x = init and math.random(0, 240) or 241,
		y = math.random(0, 136),
		dx = -0.02 * parallaxLayer01,
		dy = 0,
		life = 99999, -- effectively infinite
		onDeath = function(p)
			local newStar = CreateStar(parallaxLayer01, false)
			AddParticleToPool(F11_Starfield, newStar)
		end,
		should86 = function(p)
			return p.x < -20 or p.x > 260 or p.y < -20 or p.y > 156
		end,
		-- custom props
		seed = math.random(),
		colorIndex = math.random(1, #StarGradient) * parallaxLayer01,
		radius = parallaxLayer01 * 0.1,
	}
	return star
end

function CreateStarField()
	local stars = {}
	local numParallaxLayers = 3
	for parallaxLayer = 1, numParallaxLayers do
		-- norm should actually hit  0 and 1
		local layer01 = (parallaxLayer - 1) / (numParallaxLayers - 1)
		local numStars = 10 * parallaxLayer
		for i=1, numStars do
			table.insert(stars, CreateStar(layer01, true))
		end	
	end
	local starField = CreateParticlePool(#stars)
	for _, star in ipairs(stars) do
		AddParticleToPool(starField, star)
	end
	return starField
end

function UpdateStarField(starField, dt)
	-- update existing stars
	UpdateParticlePool(starField, dt)
end

function RenderStarField(starField, t)
	for i,p in ipairs(starField.particles) do
		-- twinkle effect nudges gradient index.
		local twinkleRate = 0.02
		local twinkle = math.sin(t * twinkleRate * p.seed) + 0.95 -- bias so it's mostly positive(on)
		local twinkleIndexNudge = twinkle > 0 and 2 or 0
		local colIndex = math.min(p.colorIndex + twinkleIndexNudge, #StarGradient)
		circ(p.x, p.y, p.radius,  StarGradient[colIndex])
	end
end

--------------------------------------------------------------------------------------------------------



function RenderRock(x, y, seed, rid, aaRotationIndex)
	drawSpriteWithAARotation(rid, x, y, aaRotationIndex)
	--RotoSprite(rid, x, y, angle)
end


F11_st=0

-- rock sprites:
-- 1 = small
-- 2, 3 = large
-- 4 = medium
F11_bgRockPool = { 1 }
F11_bgParticles = nil

F11_fgRockPool = { 2, 3, 4 }
F11_fgParticles = nil

function AddRock(first, particleSystem, rockPool, speedMod)
	local biasAngleRight = DxDyToAngle(1, 0)
	local biasAngleLeft = DxDyToAngle(-1, 0)
	local biasAngle = math.random() > 0.7 and biasAngleRight or biasAngleLeft
	local biasAmt = 0.95 -- favor left/right mvmt
	local ownAngle = math.random() * 6.28
	local angle = lerpAngular(ownAngle, biasAngle, biasAmt)
	local speed = math.random(5, 20) / 1000
	speed = speed * speedMod-- * 10
	local dx, dy = angleToDxDy(angle, speed)
	-- if moving left, spawn on right. if moving right, spawn on left.
	local x = dx < 0 and 260 or -20
	if first then
		x = math.random(0, 240) -- except on init; then scatter them.
	end
	local p = {
		x = x,
		y = math.random(0,136),
		dx = dx,
		dy = dy,
		life = 99999, -- effectively infinite
		onDeath = function(p)
			AddRock(false, particleSystem, rockPool, speedMod)
		end,
		should86 = function(p)
			return p.x < -20 or p.x > 260 or p.y < -20 or p.y > 156
		end,
		-- custom props
		rockId = "F11_Rock_"..string.format("%02d", rockPool[math.random(1,#rockPool)]),
		aaRotationIndex = math.random(0,3), -- axis-aligned rot
		rotationRad = math.random() * 6.28, -- rocks are too small for rotosprite to look good.
	}
	AddParticleToPool(particleSystem,p)
end

function Frame11_init()
	F11_st = time()
	math.randomseed(12)

	F11_Starfield = CreateStarField()

	F11_bgParticles = CreateParticlePool(25)
	for i=1, 20 do
		AddRock(true, F11_bgParticles, F11_bgRockPool, 0.18)
	end

	F11_fgParticles = CreateParticlePool(3)
	for i=1, 20 do
		AddRock(true, F11_fgParticles, F11_fgRockPool, 5.5)
	end
end

function ShadeCircle(cx, cy, r, shadeFunc)
	local r2 = r * r
	for y = -r, r do
		local y2 = y * y
		local screenY = cy+y
		if screenY >= 0 and screenY < 136 then
			for x = -r, r do
				local screenX = cx+x
				if screenX >= 0 and screenX < 240 then
					if x*x + y2 <= r2 then
						-- x and y are offsets from center; 
						local col = shadeFunc(cx+x, screenY)
						if col then
							pix(screenX, screenY, col)
						end
					end
				end
			end
		end
	end
end

-- F11_planetGradient = { 2,3,4 }
-- function RenderPlanet(t)
-- 	circ(400,-400,525,1)-- diag template.

-- 	--ShadeCircle(400,-400,525, function(x, y, u, v)
-- 	ShadeCircle(120,68,60, function(x, y)
-- 		-- simple randomness.
-- 		return F11_planetGradient[math.random(1,#F11_planetGradient)]
-- 	end)
-- end

function Frame11(tt)

	local t = (tt - F11_st)
	local dt = 16
	
	cls()

	UpdateStarField(F11_Starfield, dt)
	UpdateParticlePool(F11_bgParticles, dt)
	UpdateParticlePool(F11_fgParticles, dt)

	RenderStarField(F11_Starfield, t)

	-- planet
	--circ(100,1000,900,1)-- horiz
	--circ(1000,80, 900,1)-- vert
	circ(400,-400,525,1)-- diag template.
	--RenderPlanet(t);

	-- rocks behind
	for i,p in ipairs(F11_bgParticles.particles) do
		RenderRock(p.x,p.y,i,p.rockId,p.aaRotationIndex)
	end

	-- ship.
	drawSprite("F11_Ship",30+t/1000, math.sin(t/2000) * 2)

	-- rocks in front
	for i,p in ipairs(F11_fgParticles.particles) do
		RenderRock(p.x,p.y,i,p.rockId,p.aaRotationIndex)
	end

end
