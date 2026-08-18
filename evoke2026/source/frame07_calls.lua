
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

	local paths = {
		{ st = 0, endt = 1000, pivots={{137,86,30},{127,90,20},{240,90,5}}},
		{ st = 0, endt = 1000, pivots={{139,86,30},{129,90,20},{0,90,5}}},
		{ st = 0, endt = 1000, pivots={{141,86,30},{131,92,20},{240,92,5}}},

		{ st = 400, endt = 1400, pivots={{137,86,30},{127,90,20},{165,90,5},{187,53,5},{187,20,5},{165,0,5}}},
		{ st = 400, endt = 1400, pivots={{139,86,30},{129,90,20},{90,90,5},{70,53,5},{70,33,5},{70,0,5}}},
		{ st = 400, endt = 1400, pivots={{141,86,30},{131,92,20},{240,92,5}}}, 

		{ st = 800, endt = 2000, pivots={{137,86,30},{127,90,20},{240,90,5}}},
		{ st = 800, endt = 2000, pivots={{139,86,30},{129,90,20},{0,90,5}}},
		{ st = 800, endt = 2000, pivots={{141,86,30},{131,92,20},{240,92,5}}}, 

		{ st = 1200, endt = 2400, pivots={{137,86,30},{127,90,20},{127,100,5},{240,100,5}}},
		{ st = 1200, endt = 2400, pivots={{139,86,30},{129,90,20},{129,100,5},{116,136,5}}},
		{ st = 1200, endt = 2400, pivots={{141,86,30},{131,92,20},{131,100,5},{0,100,5}}}, 



		--[[{ st = 0, endt = 2200, pivots={{130,73,30},{140,86,20},{159,103,10},{240,54,0}}},
		{ st = 0, endt = 2200, pivots={{129,73,30},{139,86,20},{158,103,10},{201,136,0}}},
		{ st = 0, endt = 2200, pivots={{128,73,30},{138,86,20},{157,103,10},{78,136,0}}},

		{ st = 1200, endt = 3600, pivots={{131,73,30},{141,86,20},{160,103,5},{160,123,5},{160,136,0}}},
		{ st = 1200, endt = 3600, pivots={{129,73,30},{139,86,20},{158,103,5},{158,123,5},{128,136,0}}},
		{ st = 1200, endt = 3600, pivots={{127,73,30},{137,86,20},{156,103,5},{156,123,5},{156,136,0}}},

		{ st = 2200, endt = 3600, pivots={{131,73,30},{141,86,20},{160,103,5},{180,103,5},{240,103,0}}},
		{ st = 2200, endt = 3600, pivots={{129,73,30},{139,86,20},{158,105,5},{178,105,5},{240,105,0}}},
		{ st = 2200, endt = 3600, pivots={{127,73,30},{137,86,20},{156,103,5},{176,103,5},{240,136,0}}},

		{ st = 3600, endt = 5200, pivots={{130,73,30},{140,86,20},{159,103,10},{240,54,0}}},
		{ st = 3600, endt = 5200, pivots={{129,73,30},{139,86,20},{158,103,10},{213,136,0}}},
		{ st = 3600, endt = 5200, pivots={{128,73,30},{138,86,20},{157,103,10},{78,136,0}}},
--]]
	}

	local linegrad = {12,11,12,10,10,10,10,10,10,10}  
	
	for p=1,#paths do
		local linestart = paths[p].st
		local lineend = paths[p].endt
		local linepath = paths[p].pivots
		if t > linestart and t < lineend+1000 then
			
			local st = lineend - linestart
			local pt = t - linestart
			local steps = 0
			for i=1,#linepath-1 do
				steps = steps + linepath[i][3]
			end
			
			local cstep = (pt/st)*steps//1
			
			local count = 1
			local lastx = linepath[1][1]
			local lasty = linepath[1][2]
			
			for i=1,#linepath-1 do
				local refx = (linepath[i+1][1]-linepath[i][1])/linepath[i][3]
				local refy = (linepath[i+1][2]-linepath[i][2])/linepath[i][3]
				for s=1,linepath[i][3] do
					local px = linepath[i][1]+refx*s
					local py = linepath[i][2]+refy*s
					local c = (cstep-count)//1 
					if c > 1 and c < #linegrad then
						line(lastx,lasty,px,py,linegrad[c])
					end
					count = count + 1
					lastx = px
					lasty = py
				end
			end
		end
	end


	--drawBezierCurves(t)

	--line(40,107,78,107,math.random(10,11))
	--line(84,107,88,107,math.random(10,11))
	--line(92,107,95,107,math.random(10,11))

	--line(150,42,172,42,math.random(10,11))
	--line(178,42,182,42,math.random(10,11))
--[[
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
--]]

	local shipY = 110+math.sin(t/2300)*1.5
	drawSprite("F7_Ship_02",200-t/50,shipY)
	UpdateParticlePool(F7_SmallShipParticles)
	F7_AddTrailParticle(230-t/50,shipY+7)
	F7_RenderParticles(230-t/50,shipY+7)

end
