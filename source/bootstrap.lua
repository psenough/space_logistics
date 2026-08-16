-- space logistics --

--#pragma once

--#macro TIC_HEIGHT() => 136
--#macro TIC_WIDTH() => 240

function assert(condition, message)
	if not condition then
		error(message or "assertion failed")
	end
end

-- t is an array
-- x = 0..1; 0 = left, 1 = right, evenly distributed over array.
-- returns the INDEX (not value)
-- yes this is not totally necessary but helps my tiny brain read code.
function SelectNorm(table, x)
	return ((x * #table) // 1) + 1
end

local min, max, random, ceil = math.min, math.max, math.random, math.ceil
local sin, cos, sqrt = math.sin, math.cos, math.sqrt

function clamp01(x)
	if x < 0 then return 0 end
	if x > 1 then return 1 end
	return x
end


local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

-- the rle-decoder
function unpac(str)
  local r = str:sub(1,5) -- get (o)ffset into (r)aw data
  local r = r .. str:sub(6,8) -- get (w)idth into (r)aw data
  local e=str:sub(9,str:len()) -- remove header to get (e)ncoded data
  local d = "" -- (d)ecoded data
  for m, c in e:gmatch("(%u+)([^%u]+)") do -- decode rle, (m)atch & (c)ounter
    d = d .. m .. (m:sub(-1):rep(c)) -- (d)ecoded data
  end
  for x = 1,#d,1 do -- get (d)ecoded data into (r)aw data
    r = r .. string.format("%x",(string.byte(d:sub(x,x))-65))
  end
  return r
end

function unpac_noheader(str)
  local r = ""
  local d = "" -- (d)ecoded data
  for m, c in str:gmatch("(%u+)([^%u]+)") do -- decode rle, (m)atch & (c)ounter
    d = d .. m .. (m:sub(-1):rep(c)) -- (d)ecoded data
  end
  for x = 1,#d,1 do -- get (d)ecoded data into (r)aw data
    r = r .. string.format("%x",(string.byte(d:sub(x,x))-65))
  end
  return r
end

-- the raw-decoder
function tomem(str,adr)
  local o = adr or tonumber(str:sub(1,5),16) -- get (o)ffset, from param or string
  local w=tonumber(str:sub(6,8),16)-1 -- get (w)idth
  local d=str:sub(9,str:len()) -- remove header to get (d)ata
  local y=0
  for x = 1,#d,1 do -- write to mem
    local c=tonumber(d:sub(x,x),16) -- get (c)olor value
    poke4(o+y,c) y=y+1
    if y>w then y=0 o=o+1024 end
  end
end

local sprites = {}

function loadSprite(name,w,h,bg)
	sprites[name] = { w=w, h=h, bg=bg, data={}	}
	cls(sprites[name].bg)
	spr(256,0,0,sprites[name].bg,1,0,0,16,16)
	for x=0,sprites[name].w-1 do
		for y=0,sprites[name].h-1 do
			sprites[name].data[x+y*sprites[name].w] = pix(x,y)
		end
	end
end

function loadExtendedSprite(ref,name,w,h,bg)
	sprites[name] = { w=w, h=h, bg=bg, data={}	}
	--cls(sprites[name].bg)
	--spr(256,0,0,sprites[name].bg,1,0,0,16,16)
	local i=0
	for m in string.gmatch(ref, '%x') do
	 sprites[name].data[i]=tonumber(m,16)
	 i=i+1
	end	
end

function sweetie16_init()
	tomem(unpac(pal))
	poke(0x3FF8, 0) -- border
	poke(0x3FF9, 0) -- screen offset
	poke(0x3FFA, 0)
end

function no_fn()
end

--------------------------------------------------------------------------------------------------------
-- http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- a and b are {x,y}; returns {x,y}
function lerp(a,b,t)
	return {
		(1-t)*a[1]+t*b[1],
		(1-t)*a[2]+t*b[2]
	}
end

function lerpScalar(a,b,t)
  return a + (b-a)*t
end

function lerpAngular(a,b,t)
  local diff = (b-a+math.pi)%(2*math.pi)-math.pi
  return a + diff*t
end

function bilerpScalar(a,b,c,d,tx,ty)
  local ab = lerpScalar(a,b,tx)
  local cd = lerpScalar(c,d,tx)
  return lerpScalar(ab,cd,ty)
end

-- speed or radius...
function polarToCartesian(angle, length)
  local dx = math.cos(angle) * length
  local dy = math.sin(angle) * length
  return dx, dy
end

function DxDyToAngle(dx, dy)
  return math.atan2(dy, dx)
end

function normalize2D(x,y)
    local len = math.sqrt(x*x + y*y)
    if len == 0 then
        return 0,0
    end
    return x/len, y/len
end


--------------------------------------------------------------------------------------------------------
-- generic particle system
function UpdateParticle(p,dt)
	p.x = p.x + p.dx * dt
	p.y = p.y + p.dy * dt
	p.age = p.age + dt
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
	dt = dt or 1
	for i = #pool.particles, 1, -1 do
		local p = pool.particles[i]
		UpdateParticle(p, dt)
		if p.age >= p.life then
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

function CreateStar(starField, params, parallaxLayer01, init)
	local star = {
		x = init and math.random(0, 240) or 241,
		y = math.random(0, 136),
		dx = lerpScalar(params.dxMin, params.dxMax, math.random()) * parallaxLayer01,
		dy = lerpScalar(params.dyMin, params.dyMax, math.random()) * parallaxLayer01,
		life = 99999, -- effectively infinite
		onDeath = function(p)
			local newStar = CreateStar(starField, params, parallaxLayer01, false)
			AddParticleToPool(starField, newStar)
		end,
		should86 = function(p)
			return p.x < -20 or p.x > 260 or p.y < -20 or p.y > 156
		end,
		-- custom props
		seed = math.random(),
		colorIndex = math.random(1, #StarGradient) * parallaxLayer01,
		radius = lerpScalar(params.radiusMin, params.radiusMax, parallaxLayer01),
	}
	return star
end

function CreateStarField(params)
	local stars = {}
	if not params then
		params = {}
	end
	params.numParallaxLayers = params.numParallaxLayers or 3
	params.density = params.density or 10
	params.dxMin = params.dxMin or -0.015
	params.dxMax = params.dxMax or 0.015
	params.dyMin = params.dyMin or 0
	params.dyMax = params.dyMax or 0
	params.radiusMin = params.radiusMin or 0.1
	params.radiusMax = params.radiusMax or 0.5

	-- calc # of stars first
	local starCount = 0
	for parallaxLayer = 1, params.numParallaxLayers do
		starCount = starCount + params.density * parallaxLayer
	end

	local starField = CreateParticlePool(starCount)
	--starField.params = params

	for parallaxLayer = 1, params.numParallaxLayers do
		-- norm should actually hit  0 and 1
		local layer01 = (parallaxLayer - 1) / (params.numParallaxLayers - 1)
		local numStars = params.density * parallaxLayer
		for i=1, numStars do
			table.insert(stars, CreateStar(starField, params, layer01, true))
		end	
	end

	-- assert
	if #stars ~= starCount then
		error("star count mismatch")
	end

	for _, star in ipairs(stars) do
		AddParticleToPool(starField, star)
	end
	return starField
end

-- dt = step units; optional - nominal = 1
function UpdateStarField(starField, dt)
	UpdateParticlePool(starField, dt)
end

function RenderStarField(starField, t)
	for i,p in ipairs(starField.particles) do
		-- twinkle effect nudges gradient index.
		local twinkleRate = 0.005
		local twinkle = math.sin(t * twinkleRate * p.seed + (6.28 * p.seed)) + 0.5 -- bias so it's mostly positive(on)
		local twinkleIndexNudge = twinkle > 0 and 2 or 0
		local colIndex = math.min(p.colorIndex + twinkleIndexNudge, #StarGradient)
		circ(p.x, p.y, p.radius,  StarGradient[colIndex])
	end
end

--------------------------------------------------------------------------------------------------------

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

function pixBayer(x, y, gradient, gradientCount, brightness)
	local row = y * TIC_WIDTH()
	local bayer = BAYER_MINUS_5[row + x]
	local col = gradient[max(1, min(gradientCount, (brightness + bayer) * gradientCount)) // 1]
	pix(x, y, col)
end

function hlineBayer(x1, x2, y, gradient, gradientCount, brightness)
	-- screen clip.
	if y < 0 or y >= TIC_HEIGHT() then
		return
	end
	x1 = max(0, x1) // 1
	x2 = min(TIC_WIDTH() - 1, x2) // 1
	local row = (y * TIC_WIDTH()) // 1
	for x = x1, x2 do
		local bayer = BAYER_MINUS_5[row + x]
		local col = gradient[max(1, min(gradientCount, (brightness + bayer) * gradientCount)) // 1]
		pix(x, y, col)
	end
end

-- specialization of hline that draws only the shadow pixels (others = transparent). darkenAmt01 is amount of shade.
function hlineBayerShadow(x1, x2, y, colorShadow, darkenAmt01)
	-- screen clip.
	if y < 0 or y >= TIC_HEIGHT() then
		return
	end
	x1 = max(0, x1) // 1
	x2 = min(TIC_WIDTH() - 1, x2) // 1
	local row = (y * TIC_WIDTH()) // 1
	 -- offset to account for 0.5 bayer centering instead of calculating per pixel
	 -- and a bit of bias so first row is not 100% shade
	darkenAmt01 = darkenAmt01 - 0.6
	for x = x1, x2 do
		local bayer = BAYER_MINUS_5[row + x]
		if darkenAmt01 > bayer then
			local col = colorShadow
			pix(x, y, col)
		end
	end
end

function vlineBayer(x, y1, y2, gradient, gradientCount, brightness)
	x = x // 1
	y1 = y1 // 1
	y2 = y2 // 1
	-- screen clip.
	if x < 0 or x >= TIC_WIDTH() then
		return
	end
	y1 = max(0, y1) // 1
	y2 = min(TIC_HEIGHT() - 1, y2) // 1
	for y = y1, y2 do
		local row = (y * TIC_WIDTH()) // 1
		local bayer = BAYER_MINUS_5[row + x]
--#ifdef DEBUG
		if bayer == nil then
			error(string.format("bayer is nil at x=%d, y=%d", x, y))
		end
--#endif
		local col = gradient[max(1, min(gradientCount, (brightness + bayer) * gradientCount)) // 1]
		pix(x, y, col)
	end
end

-- renders a circle with a shade function returning the 0..1 gradient position for the pixel.
function ShadeCircleBayer(cx, cy, r, gradient, shadeFunc)
	local r2 = r * r
	local gradientCount = #gradient
	local bayer = BAYER_MINUS_5

	-- screen space clipping
	local yFrom = max(-r, -cy) -- yfrom/to/y are relative to center.
	local yTo = min(r, TIC_HEIGHT() - 1 - cy)
	for y = yFrom, yTo do
		local screenY = cy+y
		-- y is offset from center, screenY is actual pixel coordinate
		local y2 = y * y
		local span = sqrt(r2 - y2) // 1
		local xFrom = max(-span, -cx) -- clipping
		local xTo = min(span, TIC_WIDTH() - 1 - cx)
		local screenY240 = screenY * TIC_WIDTH()
		for x = xFrom, xTo do
			local screenX = cx+x
			-- x is offset from center, screenX is actual pixel coordinate
			if x*x + y2 <= r2 then -- inside circle
				-- x and y are offsets from center; 
				local tone01 = shadeFunc(cx+x, screenY)
				if tone01 ~= nil then
					--pix(screenX, screenY, col)
					--pixBayer(screenX, screenY, gradient, gradientCount, tone01)
					local b = bayer[screenY240 + screenX]
					pix(screenX, screenY, gradient[max(1, min(gradientCount, (tone01 + b) * gradientCount)) // 1])
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
-- 1 input value, 1 output value, 0..1

-- https://stackoverflow.com/questions/12964279/whats-the-origin-of-this-glsl-rand-one-liner
function hash11(t)
	local x = math.sin(t * 12.9898) * 43758.5453
	return x - math.floor(x)
end

-- self-contained stateful rng; semantics like math.random.
-- usage:
-- local rng = CreateRng(12345)
-- RngNext(rng) -- returns a number between 0 and 1
-- RngNext(rng, min, max) -- returns a number between min and max
function CreateRng(seed)
	return { seed = seed or time() }
end

-- https://github.com/dylang/shortid/blob/master/lib/random/random-from-seed.js
function RngNext(rng, min, max)
	rng.seed = (rng.seed * 9301 + 49297) % 233280
	local value = rng.seed / 233280
	if min and max then
		return (min + value * (max - min)) // 1
	else
		return value
	end
end

function fract(x)
  return x - (x//1)
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
	for i=0,steps do
		callback(math.floor(x), math.floor(y), i/steps)
		x = x + xInc
		y = y + yInc
	end
end
