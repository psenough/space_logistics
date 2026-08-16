--#pragma once
--#include "bootstrap.lua"

function drawSprite(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(posx+x,screenY,col) end
		end
	end
end

function drawSpriteRotated90(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenX = posx+(h-y-1)
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(screenX,posy+x,col) end
		end
	end
end

function drawSpriteRotated180(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+(h-y-1)
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(posx+x,screenY,col) end
		end
	end
end

function drawSpriteRotated270(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenX = posx+y
		for x=0,w-1 do
			local col = c[x+srcRow]
			if (col ~= bkg) then pix(screenX,posy+(w-x-1),col) end
		end
	end
end

-- axis-aligned rotation index.
function drawSpriteWithAARotation(spr_id,posx,posy,rotIndex)
	if rotIndex == 0 then
		drawSprite(spr_id,posx,posy)
	elseif rotIndex == 1 then
		drawSpriteRotated90(spr_id,posx,posy)
	elseif rotIndex == 2 then
		drawSpriteRotated180(spr_id,posx,posy)
	elseif rotIndex == 3 then
		drawSpriteRotated270(spr_id,posx,posy)
	end
end
