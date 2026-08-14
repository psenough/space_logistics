
SS_st=0

function SphereScenes_init()
	SS_st = time()
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end



function SphereScenes(tt)

	local t = (tt - SS_st)
	math.randomseed(t)

	cls()

	drawSprite("SS_Stage1_Frame01",0,0)


end
