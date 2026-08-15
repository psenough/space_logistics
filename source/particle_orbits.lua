-- particles orbiting a sprite sphere.
-- render the back pass, then the sprite, then the front pass so the sprite
-- occludes particles passing behind it.
-- not going to reuse the existing particle emitter because it's pretty 2D-focused.

do
	-- options:
	-- {
	--   particleCount = 100, -- number of particles in the orbit effect
	--   orbitRadiusMin = 10,
	--   orbitRadiusMax = 20,
	--   speedMin = 0.01,
	--   speedMax = 0.02,
	--   gradients = {{ }}, -- gradients to select from; each from dark to light. darkest probably won't be used because it's occluded.
	--   biasInclination = 0.0, -- bias the inclination of the orbits towards this value (radians)
	--   biasAscendingNode = 0.0, -- bias the ascending node of the orbits towards this value (radians)
	--   biasMix = 0.99, -- how much to bias the inclination and ascending node towards the bias values (0.0 = no bias, 1.0 = full bias)
	--   renderRadiusMin = 0,
	--   renderRadiusMax = 1.1,
	-- }
	function CreateParticleOrbitEffect(options)
		local fx = {
			particleCount = options.particleCount or 100,
			orbitRadiusMin = options.orbitRadiusMin or 10,
			orbitRadiusMax = options.orbitRadiusMax or 20,
			speedMin = options.speedMin or 0.02,
			speedMax = options.speedMax or 0.02,
			gradients = options.gradients or { { 8, 9, 10, 11 } }, -- blue
			renderRadiusMin = options.renderRadiusMin or 0,
			renderRadiusMax = options.renderRadiusMax or 1.1,
			-- internal state
			particles = {}, -- running particle list.
			backParticles = {}, -- per-frame cache of back/front particles.
			frontParticles = {},
		}

		local biasAmt = options.biasMix or 0.98
		local biasInclination = options.biasInclination or 3.14159/2 -- edge-on
		local biasAscendingNode = options.biasAscendingNode or -0.33 -- tilt

		for i = 1, fx.particleCount do
			local radiusRnd = math.random()
			local radius = lerpScalar(fx.orbitRadiusMin, fx.orbitRadiusMax, radiusRnd)
			local speed = lerpScalar(fx.speedMin, fx.speedMax, math.random())
			local phase = math.random() * 6.28

			-- orbit is defined by 2 angles; make it easy to make uniform distributions.
			-- another way to do this would be to
			local inclination = math.random() * 6.28 -- rotation around X (tilt away from screen)
			local ascendingNode = math.random() * 6.28 -- rotation around Z (effectively screen 2D rotation)
			--ascendingNode = lerpAngular(ascendingNode, biasAscendingNode, biasAmt) -- bias towards 0 so the orbits are more aligned.

			inclination = lerpAngular(inclination, biasInclination, biasAmt) -- bias towards 0 so the orbits are more aligned.
			ascendingNode = lerpAngular(ascendingNode, biasAscendingNode, biasAmt) -- bias towards 0 so the orbits are more aligned.

			local cosInclination = math.cos(inclination)
			local sinInclination = math.sin(inclination)
			local cosNode = math.cos(ascendingNode)
			local sinNode = math.sin(ascendingNode)

			local particle = {
				radius = radius,
				phase = phase,
				speed = speed,
				gradient = fx.gradients[SelectNorm(fx.gradients, radiusRnd)], -- select a gradient based on the radius
				renderRadiusMin = fx.renderRadiusMin,
				renderRadiusMax = fx.renderRadiusMax,

				-- the full transform (orthographic):
				-- x = r * cos(phase) * cos(node) - r * sin(phase) * sin(node) * cos(incl)
				-- y = r * cos(phase) * sin(node) + r * sin(phase) * cos(node) * cos(incl)
				-- z = r * sin(phase) * sin(incl)
				-- https://en.wikipedia.org/wiki/Perifocal_coordinate_system

				-- precompute what we can
				xCos = radius * cosNode,
				xSin = -radius * sinNode * cosInclination,
				yCos = radius * sinNode,
				ySin = radius * cosNode * cosInclination,
				zSin = radius * sinInclination,
			}
			table.insert(fx.particles, particle)
		end

		return fx
	end

	function UpdateParticleOrbitEffect(fx)
		fx.backParticles = {}
		fx.frontParticles = {}
		for _, particle in ipairs(fx.particles) do
			-- advance
			particle.phase = (particle.phase + particle.speed) % 6.28

			local cosPhase = math.cos(particle.phase)
			local sinPhase = math.sin(particle.phase)

			-- calc depth:
			local z = particle.zSin * sinPhase -- z = radius * sin(inclination) * sin(phase); in [-radius, radius]
			local depthNormalized = (z / particle.radius) * 0.5 + 0.5
			local colorIndex = SelectNorm(particle.gradient, depthNormalized)

			particle.renderX = (particle.xCos * cosPhase + particle.xSin * sinPhase) // 1
			particle.renderY = (particle.yCos * cosPhase + particle.ySin * sinPhase) // 1
			particle.renderRadius = lerpScalar(particle.renderRadiusMin, particle.renderRadiusMax, depthNormalized)
			particle.depthNormalized = depthNormalized

			if z < 0 then
				table.insert(fx.backParticles, particle)
			else
				table.insert(fx.frontParticles, particle)
			end
		end
	end

	function RenderParticleOrbitEffect(fx, cx, cy, renderFront)
		-- renderFront=false renders the back pass, renderFront=true renders the front
		cx = cx // 1
		cy = cy // 1
		local particles = renderFront and fx.frontParticles or fx.backParticles
		for i = 1, #particles do
			local particle = particles[i]

			-- bayer would be cool for smoother color transitions but it feels too  flickery / distracting.
			--pixBayer(cx + particle.renderX, cy + particle.renderY, fx.gradient, #fx.gradient, particle.depthNormalized)

			local palIndex = SelectNorm(particle.gradient, particle.depthNormalized)
			--pix(cx + particle.renderX, cy + particle.renderY, particle.gradient[palIndex])
			circ(cx + particle.renderX, cy + particle.renderY, particle.renderRadius, particle.gradient[palIndex])
			--circ(cx + particle.renderX, cy + particle.renderY, 1.2, particle.gradient[palIndex])
		end
	end
end -- do
