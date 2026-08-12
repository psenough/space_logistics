-- space logistics

local min, max = math.min, math.max
local sin, cos, sqrt = math.sin, math.cos, math.sqrt

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

function lerpScalar(a,b,t)
  return a + (b-a)*t
end

function lerpAngular(a,b,t)
  local diff = (b-a+math.pi)%(2*math.pi)-math.pi
  return a + diff*t
end

function angleToDxDy(angle, speed)
  local dx = math.cos(angle) * speed
  local dy = math.sin(angle) * speed
  return dx, dy
end

function DxDyToAngle(dx, dy)
  return math.atan2(dy, dx)
end

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

TIC_HEIGHT = 136
TIC_WIDTH = 240

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
for sy = 0, TIC_HEIGHT - 1 do
	local y4 = (sy % 4) * 4
	local row = sy * TIC_WIDTH
	for sx = 0, TIC_WIDTH - 1 do
		BAYER_MINUS_5[row + sx] = (B4N[y4 + (sx % 4) + 1] - 0.5)
	end
end

function pixBayer(x, y, gradient, gradientCount, brightness)
	local row = y * TIC_WIDTH
	local bayer = BAYER_MINUS_5[row + x]
	local col = gradient[max(1, min(gradientCount, (brightness + bayer) * gradientCount)) // 1]
	pix(x, y, col)
end

-- renders a circle with a shade function returning the 0..1 gradient position for the pixel.
function ShadeCircleBayer(cx, cy, r, gradient, shadeFunc)
	local r2 = r * r
	local gradientCount = #gradient
	local bayer = BAYER_MINUS_5
	for y = -r, r do
		local y2 = y * y
		local screenY = cy+y
		local screenY240 = screenY * 240
		if screenY >= 0 and screenY < 136 then
			for x = -r, r do
				local screenX = cx+x
				if screenX >= 0 and screenX < 240 then
					if x*x + y2 <= r2 then
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
	end
end
