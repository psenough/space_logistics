
TUNNEL_Gradient = {9, 10, 11, 12}
TUNNEL_Gradient_Darker = {8, 9, 10, 11} -- same gradient but 1 shade darker

TUNNEL_TrailParticles = { } -- particle system created in init

TUNNEL_TrailGradient = {
	--2,3,4, -- yellow/red
	--7,6,5, -- green
	3,4,6,5
}
TUNNEL_StructRng = nil

function tunnel_init()
	tunnel_st = time()
	math.randomseed(766)

	-- each ship gets particle emitter
	TUNNEL_TrailParticles = {
		CreateParticlePool(500),
		CreateParticlePool(500),
		CreateParticlePool(500),
		CreateParticlePool(500),
	}
end

function renderStructure(t, sparseBand)
	local y1 = 36--46+math.sin(t/700+10)*20
	local y2 = 100--110+math.sin(t/1000)*20
	local bandWidth = 18
	local maxX = (math.ceil(TIC_WIDTH / bandWidth) + 2) * bandWidth

	local prevx = (-bandWidth-t/20)%maxX
	for x=-bandWidth,maxX,bandWidth do
		local bandFillPx = bandWidth * lerpScalar(0.1, 0.9, RngNext(TUNNEL_StructRng))
		if not sparseBand then
			bandFillPx = bandWidth
		end
		local normColor = RngNext(TUNNEL_StructRng)
		local colIndex = SelectNorm(TUNNEL_Gradient, normColor)
		local col = TUNNEL_Gradient[colIndex]
		local shadowCol = TUNNEL_Gradient_Darker[colIndex]
		local posx = (x-t/20)%maxX-bandWidth
		local seamSizeOnWall = RngNext(TUNNEL_StructRng, 2, 4) // 1 -- keep out of below loop otherwise it messes with rand sequence
		if prevx < posx then
			local x0 = prevx
			local x1 = prevx + bandFillPx
			-- ceiling
			tri(x1,y1,x1*2-120,0,x0*2-120,0,col)
			tri(x0,y1,x1,y1,x0*2-120,0,col)
		
			-- wall
			tri(x1,y1,x1,y2,x0,y1,col)
			tri(x0,y1,x1,y2,x0,y2,col)
			
			-- floor
			tri(x0,y2,x0*2-120,136,x1*2-120,136,col)
			tri(x1,y2,x0,y2,x1*2-120,136,col)

			-- draw kind of ambent occlusion effect on wall.
			-- dynamic height of this effect actually makes no sense but it looks more dynamic than fixed,
			-- probably due to bayer noise.
			for seamRY = 0, seamSizeOnWall do
				local seam01 = 1 - (seamRY / seamSizeOnWall)
				local seamY1 = y1 + seamRY
				hlineBayerShadow(prevx, posx, seamY1, shadowCol, seam01)
				local seamY2 = y2 - seamRY
				hlineBayerShadow(prevx, posx, seamY2, shadowCol, seam01)
			end
		end
		prevx = posx
	end
end

function TUNNEL_AddTrailParticle(shipIndex, x, y)
	local r1, r2, r3 = math.random(), math.random(), math.random()
	if r1 < 0.3 then
		return
	end
	local particle = {
		x = x,
		y = 0,
		dx = lerpScalar(-0.2, -0.6, r2),
		dy = (r3-0.5)*0.05,
		life = 40,
		-- custom props
		lineLength = r2 * 1.4, -- should relate directly to dx. fastest particles = wider
	}
	AddParticleToPool(TUNNEL_TrailParticles[shipIndex], particle)
end

function TUNNEL_RenderParticles(shipIndex, xOffset, yOffset)
	local particles = TUNNEL_TrailParticles[shipIndex].particles
	for i,p in ipairs(particles) do
		local age01 = 1 -(p.age / p.life)
		age01 = age01 * age01 --* age01  -- adjust curve so more energetic particles are sharper curve
		local colIndex = SelectNorm(TUNNEL_TrailGradient, age01)
		--pix(p.x, p.y + yOffset, TUNNEL_TrailGradient[colIndex])

		line(p.x, p.y + yOffset, p.x + p.lineLength, p.y + yOffset, TUNNEL_TrailGradient[colIndex])
		p.prevX = p.x
		p.prevY = p.y
	end
end

function posOrNeg1(x)
	if x < 0 then
		return -1
	end
	return 1
end

TUNNEL_HyperlineRng = nil

function RenderHyperLine(t, x, y)
	local throw = 12
	local nominalLen = 4
	local xoffset = fract(t * 0.008) * throw
	--local xoffset = (sin(t*0.08 + RngNext(TUNNEL_HyperlineRng) * 6.28) * throw) // 1
	--local xoffset = posOrNeg1(math.sin(t*0.04)) * 3 // 1
	local startX = x - xoffset - nominalLen
	line(startX, y, x, y, 14)
	pix(startX - 2, y, 15)
	pix(startX - 4, y, 13)
end

function tunnel(tt)
	local t = tt - tunnel_st

	--t = 9000
	
	cls()
	TUNNEL_HyperlineRng = CreateRng(1337)

	for i=1,#TUNNEL_TrailParticles do
		local p = TUNNEL_TrailParticles[i]
		if p then
			UpdateParticlePool(p)
		end
	end

	--draw tunnel
	TUNNEL_StructRng = CreateRng(1)
	renderStructure(t * 0.8)
	renderStructure(t * 1.6, true)

	--draw ships
	local slx = math.sin(t/1000)*10+t/60-100
	local sly = 30+math.sin(t/800)*6
	RenderHyperLine(t, slx+116, sly+0)
	RenderHyperLine(t, slx+20, sly+5)
	--RenderHyperLine(t, slx+0, sly+22)
	RenderHyperLine(t, slx+1, sly+38)
	RenderHyperLine(t, slx + 110, sly + 76)
	drawSprite("Tunnel_Shiplarge", slx, sly)
	circ(slx+97,sly+54,math.random(2),math.random(3)+3)
	TUNNEL_AddTrailParticle(1, slx+97,sly+54)
	TUNNEL_RenderParticles(1, slx+97, sly+54)

	slx = math.sin(t/2100)*6+t/46-20
	sly = 98+math.sin(t/1800)*4
	--RenderHyperLine(t, slx+0, sly+1)
	RenderHyperLine(t, slx+3, sly+28)
	drawSprite("Tunnel_Shipsmall_01", slx,sly)
	--pix(slx,sly,7) 
	circ(slx+1,sly+16,math.random(2),math.random(3)+3)
	circ(slx+3,sly+19,math.random(1),math.random(3)+3)
	TUNNEL_AddTrailParticle(2, slx+3,sly+19)
	TUNNEL_RenderParticles(2, slx+3, sly+19)

	slx = math.sin(t/2000+10)*6+t/30-80
	sly = 5+math.sin(t/1700+2)*4
	drawSprite("Tunnel_Shipsmall_02",slx,sly)
	line(slx+2,sly+9,slx+6,sly+5,math.random(3)+3)
	TUNNEL_AddTrailParticle(3, slx+6,sly+5)
	TUNNEL_RenderParticles(3, slx+6, sly+5)

	slx = math.sin(t/2100+20)*6+t/58-140
	sly = 94+math.sin(t/1900+4)*5
	TUNNEL_AddTrailParticle(4, slx,sly+12)
	TUNNEL_RenderParticles(4, slx, sly+12)
	drawSprite("Tunnel_Shipsmall_03", slx, sly)

end
