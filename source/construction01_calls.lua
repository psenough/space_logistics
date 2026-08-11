
function RotoSprite(spr_id,posx,posy,a)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local c = sprites[spr_id].data
	local bkg = sprites[spr_id].bg

	local cx = w/2
	local cy = h/2
	local s = 1
	local cas = math.cos(a)*s
	local sis = math.sin(a)*s
	
	for x=0,w-1 do
		local dx=x-cx
		local cdx = cx+cas*dx
		local sdy = cy-sis*dx
		for y=0,h-1 do	
			local dy=y-cy
			local u = (cdx+sis*dy)//1
			local v = (sdy+cas*dy)//1
			local col = c[u+v*w]
			if (col ~= bkg) and (u < w) and (u >= 0) then pix(posx+x,posy+y,col) end
		end
	end
end

C1_Weld = { -- id, padx, pady
	{"C1_Welding_01",10,57},
	{"C1_Welding_02",10,34},
	{"C1_Welding_03",14,7},
	{"C1_Welding_04",22,6},
	{"C1_Welding_05",33,6},
	{"C1_Welding_06",45,6},
	{"C1_Welding_07",58,33},
	{"C1_Welding_08",22,61}
}

function RotoSpriteWeld(spr_id,posx,posy,t)
	local w = sprites[spr_id].w
	local h = sprites[spr_id].h
	local d = sprites[spr_id].data
	local c = {}
	for i = 1, #d do -- do a copy, before drawing welding marks
		c[i] = d[i]
	end
	local bkg = sprites[spr_id].bg

	-- draw welding trails
	local id = t//1%7+1
	local padx = C1_Weld[id][2]
	local pady = C1_Weld[id][3]
	local spr = sprites[C1_Weld[id][1]]
	local sprw = spr.w
	local sprh = spr.h
	local sprd = spr.data
	local sprbg = spr.bg
	local padye = pady+sprh
	local padxe = padx+sprw
	for sy = pady, padye do
		local syw = sy*w
		local spyw = (sy-pady)*sprw
		for sx = padx, padxe do	
			local pc = sprd[(sx-padx)+spyw]
			if pc ~= sprbg then
				c[sx+syw] = pc
			end
		end
	end

	-- rotate
	local cx = w/2
	local cy = h/2
	local s = 1
	local a = t
	local cas = math.cos(a)*s
	local sis = math.sin(a)*s
	for x=0,w-1 do
		local dx=x-cx
		local cdx = cx+cas*dx
		local sdy = cy-sis*dx
		for y=0,h-1 do	
			local dy=y-cy
			local u = (cdx+sis*dy)//1
			local v = (sdy+cas*dy)//1
			local col = c[u+v*w]
			if (col ~= bkg) and (u < w) and (u >= 0) then pix(posx+x,posy+y,col) end
		end
	end
end

--function C01_Weld(x,y,t)
--	local id = t//30%7+1
--	drawSprite(C1_Weld[id][1], x+C1_Weld[id][2], y+C1_Weld[id][3])
--end

C01_st=0

function Construction01_init()
	C01_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

function Construction01(tt)

	local t = (tt - C01_st)
	math.randomseed(t)

	cls()

	local wstart = 2000

	local wx = math.sin(wstart/50+math.sin(wstart/40)*10)*10
	
	if t < wstart then
		local sx = t/30
		if sx > 57 then sx = 57 end

		local rot = (57-sx)/15

		RotoSprite("C1_Triangle",37,22-57+sx,rot)	

		if sx < 57 then
			drawSprite("C1_Door_02",31-sx,14) -- left
			drawSprite("C1_Door_01",79+sx,11) -- right
		end
	else
		RotoSpriteWeld("C1_Triangle",37,22,t/80)
		wx = math.sin(t/50+math.sin(t/40)*10)*10
		local spark_id = "C1_Sparks_"..string.format("%02d", math.random(3)+1)
		drawSprite(spark_id,wx+50+math.random(8),72)
		drawSprite(spark_id,wx+50+math.random(8),75)
	end
	
	drawSprite("C1_Bg",0,0)
		
	drawSprite("C1_Machine_01",wx,75)
	drawSprite("C1_Machine_02",0,65)
	drawSprite("C1_Machine_03",-2,60)

end
