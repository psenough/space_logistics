-- todo: maybe bias away from center of screen; bias away from previous.

do
	local gTwinkleParticles = nil
	local gTwinkleRng = nil
	local gScheduledTwinkles = {}

	function TwinkleNewScene(sceneNumber)
		gTwinkleParticles = CreateParticlePool(50)
		gTwinkleRng = CreateRng(1 + sceneNumber)
		gScheduledTwinkles = {}
	end

	TwinkleNewScene(0)

	local gTwinkleGradient1 = { 15, 14, 13, 12 } -- white
	local gTwinkleGradient2 = { 1, 2, 3, 4 } -- red-yellow

	-- sub-twinkles get different, darker color.
	local gSubTwinkleGradient1 = { 15, 15, 14, 13 } -- white
	local gSubTwinkleGradient2 = { 1, 1, 2, 3 } -- red-yellow

	-- generates x,y screen coords whose distribution is biased away from the center of the screen
	function GetRandomCoordInSpanBiasedAwayFromCenter(min, max)
		local span = max - min
		--local centerBias = 0.5 -- 0.5 = no bias; 1.0 = full bias away from center.
		local r = RngNext(gTwinkleRng) - 0.5 -- -0.5 to 0.5 such that 0 is center.
		local sign = r < 0 and -1 or 1
		local rAbs = math.abs(r)
		local rAbsBiased = math.sqrt(rAbs) -- inflates the curve; higher values favored = towards edge.
		local center = (min + max) / 2
		return center + sign * rAbsBiased * (span / 2)
	end
	function GetRandomScreenPosition()
		local x = GetRandomCoordInSpanBiasedAwayFromCenter(0, TIC_WIDTH())
		local y = GetRandomCoordInSpanBiasedAwayFromCenter(0, TIC_HEIGHT())
		return x, y
	end

	-- get random position within a donut-shaped region around x,y
	function GetSubTwinklePosition(x, y)
		local rInside = 0
		local rOutside = 10
		local r = lerpScalar(rInside, rOutside, RngNext(gTwinkleRng)  ^ 2) -- bias towards inside of donut.
		local angle = RngNext(gTwinkleRng, 0, 6.28)
		return x + math.cos(angle) * r, y + math.sin(angle) * r
	end

	function AddTwinkle()
		for i = 1,1 do
			local x,y = GetRandomScreenPosition()
			local gradientRand = RngNext(gTwinkleRng)
			local particle = {
				x = x,
				y = y,
				dx = 0,
				dy = 0,
				life = 85,
				-- custom
				gradient = gradientRand > 0.5 and gTwinkleGradient1 or gTwinkleGradient2,
				strength = 1,
			}
			AddParticleToPool(gTwinkleParticles, particle)

			-- schedule a couple more twinkles in future ticks.
			local subtwinkleCount = 20
			for j = 1, subtwinkleCount do
				local normj = 1 - (j / subtwinkleCount)
				local subX,subY = GetSubTwinklePosition(x, y)
				local subParticle = {
					x = subX,
					y = subY,
					dx = 0,
					dy = 0,
					life = 33,-- lerpScalar(25, 50, normj),
					-- custom
					gradient = gradientRand > 0.5 and gSubTwinkleGradient1 or gSubTwinkleGradient2,
					strength = 0.2,--0.25 * normj, -- fade out the sub-twinkles a bit more.
				}

				local delayMillis = 40 * j

				gScheduledTwinkles[#gScheduledTwinkles + 1] = {
					millisRemaining = delayMillis,
					particle = subParticle
				}
			end
		end
	end

	function TwinkleRowHandler(state)
		if state.sideChannel == "twinkle1" then
			AddTwinkle()
		end
		if state.sideChannel == "twinkle2" then
			AddTwinkle()
		end
	end

	function TwinkleTick(state)
		-- hit t to manually add twinkle.
		--#ifdef DEBUG
		if keyp(20) then -- T
			AddTwinkle()
		end
		--#endif

		-- realize any scheduled twinkles.
		for i = #gScheduledTwinkles, 1, -1 do
			local scheduled = gScheduledTwinkles[i]
			scheduled.millisRemaining = scheduled.millisRemaining - state.wallDeltaMillis
			if scheduled.millisRemaining <= 0 then
				AddParticleToPool(gTwinkleParticles, scheduled.particle)
				table.remove(gScheduledTwinkles, i)
			end
		end

		UpdateParticlePool(gTwinkleParticles)

		for i = 1, #gTwinkleParticles.particles do
			local p = gTwinkleParticles.particles[i]
			local life01 = 1 - (p.age / p.life)
			life01 = clamp01(life01 * life01) -- better fadeout curve.
			local selectedGradIndex = SelectNorm(p.gradient, life01) // 1
			local color = p.gradient[selectedGradIndex]
			local darkerColor = math.max(color - 1, 0)

			local size = 7 * life01 * p.strength

			hlineBayer(p.x - size, p.x + 1 + size, p.y, p.gradient, #p.gradient, life01)
			vlineBayer(p.x, p.y - size, p.y + 1 + size, p.gradient, #p.gradient, life01)
		end
	end
end
