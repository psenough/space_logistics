--[[
local pivots={{47,81},{59,40},{87,2},{80,4},{129,103},{124,107},{94,80},{47,89}}
local selection=-1 -- pivot selected (-1 = none, otherwise Lua 1-based index)
local mbt=0        -- mouse button time
local imx,imy=-1,-1 -- store initial mouse position


function drawBezierCurves(t)

	local mx,my,mb=mouse()

	if mb then
		mbt=mbt+1
	else
		mbt=0
		selection=-1 -- reset selection
	end

	-- first click
	if mbt==1 then
		imx=mx
		imy=my

		-- find the selected pivot (first case)
		selection=-1
		for i,p in ipairs(pivots) do
			if math.sqrt((p[1]-mx)^2+(p[2]-my)^2)<=7 then
				selection=i
				break
			end
		end
	else
		local distToInitial=math.sqrt((imx-mx)^2+(imy-my)^2)
		if distToInitial<2 and mbt==30 then
			-- if there is a pivot selected, destroy it; otherwise, create a new one.
			if selection==-1 then
				if mx>=0 and my>=0 and mx<=239 and my<=135 then
					table.insert(pivots,{mx,my})
					selection=#pivots
				end
			elseif #pivots>1 then
				table.remove(pivots,selection)
				selection=-1
			end
		end
	end

	-- move the selected pivot
	if selection>-1 then
		local omx=math.min(math.max(mx,0),239)
		local omy=math.min(math.max(my,0),135)
		pivots[selection][1]=omx
		pivots[selection][2]=omy
	end

	--cls(0)

	-- draw the connections between each pivot
	for i=2,#pivots do
		line(pivots[i][1],pivots[i][2],pivots[i-1][1],pivots[i-1][2],14)
	end

	local ttt=time()/20%quality//1
	--print(ttt)

	-- draw the curve (terrible)
	local pre = pBezier(pivots,0)
	for i=1,quality do
		local t=i/quality
		local p=pre
		local q=pBezier(pivots,t)
		--linew(p[1],p[2],q[1],q[2],1,.5)
		if i<ttt then line(p[1],p[2],q[1],q[2],9) end
		if i==ttt then line(p[1],p[2],q[1],q[2],11) end
		pre=q
	end

	local dump="pivots={"

	-- draw the pivots
	for i,b in ipairs(pivots) do
		circb(b[1],b[2],7,15)
		dump=dump.."{"..b[1]..","..b[2].."},"
	end
	dump=dump.."}"
	
	-- press space to get a dump of the current changes in pivots
	if keyp(48) then
		trace(dump)
	end		

end
--]]
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

C1_Weld = {
	{"C1_Welding_01",10,57},
	{"C1_Welding_02",10,34},
	{"C1_Welding_03",14,7},
	{"C1_Welding_04",22,6},
	{"C1_Welding_05",33,6},
	{"C1_Welding_06",45,6},
	{"C1_Welding_07",58,33},
	{"C1_Welding_08",22,61}
}

function C01_Weld(x,y,t)
	local id = t//30%7+1
	drawSprite(C1_Weld[id][1], x+C1_Weld[id][2], y+C1_Weld[id][3])
end

C01_piv={{47,81},{59,40},{87,2},{80,4},{129,103},{124,107},{94,80},{47,89}}
C01_sparks = {}
C01_coords = {}

function C01_RandSparks()
	--math.randomseed(time())
	local piv = C01_piv
	for i=1,150 do
		local p = pBezier(piv,math.random())
		C01_sparks[i] = p
	end
	C01_coords = pBezier(piv,0)
end

C01_st=0

function Construction01_init()
	C01_RandSparks()
	C01_st = time()
end

function Construction01(tt)

	local t = (tt - C01_st)
	math.randomseed(t)

	cls()
	
	local sx = t/30
	if sx > 57 then sx = 57 end

	RotoSprite("C1_Triangle",37,22-57+sx,(57-sx)/15)	

	if sx < 57 then
		drawSprite("C1_Door_02",31-sx,14) -- left
		drawSprite("C1_Door_01",79+sx,11) -- right
	end

	local wstart = 1800
	local wend = 6400

	local piv = C01_piv
	local p = C01_coords
	
	if t > wstart and t < wend then
		C01_Weld(37,22,t)

		local st=wstart
		
		local tt=((t-wstart)/(wend-wstart))*8
		p = pBezier(piv,tt%1)
	
		-- sparks
		for i=1,12 do
			local rn = math.random(1,150)
			drawSprite("C1_Sparks_"..string.format("%02d", math.random(1,4)), C01_sparks[rn][1], C01_sparks[rn][2])
		end
	end

	drawSprite("C1_Bg",0,0)

	drawSprite("C1_Machine_03",p[1]+60,p[2]+10)
	drawSprite("C1_Machine_01",p[1]+2,p[2])
	drawSprite("C1_Machine_02",p[1]+20,p[2])

end
