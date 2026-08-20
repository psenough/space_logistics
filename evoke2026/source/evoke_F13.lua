--#include "booster_streaks.lua"

E13_ships = {} -- particles! ship particles!
E13_shipEmissionCountdownMS = 0
E13_contrailGradient = { 8, 1, 2, 3, 4 } -- background -> red -> yellow
E13_shipGradients = {
    { 8,  9, 10, 11, 11},-- blue ships
    {8, 7, 6, 5, 5},-- green ships
}

E13_shipSpeedMin = 0.04
E13_shipSpeedMax = 0.2
E13_shipDefs = {
	{
		xStart = -32, -- start x such that it's off screen
		sprite = "TEvoke_Ship_01", -- sprite
		streakDefs = { -- streak defs
			{ 5, 9, 3 },
		},
	},
	{
		xStart = -22, -- x
		sprite = "TEvoke_Ship_04", -- sprite
		streakDefs = {
			{ -1, 0, 2 }, -- streak offset x, offset y, height
			{ -1, 9, 2 },
		},
	},
	{
		xStart = -14, -- x
		sprite = "TEvoke_Ship_02", -- sprite
		streakDefs = {
			{ -1, 3, 2 }, -- streak offset x, offset y, height
			{ -1, 6, 2 },
		},
	},
	{
		xStart = -27, -- 1 x
		sprite = "TEvoke_Ship_03", -- 4 sprite
		streakDefs = { -- 5 streak defs
			{ -1, 3, 2 }, -- streak offset x, offset y, height
			{ -1, 12, 2 },
		},
	},
}

-- adds a ship to the pool.
function E13_EmitShip()
	local shipDefId = math.random(1, #E13_shipDefs)
	local shipDef = E13_shipDefs[shipDefId]
	local sprite = sprites[shipDef.sprite]
	local rotatedHeight = sprite.w

    local speedRand = math.random()

	local ship = {
		x = shipDef.xStart,
		y = lerpScalar(0, TIC_HEIGHT(), math.random()),
		dx = lerpScalar(E13_shipSpeedMin, E13_shipSpeedMax, speedRand),
		shipDef = shipDef,
		contrails = CreateParticlePool(160), -- yo dawg i heard you like particles so i put particles in your particles
        fill01 = speedRand,
        gradient = E13_shipGradients[math.random(1, #E13_shipGradients)],
	}
	table.insert(E13_ships, ship)
end

function E13_AddContrailParticle(ship, streakDef)
	local ownAngle = math.random() * 6.28
	local cloudAngle = lerpAngular(ownAngle, 0, 0.9)
	local speed = lerpScalar(0.002, 0.008, math.random())
	local emitterHeight = streakDef[3]
	AddParticleToPool(ship.contrails, {
		x = ship.x + streakDef[1],
		y = ship.y + streakDef[2] + math.random() * (emitterHeight - 1),
		dx = cos(cloudAngle) * speed,
		dy = sin(cloudAngle) * speed,
		life = math.random(1400, 2600) * 0.5,
		radius = lerpScalar(1.25, 2.25, math.random()),
		should86 = function(p)
			return p.x < -10 or p.x > 250 or p.y < -10 or p.y > 146
		end,
	})
end

function E13_UpdateContrails(ship, dtMS)
	UpdateParticlePool(ship.contrails, dtMS)

    if dtMS <= 0 then -- no emission during paus.
        return
    end

	for _, streakDef in ipairs(ship.shipDef.streakDefs) do
		if math.random() < 0.75 then
			E13_AddContrailParticle(ship, streakDef)
		end
	end
end

function E13_RenderContrails(ship)
	for _, particle in ipairs(ship.contrails.particles) do
		local age01 = clamp01(particle.age / particle.life)
		local gradientIndex = math.max(1, math.ceil((1 - age01) * #E13_contrailGradient))
		circ(
			particle.x,
			particle.y,
			(1 - age01) * particle.radius,
			E13_contrailGradient[gradientIndex]
		)
	end
end

function E13_UpdateShips(dtMS)

    -- prevent emission during pause
    if dtMS > 0 and math.random() < 0.1 then
        E13_EmitShip()
    end

	for i = #E13_ships, 1, -1 do
		local ship = E13_ships[i]
		ship.x = ship.x + ship.dx * dtMS

		E13_UpdateContrails(ship, dtMS)

		if ship.x >= TIC_WIDTH() and #ship.contrails.particles == 0 then
			table.remove(E13_ships, i)
		end
	end
end

function E13_RenderShips(somaticState, sceneTime)
	local shipRotation = math.pi/2
	local b = max(0, sceneTime.demoBeats - 23)
	if b > 0 then
		shipRotation = math.pi/2 + (b * 1.2)
	end
	for _, ship in ipairs(E13_ships) do
		E13_RenderContrails(ship)
		local sprite = sprites[ship.shipDef.sprite]
		-- keep anchored
		local rotationAnchorOffset = (sprite.h - sprite.w) // 2
		--drawSpriteRotated90(ship.shipDef.sprite, ship.x, ship.y)
        --fillSpriteRotated90WithDither(ship.shipDef.sprite, ship.x, ship.y, ship.gradient, ship.fill01)
		drawSpriteWithRotationAsMaskAndDither(
			ship.shipDef.sprite,
			ship.x + rotationAnchorOffset,
			ship.y - rotationAnchorOffset,
			ship.gradient,
			ship.fill01,
			shipRotation
		)
	end
end

function E13_RenderTitle(seqItem, fadeIn01)
	local logX = 5
	local logY = 10
	drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_02",logX+189,logY-4, 1) -- little bits
	drawSpriteDitheredWithBackgroundFlippedHV("TEvoke_SpaceAirline_02",-20,120, 1) -- little bits
	drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_03",logX+168,logY+27, fadeIn01)
	drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_04",logX+0,logY+10, fadeIn01)
	--drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_01",logX+30,logY+20, fadeIn01) -- text logo
end

function Evoke13Init()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	math.randomseed(1234)
	E13_ships = {}
	E13_EmitShip()
end

function Evoke13Tick(_, _, somaticState, sceneTime)
	cls(8)
	AddHudMessage(string.format("sceneBeat: %.2f", sceneTime.demoBeats))

	--drawSprite("TEvoke_bg",0,0)
	E13_RenderTitle(sceneTime, 0.5)
	--E13_RenderTitle(sceneTime, 1)

	E13_UpdateShips(somaticState.demoDeltaMillis)
	E13_RenderShips(somaticState, sceneTime)
end
