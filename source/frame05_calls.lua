
function Frame05(t)
	cls()

	local tt=1

	-- dithering

	math.randomseed(1)
	stars(1000)
	
	drawSprite("F5_PlanetBG",240-59,136-41)
	drawSprite("F5_PlanetBG_02",20,20)

	drawSprite("F5_Ship02",60,100)
	drawSprite("F5_Ship01",100,40)

end
