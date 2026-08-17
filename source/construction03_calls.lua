--#include "booster_streaks.lua"

C03_bg = nil
C03_streaksBigShip = nil
C03_streaksShip01 = nil
C03_streaksShip02 = nil
C03_last_wall_millis = 0
C03_sprites = nil

-- todo: parallax speeds; but they seem to get reused in ways that are hard to predict so i leave it.
C03_spriteTemplate = {
	{ "C3_Element_01", 200, 0, 1 },
	{ "C3_Element_02", 200, -80, 1 },
	{ "C3_Element_03", 240, -120, 1 },
	{ "C3_Element_03", 40, -30, 1 },
	{ "C3_Element_04", 150, 0, 1 },
	{ "C3_Element_04", 170, -150, 1 },
	{ "C3_Element_05", 360, -100, 1 },
	{ "C3_Element_06", 400, -130, 1 },
	{ "C3_Element_07", 620, -340, 1 },
	{ "C3_Element_02", 500, -300, 1 },
	{ "C3_Element_05", 280, -220, 1 },
	{ "C3_Element_04", 370, -400, 1 },
}

-- ship stripe thresholds, indexed by x coordinate. nil means no color mapping at that x.
C03_shipStripeThresholds = {}

C03_stripes = {
	{ speed = -0.07, width = 80, period = 160 },
	{ speed = -0.14, width = 50, period = 100 },
}

function C03_UpdateShipStripeThresholds(t)
	for _, stripe in ipairs(C03_stripes) do
		local offset = (t * stripe.speed) // 1
		for x = 0, TIC_WIDTH() - 1 do
			local isStripe = (x - offset) % stripe.period < stripe.width
			if isStripe then
				if C03_shipStripeThresholds[x] == nil then
					-- combine.
					C03_shipStripeThresholds[x] = -0.2
				else
					C03_shipStripeThresholds[x] = C03_shipStripeThresholds[x] + 0.2
				end
			else
				C03_shipStripeThresholds[x] = nil
			end
		end
	end
end

-- specialization of drawsprite with some palette swapping / dithering.
function C03_DrawSpriteStripped(spr,posx, posy, t)
	C03_UpdateShipStripeThresholds(t)

	local sprite = sprites[spr]
	local w = sprite.w
	local h = sprite.h
	local c = sprite.data
	local bkg = sprite.bg
	local stripeThresholds = C03_shipStripeThresholds
	local bayer = BAYER_MINUS_5
	posx = posx // 1
	posy = posy // 1

	for y = 0, h - 1 do
		local screenY = posy + y
		if screenY >= 0 and screenY < TIC_HEIGHT() then
			local srcRow = y * w
			local screenRow = screenY * TIC_WIDTH()
			local x0 = max(0, ceil(-posx))
			local x1 = min(w, ceil(TIC_WIDTH()-posx))
			local stripeSkew = (y * -2.5) // 1
			for x = x0, x1 - 1 do
				local col = c[x + srcRow]
				if col ~= bkg then
					local screenX = posx + x
					if col == 3 then
						local threshold = stripeThresholds[(x + stripeSkew) % TIC_WIDTH()]
						if threshold and bayer[screenRow + screenX] > threshold then
							col = 4
						end
					elseif col == 2 then
						local threshold = stripeThresholds[(x + stripeSkew) % TIC_WIDTH()]
						if threshold and bayer[screenRow + screenX] > threshold then
							col = 3
						end
						-- elseif col == 1 then
						-- 	local threshold = stripeThresholds[(x + stripeSkew) % TIC_WIDTH()]
						-- 	if threshold and bayer[screenRow + screenX] > threshold then
						-- 		col = 2
						-- 	end
					end
					pix(screenX, screenY, col)
				end
			end
		end
	end
end

C03_emitter1TopEdge = {
	x0 = 2,
	y0 = 55,
	width = 41, -- 164/4 =
	height = 21,

	d0 = { -336, 118 }, -- direction vector at start of emitter line. (not normalized yet)
	d1 = { -314, 146 }, -- direction vector at end of emitter line. (not normalized yet)
}
C03_emitter1RightEdge = {
	x0 = 43,
	y0 = 76,
	width = 0,
	height = 6,

	d0 = { -314, 146 },
	d1 = { -314, 146 },
}
C03_emitter2 = { -- side thing on main ship
	x0 = 43 + 51,
	y0 = 74,
	width = -10,
	height = 11,

	d0 = { -314, 146 },
	d1 = { -314, 146 },
}
C03_emitter3Ship01 = { -- small bottom ship.
	x0 = 2,
	y0 = 25,
	width = 10,
	height = 5,

	d0 = { -50, 26 },
	d1 = { -38, 19 },
}
C03_emitter5Ship02 = { -- small top ship: big vertical booster
	x0 = 2,
	y0 = 6,
	width = 3,
	height = 74,

	d0 = { -46, 10 },
	d1 = { -50, 18 },
}
-- small top ship: tiny booster. to make the direction consistent with the big vertical booster, just copy it and shift right.
C03_emitter4Ship02 = deepcopy(C03_emitter5Ship02) 
C03_emitter4Ship02.x0 = C03_emitter4Ship02.x0 + 13
C03_emitter4Ship02.width = 7

