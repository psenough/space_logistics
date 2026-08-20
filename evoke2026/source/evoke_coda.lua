--#include "sprite.lua"
 
TEvoke_shipsHoriz = nil
TEvoke_shipsHoriz_template = {
	{
		-32, -- start x
		12, -- y
		0, -- current speed
		"TEvoke_Ship_01", -- sprite
		{ -- streak defs
			{ 5, 9, 3 }, -- 
		},
        0,-- current X position.
        1, -- launch on scene beat.
        60, -- nominal speed ([3] gets set to this upon launch.)
        0, -- basebeat when launched from
	},
	{
		-22, -- x
		68, -- y
		0, -- speed
		"TEvoke_Ship_04", -- sprite
		{
			{ -1, 0, 2 }, -- streak offset x, offset y, width
			{ -1, 9, 2 },
		},
        0,-- current X position.
        5, -- launch on scene beat.
        60, -- nominal speed ([3] gets set to this upon launch.)
        0, -- basebeat
	},
	{
		-14, -- x
		87, -- y
		0, -- speed
		"TEvoke_Ship_02", -- sprite
		{
			{ -1, 3, 2 }, -- streak offset x, offset y, width
			{ -1, 6, 2 },
		},
        0,-- current X position.
        7, -- launch on scene beat.
        60, -- nominal speed ([3] gets set to this upon launch.)
        0, -- basebeat
	},
	{
		-27, -- 1 x
		109, --2  y
		0, -- 3 speed
		"TEvoke_Ship_03", -- 4 sprite
		{ -- 5 streak defs
			{ -1, 3, 2 }, -- streak offset x, offset y, width
			{ -1, 12, 2 },
		},
        0,-- 6 current X position.
        3, -- 7 launch on scene beat.
        60, -- 8 nominal speed ([3] gets set to this upon launch.)
        0, -- 9 basebeat
	},
}


function EvokeCodaInit()
    vbank(0)
    cls(0)
    vbank(1)
    cls(0)
    vbank(0)

    TEvoke_shipsHoriz = deepcopy(TEvoke_shipsHoriz_template)
end


function RenderShipsHoriz(somaticState, sceneTiming)
	for _, ship in ipairs(TEvoke_shipsHoriz) do
		local x, y, speed, sprite = ship[1], ship[2], ship[3], ship[4]

        local beatsElapsed = sceneTiming.demoBeats - ship[9]

		local newX = ship[1] + speed * beatsElapsed * 4
		drawSpriteRotated90(sprite, newX, y)
        ship[6] = newX
		for _, streak in ipairs(ship[5]) do
            local right = newX + streak[1]
            local streakLength = 80
            FillRectDitheredTransparencyPerColumn(right - streakLength, y + streak[2], streakLength, streak[3], 10,
            function(col, t01) return
                t01 * t01
            end)
		end
	end
end


function EvokeCodaTick(_, _, somaticState, sceneTiming)
    cls(0)
	drawSprite("TEvoke_bg",0,0)

    local event = QuerySideChannelPart(somaticState, "endAccent")
    
    -- launch ships
    for _, ship in ipairs(TEvoke_shipsHoriz) do
        local launchBeat = ship[7] - 0.2 -- launch slightly before the beat to account for the ship's width.
        if sceneTiming.demoBeats >= launchBeat and ship[3] == 0 then
            ship[9] = sceneTiming.demoBeats -- ship[9] = basebeat when launched
            ship[3] = ship[8] -- ship[3] = current speed = nominal speed
        end
    end

    --#ifdef DEBUG
    AddHudMessage(string.format("sceneTiming.demoBeats = %f", sceneTiming.demoBeats))
    --#endif

    drawSprite("SPRITE_TICKETBG", 0, 9)

    drawSprite("SPRITE_TEXTFIELD", 4, 67)

    PushClipRect(0, 0, TEvoke_shipsHoriz[1][6], TIC_HEIGHT())
    drawSprite("SPRITE_LOGO", 3, 15)
    PopClipRect()

    PushClipRect(0, 0, TEvoke_shipsHoriz[2][6], TIC_HEIGHT())
    drawSprite("SPRITE_DESTINATION", 6, 70)
    PopClipRect()

    PushClipRect(0, 0, TEvoke_shipsHoriz[3][6], TIC_HEIGHT())
    drawSprite("SPRITE_BOARDINGTIME", 6, 88)
    PopClipRect()

    -- "boarding pass" is part of the background; reveal it under a rect.
    local boardingPassRevealX = TEvoke_shipsHoriz[4][6]
    rect(max(50, boardingPassRevealX), 111, 187, 12,15)

    local cha = QuerySideChannelPart(somaticState, "cha")
    if cha.count == 1 or cha.count == 3 then
        drawSprite("SPRITE_CANCELED", 33, 12)
        if cha.count == 3 and cha.justHit then
            for i = 1, 10 do
                AddTwinkle()
            end
        end
    end

    -- render the TEvoke_ships
    RenderShipsHoriz(somaticState, sceneTiming)

    TwinkleTick(somaticState, "starz")
end

