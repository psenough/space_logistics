
-- drawing controllable pivots, borrowed code from elias
--[[local pivots={{136,77},{68,99},{230,104},{224,2}}
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

F06_st = 0

function Frame06_init()
	F06_st = time()
	cls(3)
	drawSprite("F6_BG_Ditter",0,0)
	drawSprite("F6_Ship",0,0)
end

function Frame06(tt)
	--cls(3)
	--drawSprite("F6_BG_Ditter",0,0)
	--drawSprite("F6_Ship",0,0)
	--drawBezierCurves(tt - F06_st)

	local curves = {
		{ st = 400, pivots={{129,73},{190,109},{127,120},{250,13}}},
		{ st = 100, pivots={{127,74},{214,114},{190,82},{49,156}}},
		{ st = 1200, pivots={{127,74},{179,111},{249,133}}},
		{ st = 2400, pivots={{127,74},{173,100},{121,111},{250,16}}},
		{ st = 3000, pivots={{128,73},{152,122},{186,85},{-10,146}}},
		{ st = 3500, pivots={{131,72},{192,115},{140,124},{250,45}}},
		{ st = 3600, pivots={{129,73},{161,112},{117,100},{250,24}}}
	}
	
	local t = tt - F06_st
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
				if i<tt then line(p[1],p[2],q[1],q[2],2) end
				if i==tt then
					line(p[1],p[2],q[1],q[2],4)
					--circ(p[1],p[2],2,12)
				end
				pre=q
			end
		end
	end
end
