
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

F11_Starfield = nil

function AddRock(first, particleSystem, rockPool, speedMod)
	local biasAngleRight = DxDyToAngle(1, 0)
	local biasAngleLeft = DxDyToAngle(-1, 0)
	local biasAngle = math.random() > 0.7 and biasAngleRight or biasAngleLeft
	local biasAmt = 0.95 -- favor left/right mvmt
	local ownAngle = math.random() * 6.28
	local angle = lerpAngular(ownAngle, biasAngle, biasAmt)
	local speed = math.random(5, 20) / 1000
	speed = speed * speedMod-- * 10
	local dx, dy = polarToCartesian(angle, speed)
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

	F11_Starfield = CreateStarField({
		numParallaxLayers = 3,
		density = 10,
		dxMin = -0.02,
		dxMax = -0.01,
		dyMin = 0.00,
		dyMax = 0.01
	})

	F11_bgParticles = CreateParticlePool(25)
	for i=1, 20 do
		AddRock(true, F11_bgParticles, F11_bgRockPool, 0.18)
	end

	F11_fgParticles = CreateParticlePool(3)
	for i=1, 20 do
		AddRock(true, F11_fgParticles, F11_fgRockPool, 5.5)
	end
end

F11_planetGradient = { 0,1,2,3,4,12 }

-- idea here was to use something other than sin() to make the planet feel like it has more ridges, less molten/smooth.
-- it ends up being a bit too subtle due to layering.
-- function MakeLUT(sampleCount, func)
-- 	local lut = {}
-- 	for i=0, sampleCount-1 do
-- 		local phase = ((i / sampleCount) - 0.5) * 6.28318530718 -- phase in -pi..pi
-- 		lut[i + 1] = func(phase)
-- 	end
-- 	return lut
-- end

-- local F11_WAVE = MakeLUT(256, function(phase)
-- 	local x = phase
-- 	return math.abs(sin(x))
-- end)

-- local F11_WAVE_N = #F11_WAVE
-- local F11_PHASE_TO_INDEX = F11_WAVE_N * 0.15915494309 -- 1/(2*pi)

-- local function F11_RidgeWave(phase)
-- 	-- no interpolation; cheap!
-- 	local index = ((phase * F11_PHASE_TO_INDEX) % F11_WAVE_N) // 1
-- 	return F11_WAVE[index + 1]
-- end

function RenderPlanet(t)
	--local cx, cy, r = 120, 68, 60
	local cx, cy, r = 330, -450, 525

	local invR = 1 / r
	local phase = t * -0.0017
	--local rotation = t * 0.0001
	local scale = 6
	--local cr, sr = cos(rotation), sin(rotation)

	circ(cx, cy, r + 3, 8)
	circ(cx, cy, r + 1, 9)

	ShadeCircleBayer(cx, cy, r, F11_planetGradient, function(screenX, screenY)
		local x = (screenX - cx) * invR -- normalize
		local y = (cy - screenY) * invR
		local z = sqrt(1 - x*x - y*y) -- unit sphere

		if z < 0.08 then
			-- sharper adge
			--return 6 * z
		end

		local waves =
			sin(scale*9*x + 5*y + phase) +
			sin(scale*12*z - 7*y - phase*1.6) +
			sin(scale*7*(x + z + y) + phase*0.61)
		return z * (waves + 2) * 0.5

		-- interaction with rotated coords looks cool but is subtle and costs a lot of CPU
		-- local px = cr*x - sr*z
		-- local pz = sr*x + cr*z
	end)
end

function Frame11(tt)

	local t = (tt - F11_st)
	local dt = 16
	
	cls()

	UpdateStarField(F11_Starfield)
	UpdateParticlePool(F11_bgParticles)
	UpdateParticlePool(F11_fgParticles)

	RenderStarField(F11_Starfield, t)

	-- planet
	--circ(100,1000,900,1)-- horiz
	--circ(1000,80, 900,1)-- vert
	---circ(400,-400,525,1)-- diag template.
	RenderPlanet(t);

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
