do
	local gTwinkleParticles = nil
	local gTwinkleRng = nil

	function TwinkleNewScene(sceneNumber)
		gTwinkleParticles = CreateParticlePool(50)
		gTwinkleRng = CreateRng(5151 + sceneNumber)
	end

	function clamp01(x)
		if x < 0 then return 0 end
		if x > 1 then return 1 end
		return x
	end

	TwinkleNewScene(0)

	local gTwinkleGradient1 = { 0, 15, 14, 13, 12 } -- white
	local gTwinkleGradient2 = { 0, 1, 2, 3, 4 } -- red-yellow

	function AddTwinkle()
		local particle = {
			x = RngNext(gTwinkleRng, 0, TIC_WIDTH),
			y = RngNext(gTwinkleRng, 0, TIC_HEIGHT),
			dx = 0,
			dy = 0,
			life = 75,
			-- custom
			gradient = RngNext(gTwinkleRng) > 0.5 and gTwinkleGradient1 or gTwinkleGradient2,
		}
		AddParticleToPool(gTwinkleParticles, particle)
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
		if keyp(20) then -- T
			AddTwinkle()
		end

		UpdateParticlePool(gTwinkleParticles)

		for i = 1, #gTwinkleParticles.particles do
			local p = gTwinkleParticles.particles[i]
			local life01 = 1 - (p.age / p.life)
			life01 = clamp01(life01 * life01) -- better fadeout curve.
			local selectedGradIndex = SelectNorm(p.gradient, life01) // 1
			local color = p.gradient[selectedGradIndex]
			trace(string.format("%s", type(p.gradient)))
			local darkerColor = math.max(color - 1, 0)

			local size = 7 * life01

			hlineBayer(p.x - size, p.x + 1 + size, p.y, p.gradient, #p.gradient, life01)
			vlineBayer(p.x, p.y - size, p.y + 1 + size, p.gradient, #p.gradient, life01)
		end
	end
end
