
-- starz vs. lazerz
twinkle_current_type = "starz"
twinkle_lazer_dir_vector = normalizeVec2({ 275, -192})

-- defines the emitter along left edge of screen.
twinkle_lazer_left_edge = {
	x0 = 0,
	y0 = 50, -- don't emit too high or it's just a little corner.
	width = 0,
	height = TIC_HEIGHT() - 1 - 100,
}
-- and bottom edge.
twinkle_lazer_bottom_edge = {
	x0 = 0,
	y0 = TIC_HEIGHT() - 1,
	width = TIC_WIDTH() - 1 - 100, -- don't emit too far right; avoid the corner,
	height = 0,
}


do
	local gTwinkleParticles = nil
	local gTwinkleRng = nil
	local gScheduledTwinkles = {}

	TWINKLE_explicitStarPositions = nil
	TWINKLE_starSequence = 0

	function TwinkleNewScene(sceneNumber)
		gTwinkleParticles = CreateParticlePool(50)
		gTwinkleRng = CreateRng(1 + sceneNumber)
		TWINKLE_explicitStarPositions = nil
		gScheduledTwinkles = {}
		TWINKLE_starSequence = 0
	end

	TwinkleNewScene(0)

	-- set explicit positions for twinkles.
	-- array of vec2 positions.
	function TwinkleSetStarPositions(positions)
		TWINKLE_explicitStarPositions = positions
	end

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
		if TWINKLE_explicitStarPositions then
			local pos = TWINKLE_explicitStarPositions[TWINKLE_starSequence + 1]
			if pos then
				TWINKLE_starSequence = TWINKLE_starSequence + 1
				return pos[1], pos[2]
			end
		end
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

	function GetLazerScreenPosition()
		-- sample lanes perpendicular to the lazer direction,
		-- then map that lane to its entry point on the left or bottom edge of screen
		local leftSpan = twinkle_lazer_dir_vector[1] * twinkle_lazer_left_edge.height
		local bottomSpan = -twinkle_lazer_dir_vector[2] * twinkle_lazer_bottom_edge.width
		local lane = RngNext(gTwinkleRng) * (leftSpan + bottomSpan)
		local position
		if lane < leftSpan then
			position = PointAlongLine(twinkle_lazer_left_edge, lane / leftSpan)
		else
			position = PointAlongLine(twinkle_lazer_bottom_edge, (lane - leftSpan) / bottomSpan)
		end
		return position[1], position[2]
	end

	-- Get a random nearby start position for the rest of the lazer burst.
	function GetSubLazerScreenPosition(x, y)
		return x + RngNext(gTwinkleRng, -10, 10), y + RngNext(gTwinkleRng, -10, 10)
	end

	function AddTwinkle()
		local isStar = twinkle_current_type == "starz"
		for i = 1,1 do
			local x,y = GetLazerScreenPosition()
			if isStar then
				x,y = GetRandomScreenPosition()
			end
			local gradientRand = RngNext(gTwinkleRng)
			local lazerSpeedRand = RngNext(gTwinkleRng)
			local particle = {
				x = x,
				y = y,
				dx = 0, -- required for particle system.
				dy = 0,
				life = isStar and 85 or 9999,
				-- custom
				twinkleType = twinkle_current_type,
				gradient = gradientRand > 0.5 and gTwinkleGradient1 or gTwinkleGradient2,
				strength = 1,

				lazerSpeed = lerpScalar(0.2, 0.3, lazerSpeedRand),
				lazerLength = lerpScalar(20, 40, RngNext(gTwinkleRng)),
			}
			AddParticleToPool(gTwinkleParticles, particle)

			-- schedule a couple more twinkles in future ticks.
			local subtwinkleCount = isStar and 20 or 5
			for j = 1, subtwinkleCount do
				local normj = 1 - (j / subtwinkleCount)
				local subX,subY = GetSubLazerScreenPosition(x, y)
				if isStar then
					subX,subY = GetSubTwinklePosition(x, y)
				end
				local subParticle = {
					x = subX,
					y = subY,
					dx = 0,
					dy = 0,
					life = isStar and 33 or 9999,-- lerpScalar(25, 50, normj),
					-- custom
					twinkleType = twinkle_current_type,
					gradient = gradientRand > 0.5 and gSubTwinkleGradient1 or gSubTwinkleGradient2,
					strength = 0.2,--0.25 * normj, -- fade out the sub-twinkles a bit more.

					lazerSpeed = particle.lazerSpeed * lerpScalar(0.75, 0.99, RngNext(gTwinkleRng)),
					lazerLength = lerpScalar(10, 30, RngNext(gTwinkleRng)),
				}

				local delayMillis = 40 * j

				if twinkle_current_type == "lazerz" then
					delayMillis = 16 * j -- faster for lazerz, since they move across the screen quickly.
				end

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
		if state.sideChannel == "endaccent" then
			AddTwinkle()
		end
	end

	function TwinkleTick(state, twinkleType, additionalRandomSeed)
		twinkle_current_type = twinkleType

		if additionalRandomSeed then
			gTwinkleRng = CreateRng(1 + state.wallMillis + additionalRandomSeed)
		end

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

		-- update lazerz twinkles manually.
		for i = 1, #gTwinkleParticles.particles do
			local p = gTwinkleParticles.particles[i]
			if p.twinkleType == "lazerz" then
				-- update position.
				p.x = p.x + twinkle_lazer_dir_vector[1] * state.wallDeltaMillis * p.lazerSpeed
				p.y = p.y + twinkle_lazer_dir_vector[2] * state.wallDeltaMillis * p.lazerSpeed
			end
		end		

		for i = 1, #gTwinkleParticles.particles do
			local p = gTwinkleParticles.particles[i]
			local life01 = 1 - (p.age / p.life)
			life01 = clamp01(life01 * life01) -- better fadeout curve.
			local selectedGradIndex = SelectNorm(p.gradient, life01) // 1
			local color = p.gradient[selectedGradIndex]
			local darkerColor = math.max(color - 1, 0)

			if p.twinkleType == "lazerz" then
				local length = p.lazerLength
				local startX = p.x - twinkle_lazer_dir_vector[1] * length
				local startY = p.y - twinkle_lazer_dir_vector[2] * length
				--lineBayer(startX, startY, p.x, p.y, p.gradient, sqrt(life01))
				line(startX, startY, p.x, p.y, p.gradient[selectedGradIndex])
			else
				-- starz type.
				local size = 7 * life01 * p.strength
				hlineBayer(p.x - size, p.x + 1 + size, p.y, p.gradient, life01)
				vlineBayer(p.x, p.y - size, p.y + 1 + size, p.gradient, life01)
			end

		end
	end
end
