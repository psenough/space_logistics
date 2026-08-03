

function lerp(a,b,t)
	return {
		(1-t)*a[1]+t*b[1],
		(1-t)*a[2]+t*b[2]
	}
end

function pBezier(a,t)
	while #a>1 do
		local b={}
		for i=1,#a-1 do
			b[#b+1]=lerp(a[i],a[i+1],t)
		end
		a=b
	end
	return a[1]
end

--[[ drawing controllable pivots, borrowed code from elias
local pivots={{136,77},{68,99},{230,104},{224,2}}
local selection=-1 -- pivot selected (-1 = none, otherwise Lua 1-based index)
local mbt=0        -- mouse button time
local imx,imy=-1,-1 -- store initial mouse position
--]]

local curves = {
	{ st = 400, pivots={{136,77},{68,99},{230,104},{224,2}}},
	{ st = 1000, pivots={{136,77},{74,74},{19,26},{8,0}}},
	{ st = 1200, pivots={{137,78},{68,99},{0,100},{79,240}}},
	{ st = 2400, pivots={{136,77},{77,119},{191,103},{239,135}}},
	{ st = 3000, pivots={{134,76},{54,97},{131,126},{239,59}}},
	{ st = 3500, pivots={{136,77},{26,95},{20,26},{165,0}}}
}


local curves_b = {
	{ st = 0, pivots={{77,109},{29,119},{136,77},{68,99},{230,104},{224,2}}},
	{ st = 600, pivots={{77,109},{29,119},{136,77},{74,74},{19,26},{8,0}}},
	{ st = 1000, pivots={{77,109},{137,78},{68,99},{191,0}}},
	{ st = 2400, pivots={{77,109},{136,77},{77,119},{191,103},{239,135}}},
	{ st = 2600, pivots={{77,109},{29,119},{134,76},{54,97},{131,126},{239,59}}},
	{ st = 3500, pivots={{77,109},{29,119},{136,77},{26,95},{20,26},{165,0}}}
}

local quality = 100   -- curve quality

function drawBezierCurves(t)
--[[
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
--]]		
	

end

F05_st = 0

function Frame05_init()
	F05_st = time()
	cls()

	math.randomseed(1)
	stars(1000)
	
	--drawSprite("F5_PlanetBG",240-59,136-41)
	drawSprite("F5_PlanetBG_02",20,20)

	--drawSprite("F5_Ship02",60,100)
	drawSprite("F5_Ship01",100,40)
end

function Frame05(tt)
	--Frame05_init()
	local t = tt - F05_st
	for c=1,#curves do
		local st=curves[c].st
		local piv=curves[c].pivots
		local tt=(t-st)/30//1
		if t > st and t < (st + 3000) then
			local pre = pBezier(piv,0)
			for i=1,quality do
				local t=i/quality
				local p=pre
				local q=pBezier(piv,t)
				if i<tt then line(p[1],p[2],q[1],q[2],9) end
				if i==tt then
					line(p[1],p[2],q[1],q[2],11)
					--circ(p[1],p[2],2,12)
				end
				pre=q
			end
		end
	end
end


function Frame05b_init()
	F05_st = time()
	cls()

	math.randomseed(18)
	stars(1000)
	
	drawSprite("F5_PlanetBG",240-59,136-41)
	--drawSprite("F5_PlanetBG_02",20,20)

	drawSprite("F5_Ship02",60,100)
	--drawSprite("F5_Ship01",100,40)
end

function Frame05b(tt)
	--Frame05_init()
	local t = tt - F05_st
	for c=1,#curves_b do
		local st=curves_b[c].st
		local piv=curves_b[c].pivots
		local tt=(t-st)/30//1
		if t > st and t < (st + 3000) then
			local pre = pBezier(piv,0)
			for i=1,quality do
				local t=i/quality
				local p=pre
				local q=pBezier(piv,t)
				if i<tt then line(p[1],p[2],q[1],q[2],9) end
				if i==tt then
					line(p[1],p[2],q[1],q[2],11)
					--circ(p[1],p[2],2,12)
				end
				pre=q
			end
		end
	end
end
