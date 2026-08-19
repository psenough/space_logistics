
TEvoke_logoSequencer = nil
TEvoke_shipSequencer = nil
TEvoke_titleLogoSequencer = nil

function TEvoke_drawLogo(y, asMask)
	local x = 10
	if asMask then
		drawSpriteAsMask("TEvoke_Checkingin_01", x + 40, y, 0)
		drawSpriteAsMask("TEvoke_Checkingin_02", x, y - 12, 0)
		drawSpriteAsMask("TEvoke_Checkingin_03", x + 117, y - 1, 0)
	else
		drawSprite("TEvoke_Checkingin_01", x + 40, y)
		drawSprite("TEvoke_Checkingin_02", x, y - 12)
		drawSprite("TEvoke_Checkingin_03", x + 117, y - 1)
	end
end

TEvoke_logoSequenceDef = {
	{
		tick = function(_, somaticState)
			local accent = QuerySideChannelPart(somaticState, "introAccent")
			-- for the first accent, don't draw for a couple frames, so that the first frame of the demo isn't a black void.
			if accent.count == 1 and accent.sinceBeats < 0.01 then
				return
			end
			if accent.count > 0 and accent.sinceBeats < 0.33 then
				TEvoke_drawLogo(60, true)
			end
		end,
	},
	{
		trigger = SeqTriggerOnSideChannel("introAccent", 5),
		tick = function()
			TEvoke_drawLogo(60, false)
		end,
	},
	{
		trigger = SeqTriggerOnSideChannel("melody", 1),
		tick = function(_, _, sequenceTime)
			local y = 60 + math.sin(sequenceTime.demoMillis / 300) * 8
			TEvoke_drawLogo(y, false)
		end,
	},
}

TEvoke_ships = {
	{
		30, -- x
		136, -- y
		60, -- speed
		"TEvoke_Ship_01", -- sprite
		{
			{ 9, 27, 3 }, -- streak offset x, offset y, width
		},
	},
	{
		10, -- x
		236, -- y
		50, -- speed
		"TEvoke_Ship_04", -- sprite
		{
			{ 1, 22, 2 }, -- streak offset x, offset y, width
			{ 8, 22, 2 },
		},
	},
	{
		160, -- x
		136, -- y
		40, -- speed
		"TEvoke_Ship_02", -- sprite
		{
			{ 3, 16, 2 }, -- streak offset x, offset y, width
			{ 6, 16, 2 },
		},
	},
	{
		210, -- x
		166, -- y
		60, -- speed
		"TEvoke_Ship_03", -- sprite
		{
			{ 5, 27, 2 }, -- streak offset x, offset y, width
			{ 10, 27, 2 },
		},
	},
}

TEvoke_shipSequenceDef = {
	{
		tick = function(_, somaticState)
			local result = QuerySideChannelPart(somaticState, "melody", 1)
			if result.hasHit then
				for _, ship in ipairs(TEvoke_ships) do
					local x, y, speed, sprite = ship[1], ship[2], ship[3], ship[4]
					local newY = y - result.sinceMillis // speed
					drawSprite(sprite, x, newY)
					for _, streak in ipairs(ship[5]) do
						rect(x + streak[1], newY + streak[2], streak[3], 170 - newY, 10)
					end
				end
			end
		end,
	}
}

TEvoke_titleLogoSequenceDef = {
	{
		tick = function(_, somaticState)
			local logX = 5
			local logY = 10
			-- fade in title. fade linear for 2 beats before "melody" first occurrence.
			local fadeBeats = 1
			local melEvent = QuerySideChannelPart(somaticState, "melody", 1)
			local t01 = 0
			if melEvent.sinceBeats then
				t01 = clamp01(1 + melEvent.sinceBeats / fadeBeats)
			end
			drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_02",logX+189,logY-4, t01)
			drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_03",logX+168,logY+27, t01)
			drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_04",logX+0,logY+10, t01)
			drawSpriteDitheredWithBackground("TEvoke_SpaceAirline_01",logX+30,logY+20, t01)
		end
	},
	{
		trigger = SeqTriggerOnSideChannel("melody", 1),
		tick = function(_, somaticState)
			local logX = 5
			local logY = 10

			drawSprite("TEvoke_SpaceAirline_02",logX+189,logY-4)
			drawSprite("TEvoke_SpaceAirline_03",logX+168,logY+27)
			drawSprite("TEvoke_SpaceAirline_04",logX+0,logY+10)
			drawSprite("TEvoke_SpaceAirline_01",logX+30,logY+20)
		end,
	},
}

function TEvoke_init()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
	TEvoke_logoSequencer = CreateSequencer(TEvoke_logoSequenceDef)
	TEvoke_shipSequencer = CreateSequencer(TEvoke_shipSequenceDef)
	TEvoke_titleLogoSequencer = CreateSequencer(TEvoke_titleLogoSequenceDef)
end

function TEvoke(tt, _, somaticState, sceneTime)
	local t = sceneTime.demoMillis
	math.randomseed(t)

	cls()
	
	drawSprite("TEvoke_bg",0,0)

	UpdateSequencer(TEvoke_shipSequencer, somaticState, sceneTime)

	UpdateSequencer(TEvoke_titleLogoSequencer, somaticState, sceneTime)

	-- local logX = 5
	-- local logY = 10

	-- drawSprite("TEvoke_SpaceAirline_02",logX+189,logY-4)
	-- drawSprite("TEvoke_SpaceAirline_03",logX+168,logY+27)
	-- drawSprite("TEvoke_SpaceAirline_04",logX+0,logY+10)
	-- drawSprite("TEvoke_SpaceAirline_01",logX+30,logY+20)

	UpdateSequencer(TEvoke_logoSequencer, somaticState, sceneTime)
end
