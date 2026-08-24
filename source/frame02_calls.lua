
function rotate(points, pitch, roll, yaw)
    local cosa = math.cos(yaw)
    local sina = math.sin(yaw)

    local cosb = math.cos(pitch)
    local sinb = math.sin(pitch)

    local cosc = math.cos(roll)
    local sinc = math.sin(roll)

    local Axx = cosa*cosb
    local Axy = cosa*sinb*sinc - sina*cosc
    local Axz = cosa*sinb*cosc + sina*sinc

    local Ayx = sina*cosb
    local Ayy = sina*sinb*sinc + cosa*cosc
    local Ayz = sina*sinb*cosc - cosa*sinc

    local Azx = -sinb
    local Azy = cosb*sinc
    local Azz = cosb*cosc

    local px = points[1]
    local py = points[2]
    local pz = points[3]

    local ox = Axx*px + Axy*py + Axz*pz
    local oy = Ayx*px + Ayy*py + Ayz*pz
    local oz = Azx*px + Azy*py + Azz*pz
    
	return {ox,oy,oz}
end

F02_orbits = nil
F02_previousI = -1
F02_idOverride = nil
F02_showShip = true

function Frame02_init()
	cls()
	vbank(1)
	cls()
	vbank(0)

	F02_previousI = -1
end

--#if DEBUG
function F02_getHMRState()
	return {
		idOverride = F02_idOverride,
		showShip = F02_showShip,
	}
end

function F02_setHMRState(state)
	F02_idOverride = state.idOverride
	F02_showShip = state.showShip
end
--#endif

F02_planetSprites = {
	"Planet_01",
	"Planet_02",
	"Planet_03",
	"Planet_04",
}
F02_shipSprites = {
	"Ship_01",
	"Ship_02",
	"Ship_03",
	"Ship_04",
}

local F02_darkBlue = { 8 }
local F02_grayscaleDarker = { 15, 14 }
local F02_grayscale = { 15, 15, 15, 14, 14, 13 } -- grayscale (+12 bright white)
local F02_greenDarker = { 7 } -- exclude the bright green. for inner orbits it creates better contrast with the planet.
local F02_green = { 15,15,15,7,7,7,6,6,5 }

F02_orbitEffectParams = {
	{
		particleCount = 500,
		orbitRadiusMin = 50,
		orbitRadiusMax = 65,
		speedMin = -0.003,
		speedMax = 0.003,
		gradients =  { F02_grayscaleDarker, F02_grayscale },
		biasMix = 0.99,
		biasInclination = 1.65,
		biasAscendingNode = 0.25,
	},
	{ -- green planet. dense and slow
		particleCount = 1500,
		orbitRadiusMin = 44,
		orbitRadiusMax = 68,
		speedMin = 0.000,
		speedMax = 0.004,
		gradients = { F02_greenDarker, F02_green },
		biasMix = 0.98,
		biasInclination = 1.65,
		biasAscendingNode = -0.13,
	},
	{
		-- charcoal planet that looks like a volleyball. maybe a thin sparse ring.
		-- but the planet doesn't rotate so too much rotation feels off.
		particleCount = 150,
		orbitRadiusMin = 55,
		orbitRadiusMax = 72,
		speedMin = -0.001,
		speedMax = 0.02,
		gradients = { F02_grayscale },
		biasMix = 0.99,
		biasInclination = 1.4,
		biasAscendingNode = 0,
	},
	{ -- green again. some middle ground.
		particleCount = 500,
		orbitRadiusMin = 50,
		orbitRadiusMax = 60,
		speedMin = 0.001,
		speedMax = 0.002,
		gradients = { F02_greenDarker, F02_green },
		biasMix = 0.99,
		biasInclination = 1.65,
		biasAscendingNode = 0.1,
	},
}


function Frame02(t,beats, somaticState)
	cls()

	local id= F02_idOverride or (beats//8%4)

	--#if DEBUG
	if keyp(28) then -- 1
		F02_idOverride = 0
	elseif keyp(29) then -- 2
		F02_idOverride = 1
	elseif keyp(30) then -- 3
		F02_idOverride = 2
	elseif keyp(31) then -- 4
		F02_idOverride = 3
	elseif keyp(32) then -- 5
		F02_showShip = not F02_showShip
	end
	--#endif

	-- when id switches, create new orbit effect.
	if F02_previousI ~= id then
		F02_previousI = id
		local param = F02_orbitEffectParams[id+1]
		F02_orbits = CreateParticleOrbitEffect(param)
	end

	-- idea is to animate the orbit plane but it's maybe just too many slow things moving around, and messes with
	-- the fact that the planet itself is stationary.
	SetParticleOrbitEffectBias(F02_orbits, F02_orbits.biasInclination + somaticState.wallDeltaMillis / 1000 * 0.02, F02_orbits.biasAscendingNode, F02_orbits.biasMix)

	UpdateParticleOrbitEffect(F02_orbits)

	math.randomseed(id)
	local r=500
	for i=0,700 do
		-- random generate points on a sphere
		local u=math.random()*2-1
		local theta=math.random()*2*math.pi
		local x=r*math.sqrt(1-u*u)*math.cos(theta)
		local y=r*math.sqrt(1-u*u)*math.sin(theta)
		local z=r*u
		-- rotate them
		local drag = (math.sin(t/2000)*.5+1)*.02
		local rp = rotate({x,y,z},t/2000,t/3200,t/1800)
		local rpb = rotate({x,y,z},t/2000+drag,t/3200+drag,t/1800+drag)
		-- project them to viewport
		if rp[3]<0 and rpb[3]<0 then
			local screenX = 120+(rp[1] / -rp[3])*240
			local screenY = 68+(rp[2] * 1.7647 / -rp[3])*136
			local screenX2 = 120+(rpb[1] / -rpb[3])*240
			local screenY2 = 68+(rpb[2] * 1.7647 / -rpb[3])*136	  
			--pix(screenX,screenY,12)
			--pix(screenX2,screenY2,4)
			line(screenX,screenY,screenX2,screenY2,12)
		end
	end

	local sx = math.sin(t/2000)*3
	local sy = math.sin(t/1800+1234+sx)*4
	-- draw planet and spaceship

	RenderParticleOrbitEffect(F02_orbits, 35+86, 35+30, false)

	drawSprite(F02_planetSprites[id+1],86,30)

	RenderParticleOrbitEffect(F02_orbits, 35+86, 35+30, true)

	if F02_showShip then
		drawSprite(F02_shipSprites[id+1],80+sx,20+sy)
		-- blinking lights
		if id == 0 then 
			pix(80+sx+0,20+sy+98,((beats//2+1)%2)+1)
			pix(80+sx+8,20+sy+90,(beats//2%2)+1)
			pix(80+sx+10,20+sy+88,((beats//2+1)%2)+1)
			pix(80+sx+11,20+sy+87,(beats//2%2)+1)
		end
		if id == 1 then
			pix(80+sx+36,20+sy+83,((beats//2+1)%2)+1)
			pix(80+sx+87,20+sy+34,(beats//2%2)+1)
		end
		if id == 3 then
			pix(80+sx+0,20+sy+26,((beats//2+1)%2)+1)
			line(80+sx+88,20+sy+58,80+sx+88,20+sy+59,(beats//2%2)+1)
		end
	end

	TwinkleTick(somaticState, "starz")
end
