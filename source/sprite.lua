--#pragma once
--#include "bootstrap.lua"

-- convert a sprite into a map from color to list of pixel locations.
-- useful for largely transparent, fixed-on-screen sprites like HUDs or backgrounds.
function createCachedSprite(spr_id, posx, posy)
	local cache = {}
	-- seed the 16-color empty entries.
	for i=0,15 do
		cache[i] = {}
	end
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local screenY = posy+y
		if screenY >= 0 and screenY < TIC_HEIGHT() then-- clip to screen
			local srcRow = y*w
			local rowBase = screenY * TIC_WIDTH() + posx
			local x0 = max(0, -posx)
			local x1 = min(w, TIC_WIDTH()-posx)

			for x=x0,x1-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then
					--pix(posx+x,screenY,col)
					--table.insert(cache[col], {posx+x, screenY})
					-- even faster: use POKE
					table.insert(cache[col], rowBase+x)
				end
			end
		end
	end
	return cache
end

function drawCachedSprite(cache)
	for col = 0, 15 do
		local pixels = cache[col]
		for _, pixel in ipairs(pixels) do
			poke4(pixel, col)
		end
	end
end

function drawSprite(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		if screenY >= 0 and screenY < TIC_HEIGHT() then-- clip to screen
			local x0 = max(0, -posx)
			local x1 = min(w, TIC_WIDTH()-posx) -- only draw pixels that are on screen
			for x=x0,x1-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then pix(posx+x,screenY,col) end
			end
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
