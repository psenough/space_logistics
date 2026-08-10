
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
			if (col ~= bkg) and (u < w) then pix(posx+x,posy+y,col) end
		end
	end
end

C01_st=0

function Construction01_init()
	C01_st = time()
end

function Construction01(tt)

	local t = (tt - C01_st)

	cls()
	
	local sx = t/30
	if sx > 57 then sx = 57 end

	RotoSprite("C1_Triangle",37,22-57+sx,(57-sx)/15)	

	if sx < 57 then
		drawSprite("C1_Door_02",31-sx,14) -- left
		drawSprite("C1_Door_01",79+sx,11) -- right
	end
	
	drawSprite("C1_Bg",0,0)
	

end
