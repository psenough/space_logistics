
Tunnel2_st=0

function Tunnel2_init()
	Tunnel2_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	math.randomseed(Tunnel2_st)

	local num_stars = 250
	for i = 1, num_stars do
		table.insert(Tunnel2_stars, {
			x = math.random(-120, 120),
			y = math.random(-68, 68),
			z = math.random(-100, 0)
		})
	end
end

Tunnel2_stars = {}

function Tunnel2(tt)

	local t = (tt - Tunnel2_st)
	math.randomseed(t)

	cls()

	--math.randomseed(404)
	local cx = 60 -- off center a bit
	local cy = 68
	for _, s in ipairs(Tunnel2_stars) do
        -- Move star closer
        s.z = s.z - 1.5
        if s.z <= -100 then
            s.z = 0
            s.x = math.random(-120, 120)
            s.y = math.random(-68, 68)
        end
        
        -- Project 3D to 2D
        local k = 64 / s.z
        local px = cx + s.x * k
        local py = cy + s.y * k
        
        -- Previous position for streak line length
        local k_old = 64 / (s.z + 3)
        local ox = cx + s.x * k_old
        local oy = cy + s.y * k_old
        
        -- Draw if inside screen bounds
        if ox >= 0 and ox < 240 and oy >= 0 and oy < 136 then
            line(ox, oy, px, py, 12) -- color 12 is light blue/white
        end
    end

	local shipPosX = 10
	local shipPosY = 20

	drawSprite("Tunnel2_Engine",shipPosX+10,shipPosY)
	drawSprite("Tunnel2_Engine",shipPosX+60,shipPosY)

	drawSprite("Tunnel2_Ship",shipPosX,shipPosY+20)

end
