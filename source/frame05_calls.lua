
function stars_noscroll(t)
	for i=0,50 do
		circ(math.random(240),
			 math.random(136),
			 math.random()*1.5,
			 (4+math.random(2)//1*8)*math.abs(math.sin(t/math.random(10000))//1)
			)
	end
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

local quality = 100   -- curve quality
--[[
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
	
F05_st = 0
F05_traces = true
F05_orbits = nil

F05_darkGrayGradient = { 15,15,15, 15, 14 } -- grayscale (+12 bright white)
F05_grayGradient = { 0,15,15, 15, 14, 13 } -- grayscale (+12 bright white)
F05_redYellowGradient = { 0, 1, 2, 3, 4 } -- red-yellow
F05_blueGradient = { 8, 8, 8, 8, 9,  9, 10 } -- blue (+11 bright cyan)
F05_greenGradient = { 7,7, 7, 7, 6, 5 } -- green
F05_greenGradientDarker = { 7,7, 7, 7, 6 } -- green

F05_justDarkBlue = { 8 }

function Frame05_initShared(traces, gradients)
	F05_st = time()
	F05_traces = traces or false

	local speed = 0.002
	local orbitRadius = 58

	F05_orbits = CreateParticleOrbitEffect({
		particleCount = 3800,
		orbitRadiusMin = orbitRadius,
		orbitRadiusMax = orbitRadius + 68,
		speedMin = speed * 0.1,
		speedMax = speed,
		gradients = gradients,
		renderRadiusMax = 1,
		biasInclination = 1.45, -- half pi (1.57) = edge-on.
		biasAscendingNode = 0.5,
		biasMix = 0.995,
	})
end

function Frame05_init()
	-- with trails, use more subtle gradient set. 
	Frame05_initShared(true,{ F05_justDarkBlue, F05_justDarkBlue, F05_greenGradientDarker })
end

function Frame05_notraces() -- init
	Frame05_initShared(false, { F05_grayGradient, F05_blueGradient, F05_greenGradient })
end

function Frame05b_initShared(traces)
	F05_st = time()
	F05_traces = traces

	local speed = 0.001-- 0.015
	local orbitRadius = 71

	F05_orbits = CreateParticleOrbitEffect({
		particleCount = 60,
		orbitRadiusMin = orbitRadius,
		orbitRadiusMax = orbitRadius,
		speedMin = speed,
		speedMax = speed * 1.05,
		gradients = { F05_blueGradient, F05_greenGradient },
		biasMix = 0,
	})
end

function Frame05b_init()
	Frame05b_initShared(true)
end

function Frame05b_notraces() -- init.
	Frame05b_initShared(false)
end

function Frame05(tt, demoBeats, somaticState)
	--Frame05_init()
	local t = tt - F05_st

	UpdateParticleOrbitEffect(F05_orbits)

	cls()

	math.randomseed(1)
	stars_noscroll(t+10000)
	
	local planetX = 20-t/9000
	local planetY = 20
	local planetOffsetX, planetOffsetY = 49,49

	RenderParticleOrbitEffect(F05_orbits, planetX + planetOffsetX, planetY + planetOffsetY, false)

	drawSprite("F5_PlanetBG_02",planetX,planetY)

	RenderParticleOrbitEffect(F05_orbits, planetX + planetOffsetX, planetY + planetOffsetY, true)

	drawSprite("F5_Ship01",100+t/3000,40-t/8000)

	if (F05_traces) then
		local curves = {
			{ st = 0, pivots={{136,77},{68,99},{230,104},{224,2}}},
			{ st = 1900, pivots={{136,77},{74,74},{19,26},{8,0}}},
			{ st = 2100, pivots={{137,78},{68,99},{0,100},{79,240}}},
			{ st = 2300, pivots={{136,77},{77,119},{191,103},{239,135}}},
			{ st = 2500, pivots={{134,76},{54,97},{131,126},{239,59}}},
			{ st = 3500, pivots={{136,77},{26,95},{20,26},{165,0}}},
			{ st = 4900, pivots={{136,77},{84,74},{119,26},{108,0}}},
			{ st = 5100, pivots={{137,78},{98,99},{0,100},{179,140}}},
			{ st = 5300, pivots={{136,77},{97,119},{121,103},{9,0}}},
			{ st = 5500, pivots={{134,76},{34,97},{31,26},{23,159}}},
		}

		for c=1,#curves do
			local st=curves[c].st
			local piv=curves[c].pivots
			local tt=(t-st)/30//1
			if t > st and t < (st + 8000) then
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

	TwinkleTick(somaticState, "starz")
end

function Frame05b(tt)
	--Frame05_init()
	local t = tt - F05_st

	UpdateParticleOrbitEffect(F05_orbits)

	cls()

	math.randomseed(18)
	stars_noscroll(t+10000)

	local planetX, planetY = 240-59,136-41
	local planetOffsetX, planetOffsetY = 65-4,69-4

	RenderParticleOrbitEffect(F05_orbits, planetX + planetOffsetX, planetY + planetOffsetY, false)

	drawSprite("F5_PlanetBG",planetX,planetY)
	RenderParticleOrbitEffect(F05_orbits, planetX + planetOffsetX, planetY + planetOffsetY, true)

	drawSprite("F5_Ship02",62-t/8000,100)

	if (F05_traces) then
		local curves_b = {
			{ st = 0, pivots={{77,109},{9,119},{36,77},{68,99},{230,104},{224,-30}}},
			{ st = 600, pivots={{77,109},{9,89},{36,77},{74,74},{19,26},{8,-30}}},
			{ st = 1200, pivots={{77,109},{7,120},{68,99},{191,-30}}},
			{ st = 1800, pivots={{77,109},{2,100},{77,19},{191,103},{259,135}}},
			{ st = 3400, pivots={{77,109},{9,119},{34,76},{54,97},{131,126},{249,59}}},
			{ st = 4000, pivots={{77,109},{9,119},{36,77},{26,95},{20,26},{165,-40}}},
			{ st = 4600, pivots={{77,110},{9,119},{6,97},{68,99},{230,102},{224,140}}},
			{ st = 5200, pivots={{77,110},{2,69},{36,17},{74,174},{219,126}}},
		}


		for c=1,#curves_b do
			local st=curves_b[c].st
			local piv=curves_b[c].pivots
			local tt=(t-st)/30//1
			if t > st and t < (st + 8000) then
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
end
