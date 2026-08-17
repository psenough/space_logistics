

function RenderRock(x, y, seed, rid, aaRotationIndex)
	drawSpriteWithAARotation(rid, x, y, aaRotationIndex)
	--RotoSprite(rid, x, y, angle)
end


F11_st=0

F11_shipX = 0

-- rock sprites:
-- 1 = small
-- 2, 3 = large
-- 4 = medium
F11_bgRockPool = { 1 }
F11_bgParticles = nil

F11_fgRockPool = { 2, 3, 4 }
F11_fgParticles = nil

F11_Starfield = nil
F11_particleStreaks = nil -- particle system for high-energy particles.
F11_particleStreakIntensity = 0 -- for a transition to next scene, ramp this up.
F11_particleStreakIntensityOverride = nil -- for a transition to next scene, ramp this up.

-- precalc the shuffled Y positions to emit particles.
-- so very dense fields are evenly-distributed to cover the screen better, not overlap.
F11_particleStreakYPositions = {}
F11_particleStreakCounter = 0
for i=0, TIC_HEIGHT() - 1 do
	F11_particleStreakYPositions[i + 1] = i
end
ShuffleInPlace(F11_particleStreakYPositions, CreateRng(1234))

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

-- each gradient's left color = transparent.
--F11_chaosGradient = ShuffleInPlace({ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 }, CreateRng(1234))
F11_gradients = {
	-- { 0, 15, 14, 13 }, -- dim grayscale
	{ 0, 15, 14, 13, 12 }, -- grayscale
	{ 0, 8, 9, 10, 11 }, -- blue
	{ 0, 1,2,3,4 }, -- red-yellow
	{ 0, 7,6,5 }, -- green
	{ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 }, -- chaos.
}
for g = 1, 5 do
	local grad= ShuffleInPlace({ 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 }, CreateRng(1234 + g))
	F11_gradients[#F11_gradients + 1] = grad
end

function F11_GetParticleStreakIntensity()
	return F11_particleStreakIntensityOverride or F11_particleStreakIntensity
end

function F11_GetParticleStreakLength(len01)
	return bilerpScalar(1, 5, 80, 250, len01, F11_GetParticleStreakIntensity())
end

function F11_AddParticleStreak()
	F11_particleStreakCounter = F11_particleStreakCounter + 1
	-- more intensity = more gradients to choose from
	local gradientCount = (lerpScalar(1, #F11_gradients, F11_GetParticleStreakIntensity()) + 0.5) // 1
	
	local p = {
		x = TIC_WIDTH(),
		y = F11_particleStreakYPositions[F11_particleStreakCounter % #F11_particleStreakYPositions + 1],
		dx = lerpScalar(-2, -5, math.random()),
		dy = 0,
		life = 99999, -- effectively infinite
		--onDeath = F11_AddParticleStreak, -- don't accumulate; let tick() create as needed.
		should86 = function(p)
			if p.x < -F11_GetParticleStreakLength(p.length) then
				return true
			end
			return false
		end,
		-- custom props
		length = math.random(),
		gradient = F11_gradients[math.random(1, gradientCount)],
	}
	AddParticleToPool(F11_particleStreaks,p)
end

function F11_RenderParticleStreak(p)
	--pix(p.x, p.y, 12)
	--line(p.x, p.y, p.x + p.length, p.y, 12)
	--local length = lerpScalar(p.length)
	local length = F11_GetParticleStreakLength(p.length)
	hlineBayerGradient(p.x, p.x + length, p.y, p.gradient, 1.0, 0)
end

function Frame11_init()
	poke(0x3FF8,0) -- border black
	
	F11_st = time()
	math.randomseed(12)

	F11_shipX = 30 -- initial ship X

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
		AddRock(true, F11_fgParticles, F11_fgRockPool, 15.5)
	end

	F11_particleStreaks = CreateParticlePool(136 * 3) -- 3 per row max.
	F11_particleStreakCounter = 0
	F11_particleStreakIntensityOverride = nil
end

F11_planetGradient = { 0,1,2,3,4,12 }

function RenderPlanet(t)
	--local cx, cy, r = 120, 68, 60
	local cx, cy, r = 330, -450, 525

	local invR = 1 / r
	local phase = t * -0.0017
	--local rotation = t * 0.0001
	local scale = 6

	-- don't put these in the shader for performance.
	local phasev2 = phase * 1.6 
	local phasev3 = phase * 0.61
	local scalev1 = scale * 9
	local scalev2 = scale * 12
	local scalev3 = scale * 7
	--local cr, sr = cos(rotation), sin(rotation)

	circ(cx, cy, r + 3, 8)
	circ(cx, cy, r + 1, 9)

	ShadeCircleBayer(cx, cy, r, F11_planetGradient, function(screenX, screenY)
		local x = (screenX - cx) * invR -- normalize
		local y = (cy - screenY) * invR
		local z = sqrt(1 - x*x - y*y) -- unit sphere

		local waves =
			sin(scalev1*x + 5*y + phase) +
			sin(scalev2*z - 7*y - phasev2) +
			sin(scalev3*(x + z + y) + phasev3)
		--return z * (waves + 2) * 0.5 * (3 * (F11_particleStreakIntensity + 1))
		return z * (waves + 2) * LERP(0.5, 3, F11_GetParticleStreakIntensity())

		-- interaction with rotated coords looks cool but is subtle and costs a lot of CPU
		-- local px = cr*x - sr*z
		-- local pz = sr*x + cr*z
	end)
end



function Frame11(tt, demoBeat, somaticState, sceneTiming)

	local t = (tt - F11_st)
	local dt = 16
	

	-- up/down controls intensity.
	--#ifdef DEBUG
	if keyp(58) or btnp(0) then -- up
		F11_particleStreakIntensityOverride = min((F11_particleStreakIntensityOverride or F11_particleStreakIntensity) + 0.1, 1.0)
	end
	if keyp(59) or btnp(1) then -- down
		F11_particleStreakIntensityOverride = max((F11_particleStreakIntensityOverride or F11_particleStreakIntensity) - 0.1, 0.0)
	end
	--#endif

	-- ramp up intensity over time
	-- scene starts @ 368
	local targetBeat = 400--380 --400
	local transitionDurationBeats = 8
	local transitionStartBeat = targetBeat - transitionDurationBeats
	local transition01 = clamp01((demoBeat - transitionStartBeat) / transitionDurationBeats)
	F11_particleStreakIntensity = LERP(0.003, 1.0, transition01 * transition01* transition01)

	cls()

	-- adjust params to scene intensity.

	UpdateStarField(F11_Starfield)
	UpdateParticlePool(F11_bgParticles)
	UpdateParticlePool(F11_fgParticles)
	UpdateParticlePool(F11_particleStreaks)

	-- create new particle streaks; we can create multiple per frame.
	local effectiveIntensity = F11_GetParticleStreakIntensity()
	for y = 0, 140 do
		-- adding more than is supported will remove existing; let them fade out naturally.
		if #F11_particleStreaks.particles < F11_particleStreaks.maxParticles then
			if math.random() < effectiveIntensity * 0.1 then
				F11_AddParticleStreak()
			end
		end
	end

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

	-- ship
	local shipDx = LERP(0.001, 0.08, effectiveIntensity)
	F11_shipX = F11_shipX + shipDx * dt
	drawSprite("F11_Ship", F11_shipX, math.sin(t/2000) * 2)

	-- rocks in front
	for i,p in ipairs(F11_fgParticles.particles) do
		RenderRock(p.x,p.y,i,p.rockId,p.aaRotationIndex)
	end

	-- particle  streaks
	for i,p in ipairs(F11_particleStreaks.particles) do
		F11_RenderParticleStreak(p)
	end

	local glitchAmt = effectiveIntensity ^1.4
	if (glitchAmt > 0.05) then
		screen_glitch(t, 20, glitchAmt)
	end

	--#ifdef DEBUG
	if show_hud then
		print(string.format("F11 intensity: %.2f / trans:%.2f (up/down = manual)",
			effectiveIntensity, transition01), 0, 16, 5)
	end
	--#endif
end
