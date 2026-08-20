--#pragma once
--#include "bootstrap.lua"


G_ClipRectStack = {
	{ x = 0, y = 0, w = TIC_WIDTH(), h = TIC_HEIGHT() }
}

function PushClipRect(x, y, w, h)
	local top = G_ClipRectStack[#G_ClipRectStack]
	assert(top ~= nil, "clip rect stack is empty")
	local newX = max(x, top.x)
	local newY = max(y, top.y)
	local newW = min(x+w, top.x+top.w) - newX
	local newH = min(y+h, top.y+top.h) - newY
	table.insert(G_ClipRectStack, { x = newX, y = newY, w = newW, h = newH })
end

function PopClipRect()
	assert(#G_ClipRectStack > 1, "you popped too many clip rects :(")
	table.remove(G_ClipRectStack)
end

function GetCurrentClipRect()
	return G_ClipRectStack[#G_ClipRectStack]
end


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
	local clipRect = GetCurrentClipRect()
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = y*w
		local screenY = posy+y
		if screenY >= clipRect.y and screenY < clipRect.y + clipRect.h then-- clip to current clip rect.
			local x0 = max(0, ceil(clipRect.x - posx))
			local x1 = min(w, ceil(clipRect.x + clipRect.w - posx))
			for x=x0,x1-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then
					pix(posx+x,screenY,col)
				end
			end
		end
	end
end

function visitSpritePixelsRotated90(spr_id,posx,posy, fn)
	local clipRect = GetCurrentClipRect()
	local w = sprites[spr_id].w // 1
	local h = sprites[spr_id].h // 1
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	posx = posx // 1
	posy = posy // 1
	for y=0,h-1 do
		local srcRow = y*w
		local screenX = posx+(h-y-1)
		if screenX >= clipRect.x and screenX < clipRect.x + clipRect.w then-- clip to current clip rect.
			local x0 = max(0, ceil(clipRect.y - posy))
			local x1 = min(w, ceil(clipRect.y + clipRect.h - posy))
			for x=x0,x1-1 do
				local col = c[x+srcRow]
				if (col ~= bkg) then
					fn(screenX, posy+x, col)
				end
			end
		end
	end
end

-- uses sprite as a mask; fill01 selects a dithered position within the gradient.
function fillSpriteRotated90WithDither(spr_id,posx,posy, gradient, fill01)
	fill01 = clamp01(fill01)
	local gradientCount = #gradient
	local gradientPos = fill01 * (gradientCount - 1)
	local gradientIndex = (gradientPos // 1) + 1
	local gradientColor = gradient[gradientIndex]
	local nextGradientColor = gradient[gradientIndex + 1]
	local blend01 = gradientPos - (gradientIndex - 1)

	visitSpritePixelsRotated90(spr_id,posx,posy, function(x, y, col)
		local pixelColor = gradientColor
		if nextGradientColor ~= nil then
			local bayer = BAYER_MINUS_5[y * TIC_WIDTH() + x]
			if blend01 + bayer >= 0.5 then
				pixelColor = nextGradientColor
			end
		end
		pix(x, y, pixelColor)
	end)
end

function drawSpriteRotated90(spr_id,posx,posy)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	-- todo: clip
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

-- draw a sprite flipped horizontally and vertically, with a shade function.
function drawSpriteFlippedHVWithShadeFn(spr_id,posx,posy,shadeFn)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	for y=0,h-1 do
		local srcRow = (h-y-1)*w
		local screenY = posy+y
		if screenY >= 0 and screenY < TIC_HEIGHT() then-- clip to screen
			local x0 = max(0, ceil(-posx))
			local x1 = min(w, ceil(TIC_WIDTH()-posx))
			for x=x0,x1-1 do
				local srcX = w-x-1
				local col = c[srcX+srcRow]
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

-- fades from black.
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

-- draw a sprite as solid color.
function drawSpriteAsMask(spr_id, posx, posy, color)
	drawSpriteWithShadeFn(spr_id, posx, posy, function(x, y, col)
		return color
	end)
end

-- draw a sprite dithering between existing screen color and foreground color.
-- when t01 = 0, uses existing screen color.
-- when t01 = 1, uses foreground color.
-- in between, bayer dithering
function drawSpriteDitheredWithBackground(spr_id, posx, posy, t01)
	if t01 <= 0.01 then
		return
	end
	if t01 >= 0.99 then
		drawSprite(spr_id, posx, posy)
		return
	end
	drawSpriteWithShadeFn(spr_id, posx, posy, function(x, y, col)
		local bayer = BAYER_MINUS_5[(posy+y) * TIC_WIDTH() + (posx+x)]
		if t01 + bayer < 0.5 then
			return nil
		end
		return col
	end)
end

-- flip both horiz & vert
function drawSpriteDitheredWithBackgroundFlippedHV(spr_id, posx, posy, t01)
	if t01 <= 0.01 then
		return
	end
	-- todo when we have this fn
	-- if t01 >= 0.99 then
	-- 	drawSprite(spr_id, posx, posy)
	-- 	return
	-- end
	drawSpriteFlippedHVWithShadeFn(spr_id, posx, posy, function(x, y, col)
		local bayer = BAYER_MINUS_5[(posy+y) * TIC_WIDTH() + (posx+x)]
		if t01 + bayer < 0.5 then
			return nil
		end
		return col
	end)
end

-- posx/posy place the unrotated top-left; rotation pivots around the sprite center.
-- fn gets (x,y,col); returns nil to skip, or a color to draw.
-- background is always transparent; does not call fn.
function visitSpritePixelsWithRotation(spr_id, posx, posy, a, fn)
	local clipRect = GetCurrentClipRect()
	local w = sprites[spr_id].w // 1
	local h = sprites[spr_id].h // 1
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg
	posx = posx // 1
	posy = posy // 1

	local cx = w/2
	local cy = h/2
	local s = 1
	local cas = math.cos(a)*s
	local sis = math.sin(a)*s
	local halfBoundsW = (math.abs(cas)*w + math.abs(sis)*h)/2
	local halfBoundsH = (math.abs(sis)*w + math.abs(cas)*h)/2
	local x0 = max(ceil(cx-halfBoundsW-0.5), ceil(-posx)) // 1
	local x1 = min(ceil(cx+halfBoundsW-0.5), ceil(TIC_WIDTH()-posx)) // 1
	local y0 = max(ceil(cy-halfBoundsH-0.5), ceil(-posy)) // 1
	local y1 = min(ceil(cy+halfBoundsH-0.5), ceil(TIC_HEIGHT()-posy)) // 1

	for x=x0,x1-1 do
		local dx=x+0.5-cx
		local cdx = cx+cas*dx
		local sdy = cy-sis*dx
		-- skip when out of clip rect.
		if x >= clipRect.x and x < clipRect.x + clipRect.w then
			for y=y0,y1-1 do
				local dy=y+0.5-cy
				local u = (cdx+sis*dy)//1
				local v = (sdy+cas*dy)//1
				if (u >= 0) and (u < w) and (v >= 0) and (v < h) then
					-- clip rect.
					if y >= clipRect.y and y < clipRect.y + clipRect.h then
						local col = c[u+v*w]
						if col ~= bkg then
							local result = fn(x, y, col)
							if result ~= nil then
								pix(posx+x, posy+y, result)
							end
							--pix(posx+x,posy+y,col)
						end
					end
				end
			end
		end
	end
end

function drawSpriteWithRotation(spr_id, posx, posy, a)
	visitSpritePixelsWithRotation(spr_id, posx, posy, a, function(x, y, col)
		return col
	end)
end

function drawSpriteWithRotationAsMask(spr_id, posx, posy, a, color)
	visitSpritePixelsWithRotation(spr_id, posx, posy, a, function(x, y, col)
		return color
	end)
end

-- effectively a combination of drawSpriteWithRotationAsMask,  and fillSpriteRotated90WithDither
function drawSpriteWithRotationAsMaskAndDither(spr_id, posx, posy, gradient, fill01, a)
	fill01 = clamp01(fill01)
	local gradientCount = #gradient
	local gradientPos = fill01 * (gradientCount - 1)
	local gradientIndex = (gradientPos // 1) + 1
	local gradientColor = gradient[gradientIndex]
	local nextGradientColor = gradient[gradientIndex + 1]
	local blend01 = gradientPos - (gradientIndex - 1)
	visitSpritePixelsWithRotation(spr_id, posx, posy, a, function(x, y, col)
		local pixelColor = gradientColor
		if nextGradientColor ~= nil then
			local bayer = BAYER_MINUS_5[y * TIC_WIDTH() + x]
			if blend01 + bayer >= 0.5 then
				pixelColor = nextGradientColor
			end
		end
		return pixelColor
	end)
end
