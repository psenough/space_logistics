
--[[ drawing controllable pivots, borrowed code from elias
local pivots={{133,83},{68,99},{68,120},{230,104},{224,2}}
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

F7_TrailGradient = {
	12,11,10,11
}

function F7_AddTrailParticle(x, y)
	local r1, r2, r3 = math.random(), math.random(), math.random()
	if r1 < 0.3 then
		return
	end
	local particle = {
		x = x,
		y = 0,
		dx = lerpScalar(0.2, 0.6, r2),
		dy = (r3-0.5)*0.05,
		life = 50,
		-- custom props
		lineLength = r2 * 1.4, -- should relate directly to dx. fastest particles = wider
	}
	AddParticleToPool(F7_SmallShipParticles, particle)
end

function F7_RenderParticles(xOffset, yOffset)
	local particles = F7_SmallShipParticles.particles
	for i,p in ipairs(particles) do
		local age01 = 1 -(p.age / p.life)
		age01 = age01 * age01 --* age01  -- adjust curve so more energetic particles are sharper curve
		local colIndex = SelectNorm(F7_TrailGradient, age01)

		line(p.x, p.y + yOffset, p.x + p.lineLength, p.y + yOffset, F7_TrailGradient[colIndex])
		p.prevX = p.x
		p.prevY = p.y
	end
end

function Frame07_init()
	F07_st = time()
	math.randomseed(123)
	F7_SmallShipParticles = CreateParticlePool(500)
end

F7_SmallShipParticles = {}

function Frame07(tt)
	local t = tt - F07_st

	cls()

	math.randomseed(123)
	stars_side(10000+t,t/50,0)
	math.randomseed(t)
	
	drawSprite("F7_Ship_01",240-226,10+math.sin(t/1200)*2)

	--drawBezierCurves(t)

	--line(40,107,78,107,math.random(10,11))
	--line(84,107,88,107,math.random(10,11))
	--line(92,107,95,107,math.random(10,11))

	--line(150,42,172,42,math.random(10,11))
	--line(178,42,182,42,math.random(10,11))

	local curves = {
		--{ st = 0, pivots={{133,83},{68,99},{26,72},{-20,47}}},
		{ st = 0, pivots={{133,83},{22,81},{79,109},{29,11},{13,-20}}},

		{ st = 200, pivots={{141,86},{68,99},{116,132},{269,135}}},
		{ st = 400, pivots={{137,85},{68,99},{174,135},{179,-20}}},
		{ st = 1200, pivots={{141,85},{45,89},{16,22},{16,-20}}},
		{ st = 1400, pivots={{133,83},{68,99},{229,105},{-20,120}}},
		{ st = 2000, pivots={{142,84},{68,99},{239,120},{210,160}}}
	}

	for c=1,#curves do
		local st=curves[c].st
		local piv=curves[c].pivots
		local tt=(t-st)/30//1
		if t > st and t < (st + 10000) then
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

	drawSprite("F7_Ship_02",200-t/50,100)
	UpdateParticlePool(F7_SmallShipParticles)
	F7_AddTrailParticle(230-t/50,107)
	F7_RenderParticles(230-t/50,107)

end
