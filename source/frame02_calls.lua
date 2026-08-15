
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

function Frame02_init()
	cls()
	vbank(1)
	cls()
	vbank(0)

	local gradients = { { 0,15, 15, 15,  14, 14, 13 } } -- grayscale (+12 bright white)
	local speed = 0.001-- 0.015
	local speedVariance = 0.005
	local orbitRadius = 50--40

	F02_orbits = CreateParticleOrbitEffect({
		particleCount = 250,
		orbitRadiusMin = orbitRadius,
		orbitRadiusMax = orbitRadius + 10,
		speedMin = speed - speedVariance,
		speedMax = speed + speedVariance,
		gradients = gradients,
		biasMix = 0.99,
		biasInclination = 1.65,
		biasAscendingNode = 0.13,
	})
end

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

function Frame02(t,beats, somaticState)
	cls()

	UpdateParticleOrbitEffect(F02_orbits)

	local id=beats//8%4
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

	drawSprite(F02_shipSprites[id+1],80+sx,20+sy)

	TwinkleTick(somaticState)
end
