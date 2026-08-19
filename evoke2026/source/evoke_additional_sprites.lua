--#pragma once

--#include "../gfx/bg.png.lua"
--#include "../gfx/boardingtime.png.lua"
--#include "../gfx/bomb.png.lua"
--#include "../gfx/bomb_overlay.png.lua"
--#include "../gfx/Bowlingball.png.lua"
--#include "../gfx/bownlingball_overlay.png.lua"
--#include "../gfx/canceled.png.lua"
--#include "../gfx/destination.png.lua"
--#include "../gfx/keyboard_end.png.lua"
--#include "../gfx/keyboard_end_overlay.png.lua"
--#include "../gfx/keyboard_middle.png.lua"
--#include "../gfx/keyboard_middle_overlay.png.lua"
--#include "../gfx/keyboard_start.png.lua"
--#include "../gfx/keyboard_start_overlay.png.lua"
--#include "../gfx/logo.png.lua"
--#include "../gfx/textfield.png.lua"
--#include "../gfx/ticketbg.png.lua"

-- example:
-- SPRITE_TICKETBG = {
--     width=240,
--     height=120,
--     id="SPRITE_TICKETBG",
--     data="M907N...A2"
-- }
-- SPRITE_BG
--

function LoadNewSprite(sprite, bgColor)
	loadExtendedSprite(unpac_noheader(sprite.data), sprite.id, sprite.width, sprite.height, bgColor)
end

function loadAdditionalEvokeSprites()
	LoadNewSprite(SPRITE_BG, 0)
	LoadNewSprite(SPRITE_BOARDINGTIME, 0)
	LoadNewSprite(SPRITE_BOMB, 0)
	LoadNewSprite(SPRITE_BOMB_OVERLAY, 0)
	LoadNewSprite(SPRITE_BOWLINGBALL, 0)
	LoadNewSprite(SPRITE_BOWNLINGBALL_OVERLAY, 0)
	LoadNewSprite(SPRITE_CANCELED, 0)
	LoadNewSprite(SPRITE_DESTINATION, 0)
	LoadNewSprite(SPRITE_KEYBOARD_END, 0)
	LoadNewSprite(SPRITE_KEYBOARD_END_OVERLAY, 0)
	LoadNewSprite(SPRITE_KEYBOARD_MIDDLE, 0)
	LoadNewSprite(SPRITE_KEYBOARD_MIDDLE_OVERLAY, 0)
	LoadNewSprite(SPRITE_KEYBOARD_START, 0)
	LoadNewSprite(SPRITE_KEYBOARD_START_OVERLAY, 0)
	LoadNewSprite(SPRITE_LOGO, 0)
	LoadNewSprite(SPRITE_TEXTFIELD, 0)
	LoadNewSprite(SPRITE_TICKETBG, 0)
end
