--#include "booster_streaks.lua"

C03_bg = nil
C03_streaks = nil
C03_last_wall_millis = 0

-- accepts an edge { x0,y0,width,height } and a t01 in [0,1] and returns a {x,y} point along the edge.
function PointAlongLine(edge, t01)
	local x = edge.x0 + t01 * edge.width
	local y = edge.y0 + t01 * edge.height
	return { x, y }
end

C03_emitter1TopEdge = {
	x0 = 2,
	y0 = 55,
	width = 41, -- 164/4 = 
	height = 21,

	d0 = { -336, 118 },-- direction vector at start of emitter line. (not normalized yet)
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
C03_emitter2 = {
	x0 = 43 + 51,
	y0 = 74,
	width = -10,
	height = 11,

	d0 = { -314, 146 },
	d1 = { -314, 146 },
}

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

	C03_streaks = {
		C03_CreateBoosterStreakSystem(C03_emitter1TopEdge, 0.0, 0.33),
		C03_CreateBoosterStreakSystem(C03_emitter1TopEdge, 1.0, 0.66),
		C03_CreateBoosterStreakSystem(C03_emitter1RightEdge, 0.0, 1.0),
		C03_CreateBoosterStreakSystem(C03_emitter2, 0.0, 1.0),
	}

end


local C03_sprites = {
	{"C3_Element_01",200,0,1},
	{"C3_Element_02",200,-80,1},
	{"C3_Element_03",240,-120,1},
	{"C3_Element_03",40,-30,1},
	{"C3_Element_04",150,0,1},
	{"C3_Element_04",170,-150,1},
	{"C3_Element_05",360,-100,1},
	{"C3_Element_06",400,-130,1},
	{"C3_Element_07",620,-340,1},
	{"C3_Element_02",500,-300,1},
	{"C3_Element_05",280,-220,1},
	{"C3_Element_04",370,-400,1},
}

function Construction03(tt, beats, somaticState, sceneTime)
	local t = sceneTime.wallMillis
	math.randomseed(t)

	for _, s in ipairs(C03_streaks) do
		UpdateBoosterStreaks(s, somaticState.wallDeltaMillis)
	end

	cls()

	drawCachedSprite(C03_bg)

	local it = 1

	-- draw sprites
	for i=1,#C03_sprites do
		-- update
		C03_sprites[i][2] = C03_sprites[i][2] - it*C03_sprites[i][4]
		if C03_sprites[i][2] < -200 then
			C03_sprites[i][2] = C03_sprites[i][2] + 500
		end
		C03_sprites[i][3] = C03_sprites[i][3] + it*C03_sprites[i][4]*.3
		if C03_sprites[i][3] > 140 then
			C03_sprites[i][3] = C03_sprites[i][3] - 500
		end
		
		-- draw
		drawSprite(C03_sprites[i][1],C03_sprites[i][2],C03_sprites[i][3])
	end

	local shipPosX=30+math.sin(t/2000)*2
	local shipPosY=20+math.sin(t/1000)*2

	drawSprite("C3_BigShip",shipPosX,shipPosY)
	for _, s in ipairs(C03_streaks) do
		RenderBoosterStreaks(s, shipPosX, shipPosY)
	end

end
