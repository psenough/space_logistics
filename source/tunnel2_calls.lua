
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
        -- update
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
        
        -- Previous position, for streak line length
        local k_old = 64 / (s.z + 3)
        local ox = cx + s.x * k_old
        local oy = cy + s.y * k_old
        
        if ox >= 0 and ox < 240 and oy >= 0 and oy < 136 then
            line(ox, oy, px, py, 12)
        end
    end

	local shipPosX = 10+math.sin(t/250)*2*math.sin(t/530)
	local shipPosY = 20+math.sin(t/6000+math.sin(t/100)*2*math.sin(t/1000))*2

	drawSprite("Tunnel2_Engine",shipPosX+20+math.sin(t/20)*.2,shipPosY+12+math.sin(t/200)*.5)
	drawSprite("Tunnel2_Engine",shipPosX+74+math.sin(t/18)*.2,shipPosY+12+math.sin(t/201)*.5)

	drawSprite("Tunnel2_Ship",shipPosX,shipPosY+20)
	

	local paddings = {1,2,2,5,5,5,3,8,7,5}
	local shine_id = t//30%10+1
	local spr_id = "Tunnel2_Shine_"..string.format("%02d", shine_id)
	local w=sprites[spr_id].w
	local h=sprites[spr_id].h
	local tw=197
	local th=65
	local ox=shipPosX+paddings[shine_id]
	local oy=shipPosY+20
	drawSprite(spr_id,ox,oy)


end