function C03_CreateBoosterStreakSystem(edge, t0, t1)
	-- define the emitter segment of the provided edge.
	local emitterP0 = PointAlongLine(edge, t0)
	local emitterP1 = PointAlongLine(edge, t1)
	local d0 = lerp(edge.d0, edge.d1, t0)
	local d1 = lerp(edge.d0, edge.d1, t1)

	return CreateBoosterStreaks({
		emitterX0 = emitterP0[1],
		emitterY0 = emitterP0[2],
		emitterX1 = emitterP1[1], -- orig + width
		emitterY1 = emitterP1[2], -- orig + height
		direction0X = d0[1],
		direction0Y = d0[2],
		direction1X = d1[1],
		direction1Y = d1[2],
	})
end

function Construction03_init()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	C03_bg = createCachedSprite("C3_Bg_ditter", 0, 0)

	C03_sprites = deepcopy(C03_spriteTemplate)

	C03_streaksBigShip = {
		C03_CreateBoosterStreakSystem(C03_emitter1TopEdge, 0.0, 0.33),
		C03_CreateBoosterStreakSystem(C03_emitter1TopEdge, 1.0, 0.66),
		C03_CreateBoosterStreakSystem(C03_emitter1RightEdge, 0.0, 1.0),
		C03_CreateBoosterStreakSystem(C03_emitter2, 0.0, 1.0),
	}

	C03_streaksShip01 = {
		C03_CreateBoosterStreakSystem(C03_emitter3Ship01, 0.0, 1.0),
	}

	C03_streaksShip02 = {
		C03_CreateBoosterStreakSystem(C03_emitter4Ship02, 0.22, 0.3),
		C03_CreateBoosterStreakSystem(C03_emitter5Ship02, 0.0, 0.33),
	}
end

function Construction03(tt, beats, somaticState, sceneTime)
	local t = sceneTime.wallMillis
	math.randomseed(t)

	for _, s in ipairs(C03_streaksBigShip) do
		UpdateBoosterStreaks(s, somaticState.wallDeltaMillis)
	end

	for _, s in ipairs(C03_streaksShip01) do
		UpdateBoosterStreaks(s, somaticState.wallDeltaMillis)
	end

	for _, s in ipairs(C03_streaksShip02) do
		UpdateBoosterStreaks(s, somaticState.wallDeltaMillis)
	end

	cls()

	drawCachedSprite(C03_bg)

	local it = 1

	-- draw sprites
	for i = 1, #C03_sprites do
		-- update
		C03_sprites[i][2] = C03_sprites[i][2] - it * C03_sprites[i][4]
		if C03_sprites[i][2] < -200 then
			C03_sprites[i][2] = C03_sprites[i][2] + 500
		end
		C03_sprites[i][3] = C03_sprites[i][3] + it * C03_sprites[i][4] * 0.3
		if C03_sprites[i][3] > 140 then
			C03_sprites[i][3] = C03_sprites[i][3] - 500
		end

		-- draw
		drawSprite(C03_sprites[i][1], C03_sprites[i][2], C03_sprites[i][3])
	end

	local shipPosX = 30 + sin(t / 2000) * 2
	local shipPosY = 20 + sin(t / 1000) * 2
	C03_DrawSpriteStripped("C3_BigShip",shipPosX, shipPosY, t)
	for _, s in ipairs(C03_streaksBigShip) do
		RenderBoosterStreaks(s, shipPosX, shipPosY)
	end

	-- bottom right ship
	--drawSprite("C3_Ship01", 170 + sin(t/1800+123)*2, 90 + sin(t/900+13)*2)
	shipPosX = 170 + sin(t/1800+123)*2
	shipPosY = 90 + sin(t/900+13)*2
	C03_DrawSpriteStripped("C3_Ship01", shipPosX, shipPosY, t+1260)
	for _, s in ipairs(C03_streaksShip01) do
		RenderBoosterStreaks(s, shipPosX, shipPosY)
	end

	-- top left ship
	--drawSprite("C3_Ship02",30 + sin(t/1700+23)*1.5,16 + sin(t/800+3)*2)
	shipPosX = 30 + sin(t/1700+23)*1.5
	shipPosY = 16 + sin(t/800+3)*2
	C03_DrawSpriteStripped("C3_Ship02",shipPosX, shipPosY, t/2+2260)
	for _, s in ipairs(C03_streaksShip02) do
		RenderBoosterStreaks(s, shipPosX, shipPosY)
	end

end
