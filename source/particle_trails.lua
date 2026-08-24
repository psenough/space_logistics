--#pragma once
--#include "bootstrap.lua"


-- bayer 4x4 matrix normalized to 0..1
B4N = {
	0.5 / 16,
	8.5 / 16,
	2.5 / 16,
	10.5 / 16,
	12.5 / 16,
	4.5 / 16,
	14.5 / 16,
	6.5 / 16,
	3.5 / 16,
	11.5 / 16,
	1.5 / 16,
	9.5 / 16,
	15.5 / 16,
	7.5 / 16,
	13.5 / 16,
	5.5 / 16,
}

local BAYER_MINUS_5 = {}
-- precompute bayer offsets for each pixel in the screen.
for sy = 0, TIC_HEIGHT() - 1 do
	local y4 = (sy % 4) * 4
	local row = sy * TIC_WIDTH()
	for sx = 0, TIC_WIDTH() - 1 do
		BAYER_MINUS_5[row + sx] = (B4N[y4 + (sx % 4) + 1] - 0.5)
	end
end

function pixBayer(x, y, gradient, brightness)
	local gradientCount = #gradient
	local row = y * TIC_WIDTH()
	local bayer = BAYER_MINUS_5[row + x]
	local col = gradient[max(1, min(gradientCount, (brightness + bayer) * gradientCount)) // 1]
	pix(x, y, col)
end

-- callback receives x,y,t01 normalized along the line 0..1
function VisitPixelsAlongLine(x0, y0, x1, y1, callback)
	-- bresenham
	local dx = x1 - x0
	local dy = y1 - y0
	local steps = math.max(math.abs(dx), math.abs(dy))
	if steps == 0 then
		callback(x0, y0, 0)
		return
	end
	local xInc = dx / steps
	local yInc = dy / steps
	local x = x0
	local y = y0
	for i = 0, steps do
		local sx = x // 1
		local sy = y // 1
		if sx >= 0 and sx < TIC_WIDTH() and sy >= 0 and sy < TIC_HEIGHT() then
			local t01 = i / steps
			callback(sx, sy, t01)
		end
		x = x + xInc
		y = y + yInc
	end
end

-- dithered line draw, interpolating between start & end brightness.
function lineBayerDithered(x0, y0, x1, y1, gradient, brightness0, brightness1)
	VisitPixelsAlongLine(x0, y0, x1, y1, function(x, y, t01)
		local brightness = lerpScalar(brightness0, brightness1, t01)
		pixBayer(x, y, gradient, brightness)
	end)
end

-- this does not keep particle history, so it can't tolerate certain typees of animation.
-- but it's smooth motion always because the sampling follows current position.

function CreateParticleTrail(options)
	-- parameters
	options.areaX = options.areaX or 0
	options.areaY = options.areaY or 0
	options.areaW = options.areaW or TIC_WIDTH()
	options.areaH = options.areaH or TIC_HEIGHT()
	options.minSpeed = options.minSpeed or 0.001
	options.maxSpeed = options.maxSpeed or 0.005
	-- can also set speed1 / speed2 manually.
	local seed1 = options.seed1 or options.seed or 0.1-- seed or 0.1
	local seed2 = options.seed2 or ((seed1 + 1) or 0.2)
	options.speed1 = options.speed1 or lerpScalar(options.minSpeed, options.maxSpeed, hash11(seed1))
	options.speed2 = options.speed2 or lerpScalar(options.minSpeed, options.maxSpeed, hash11(seed2))
	options.sampleCount = options.sampleCount or 20
	options.sampleStep = options.sampleStep or 50
	options.pathIsInPixels = options.pathIsInPixels == true
	assert(options.sampleCount >= 2, "particle trail needs 2 samples")

	--local seed3 = options.seed3 or ((seed1 + 2) or 0.3)
	--options.gradient = options.gradient or Evoke_HUD_particleGradients[hash11(seed3)%#Evoke_HUD_particleGradients+1]
	--options.gradient = Evoke_HUD_particleGradients[SelectNorm(Evoke_HUD_particleGradients, hash11(seed3))]

	return options
end

function UpdateParticleTrail(particleTrail, somaticState, sceneTiming)
	local t
	if particleTrail.timeSource then
		t = particleTrail.timeSource(sceneTiming, somaticState)
	else
		t = sceneTiming.wallMillis -- wall so i can see the original HUD animation while paused.
	end

	-- sample N points along path
	local samplePath = particleTrail.samplePath
	if samplePath == nil then
		samplePath = function(sampleTime)
			local x = sin(sampleTime*particleTrail.speed1)
			local y = cos(sampleTime*particleTrail.speed2)
			return x,y
		end
	end

	local N = particleTrail.sampleCount
	local points = {}
	for i=1,N do
		local t_i = t - (N-i)*particleTrail.sampleStep
		local x,y = samplePath(t_i, somaticState, sceneTiming)
		table.insert(points, {x=x, y=y})
	end

	-- draw lines between points
	for i=1,N-1 do
		local p1 = points[i]
		local p2 = points[i+1]
		local x1, y1, x2, y2
		if particleTrail.pathIsInPixels then
			x1, y1 = p1.x, p1.y
			x2, y2 = p2.x, p2.y
		else
			x1 = lerpScalar(particleTrail.areaX, particleTrail.areaX + particleTrail.areaW, p1.x*0.5+0.5)
			y1 = lerpScalar(particleTrail.areaY, particleTrail.areaY + particleTrail.areaH, p1.y*0.5+0.5)
			x2 = lerpScalar(particleTrail.areaX, particleTrail.areaX + particleTrail.areaW, p2.x*0.5+0.5)
			y2 = lerpScalar(particleTrail.areaY, particleTrail.areaY + particleTrail.areaH, p2.y*0.5+0.5)
		end
		--line(x1, y1, x2, y2, 7)
		-- calculate brightness at start & end of line, based on total segment length and segment index.
		local brightness0 = (i-1)/(N-1)
		local brightness1 = (i)/(N-1)

		brightness0 =brightness0 * brightness0
		brightness1 = brightness1 * brightness1
		lineBayerDithered(x1, y1, x2, y2, particleTrail.gradient, 	brightness0, brightness1)
	end

end
