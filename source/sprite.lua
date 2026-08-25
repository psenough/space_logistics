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
			local x0 = max(0, ceil(-posx))
			local x1 = min(w, ceil(TIC_WIDTH()-posx))
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
			local x0 = max(0, ceil(-posx))
			local x1 = min(w, ceil(TIC_WIDTH()-posx))
			for x=x0,x1-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then
					pix(posx+x,screenY,col)
				end
			end
		end
	end
end

function drawSpriteFlipH(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		if screenY >= 0 and screenY < TIC_HEIGHT() then-- clip to screen
			for x=0,w-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then
					pix(posx+(w-x),screenY,col)
				end
			end
		end
	end
end

function drawSpriteRotated90(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	-- todo: screen clip
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
	-- todo: screen clip
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
	-- todo: screen clip
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

function drawSpriteWithShadeFn(spr_id,posx,posy,shadeFn)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		if screenY >= 0 and screenY < TIC_HEIGHT() then-- clip to screen
			local x0 = max(0, ceil(-posx))
			local x1 = min(w, ceil(TIC_WIDTH()-posx))
			for x=x0,x1-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then
					local c = shadeFn(x, y, col)
					if c ~= nil then
						pix(posx+x,screenY,c)
					end
				end
			end
		end
	end
end

-- modulates colors with a provided map. the map is assumed to hold 16 entries one for each palette entry.
-- when t = 0, uses original color.
-- at t = 1, uses mapped color.
-- in between, dithers.
function drawSpriteWithMappedColors(spr_id, posx, posy, colorMap, t)
	t = clamp01(t)
	drawSpriteWithShadeFn(spr_id, posx, posy, function(x, y, col)
		local bayer = BAYER_MINUS_5[(posy+y) * TIC_WIDTH() + (posx+x)]
		if t + bayer >= 0.5 then
			return colorMap[col + 1]
		end
		return col
	end)
end

-- draws a sprite, faded. each palett index maps to its own darkening gradient.
-- for each palette entry, a gradient where 0 = black, 1 = original color.
G_DarkeningGradients = {
 {0,0},-- 0 = black,
 {0,1},-- 1 = dark red.
{0,1,2},-- 2 = red
{0,1,2,3},-- 3 = orange
{0,1,2,3,4},-- 4 = yellow
{0,15,7,6,5},-- 5 = bright green
{0,15,7,6},-- 6 = green
{0,15,7},-- 7 = dark/hunter green
{0,8},-- 8 = dark blue
{0,8,9},-- 9 = blue
{0,8,9,10},-- 10 = light blue
{0,8,9,10,11},-- 11 = cyan
{0,15,14,13,12},-- 12 = white
{0,15,14,13},-- 13 = light gray
{0,15,14},-- 14 = gray
{0,15},-- 15 = dark gray
}

-- function drawSpriteWithFadeIn(spr_id, posx, posy, t)
-- 	t = clamp01(t)
-- 	drawSpriteWithShadeFn(spr_id, posx, posy, function(x, y, col)
-- 		return col
-- 	end)
-- end

function drawSpriteWithFadeIn(spr_id, posx, posy, t)
	t = clamp01(t)
	drawSpriteWithShadeFn(spr_id, posx, posy, function(x, y, col)
		local gradient = G_DarkeningGradients[col + 1]
		local gradientCount = #gradient
		local gradientPos = t * (gradientCount - 1)
		local gradientIndex = (gradientPos // 1) + 1
		local color = gradient[gradientIndex]
		if gradientIndex == gradientCount then
			return color
		end

		local bayer = BAYER_MINUS_5[(posy+y) * TIC_WIDTH() + (posx+x)]
		if gradientPos - (gradientIndex - 1) + bayer >= 0.5 then
			return gradient[gradientIndex + 1]
		end
		return color
	end)
end
