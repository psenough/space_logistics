function EvokeCodaInit()
    vbank(0)
    cls(0)
    vbank(1)
    cls(0)
    vbank(0)
end

-- 
TEvoke_shipsHoriz = {
	{
		0, -- x
		24, -- y
		60, -- speed
		"TEvoke_Ship_01", -- sprite
		{
			{ 5, 9, 3 }, -- 
		},
        0,-- current X position.
	},
	{
		0, -- x
		50, -- y
		50, -- speed
		"TEvoke_Ship_04", -- sprite
		{
			{ -1, 0, 2 }, -- streak offset x, offset y, width
			{ -1, 9, 2 },
		},
        0,-- current X position.
	},
	{
		0, -- x
		99, -- y
		40, -- speed
		"TEvoke_Ship_02", -- sprite
		{
			{ -1, 3, 2 }, -- streak offset x, offset y, width
			{ -1, 6, 2 },
		},
        0,-- current X position.
	},
	{
		0, -- x
		110, -- y
		60, -- speed
		"TEvoke_Ship_03", -- sprite
		{
			{ -1, 3, 2 }, -- streak offset x, offset y, width
			{ -1, 12, 2 },
		},
        0,-- current X position.
	},
}

function RenderShipsHoriz(somaticState, t)
    t = t * 9
	for _, ship in ipairs(TEvoke_shipsHoriz) do
		local x, y, speed, sprite = ship[1], ship[2], ship[3], ship[4]
		local newX = x + t // speed
		drawSpriteRotated90(sprite, newX, y)
		-- for _, streak in ipairs(ship[5]) do
        --     rect(0, y + streak[2], newX + streak[1], streak[3], 10)
		-- end
	end
end


function EvokeCodaTick(_, _, somaticState, sceneTiming)
    cls(0)
	drawSprite("TEvoke_bg",0,0)

    local event = QuerySideChannelPart(somaticState, "endAccent")

    drawSprite("SPRITE_TICKETBG", 0, 9)
    drawSprite("SPRITE_LOGO", 3, 15)
    drawSprite("SPRITE_TEXTFIELD", 4, 67)

    if sceneTiming.demoBeats > 3 then
        drawSprite("SPRITE_DESTINATION", 6, 70)
    end
    if sceneTiming.demoBeats > 5 then
        drawSprite("SPRITE_BOARDINGTIME", 6, 88)
    end

    --AddHudMessage(string.format("eventcount = %d", event.count))

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
    RenderShipsHoriz(somaticState, sceneTiming.demoMillis)

    TwinkleTick(somaticState, "starz")
end

