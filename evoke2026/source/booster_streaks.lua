--#include "bootstrap.lua"

-- animated booster streak effect. acts like yet another particle system.
-- emitter is defined as a line. along the line, booster streaks spawn in fixed direction.
function MaybeSpawnBoosterStreak(b, x, y, t01)
    if random() > b.options.density then
        return nil
    end
	local o = b.options
    local virility01 = random()
	local s = {
		x0 = x,
		y0 = y,
		dx = lerpScalar(o.direction0X, o.direction1X, t01),
		dy = lerpScalar(o.direction0Y, o.direction1Y, t01),
        t01 = t01, -- position along emitter.
		--phase = random() * 6.28,
        lifespanMS = lerpScalar(o.lifespanMSMin, o.lifespanMSMax, virility01),
        ageMS = 0,
        length = 0,
        targetLength = lerpScalar(o.minLength, o.maxLength, virility01),
        energy = bilerpScalar(o.minEnergy0, o.maxEnergy0, o.minEnergy1, o.maxEnergy1, virility01, t01),
        --energy = 0,
		speed = lerpScalar(o.minSpeed, o.maxSpeed, virility01),
	}
    -- normalize the direction vector
    s.dx, s.dy = normalize2D(s.dx, s.dy)
    return s
end

function CreateBoosterStreaks(options)
	options.emitterX0 = options.emitterX0 or 60
	options.emitterY0 = options.emitterY0 or 60
	options.emitterX1 = options.emitterX1 or 80
	options.emitterY1 = options.emitterY1 or 90
	options.direction0X = options.direction0X or -1.5 -- direction vector at emitter start. (not normalized yet)
	options.direction0Y = options.direction0Y or 0.5
    options.direction1X = options.direction1X or -1.5 -- direction vector at emitter end. (not normalized yet)
    options.direction1Y = options.direction1Y or 0.5
	options.density = options.density or 0.07 -- chance of spawn.
    options.minLength = options.minLength or 4
    options.maxLength = options.maxLength or 240
    options.minSpeed = options.minSpeed or 0.05
    options.maxSpeed = options.maxSpeed or 0.2
    options.lifespanMSMin = options.lifespanMSMin or 80 -- min lifespan of streaks in milliseconds.
    options.lifespanMSMax = options.lifespanMSMax or 700 -- max lifespan of streaks in milliseconds.
    --max/min energy interpolation along the emitter line.
    options.minEnergy0 = options.minEnergy0 or 0.4
    options.maxEnergy0 = options.maxEnergy0 or 0.4
    options.minEnergy1 = options.minEnergy1 or 0.8
    options.maxEnergy1 = options.maxEnergy1 or 1.0
    options.gradient = options.gradient or { 15,7,7,6,6,5,5,12,12 } -- color gradient for streaks.

    -- normalize direction vectors
    options.direction0X, options.direction0Y = normalize2D(options.direction0X, options.direction0Y)
    options.direction1X, options.direction1Y = normalize2D(options.direction1X, options.direction1Y)

    -- store a normalized emitter line vector as well
    local emitterDx = options.emitterX1 - options.emitterX0
    local emitterDy = options.emitterY1 - options.emitterY0
    options.emitterDx, options.emitterDy = normalize2D(emitterDx, emitterDy)

	local b = {
		options = options,
		streaks = {},
	}
	return b
end

function UpdateBoosterStreaks(b, dtMS)
    local options = b.options

    -- kinda expensive
	VisitPixelsAlongLine(options.emitterX0, options.emitterY0, options.emitterX1, options.emitterY1, function(x, y, t01)
		local s = MaybeSpawnBoosterStreak(b, x, y, t01)
        if s then
            table.insert(b.streaks, s)
        end
	end)

    for i = #b.streaks, 1, -1 do
        local s = b.streaks[i]
        s.ageMS = s.ageMS + dtMS
        if s.ageMS > s.lifespanMS then
            table.remove(b.streaks, i)
        else
            local speed = s.speed * dtMS
            -- streaks move in 2 phases: first, their length increases until target length, then they move.
            if s.length < s.targetLength then
                s.length = s.length + speed
                if s.length > s.targetLength then
                    s.length = s.targetLength
                end
            else
                s.x0 = s.x0 + s.dx * speed
                s.y0 = s.y0 + s.dy * speed
            end
        end
    end
end

function RenderBoosterStreaks(b, xOffset, yOffset)
	for i = 1, #b.streaks do
		local s = b.streaks[i]
        local life01 = 1 - (s.ageMS / s.lifespanMS)
		local x1 = s.x0 + s.dx * s.length
		local y1 = s.y0 + s.dy * s.length
        local energy = s.energy
        -- curve... age is like dist from teh ship and should fall off sharply.
        life01 = life01 * life01
        local gradPos = sqrt(life01 * energy)
        local gradIndex = SelectNorm(b.options.gradient, gradPos)
        local palIndex = b.options.gradient[gradIndex]
		line(s.x0 + xOffset, s.y0 + yOffset, x1 + xOffset, y1 + yOffset, palIndex)
        if life01 > 0.40 then
            -- draw a second line to make it look thicker.
            line(s.x0 + xOffset + 1, s.y0 + yOffset, x1 + xOffset + 1, y1 + yOffset, palIndex)
        end
        if life01 > 0.80 then
            -- draw a third line to make it look thicker.
            line(s.x0 + xOffset - 1, s.y0 + yOffset, x1 + xOffset - 1, y1 + yOffset, palIndex)
        end
	end
end
