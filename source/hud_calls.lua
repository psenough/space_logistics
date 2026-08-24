

HUD_01_st=0

function rim(x,y,w,q,c)
	for i=0,q do
		local r = w * math.sqrt(1-math.random()*math.random())
		local theta = math.random() * 2 * math.pi
		local px = x + r * math.cos(theta)
		local py = y + r * math.sin(theta)
		pix(px,py,c)
	end
end

function HUD_01_init()
	HUD_01_st = time()
	
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)
end

function HUD_01_Scene(tt)

	local t = (tt - HUD_01_st)
	
	cls()

	for i=1,240 do
	 for j=1,220,10 do
			--rim(j,66,1,1,10-i/4)
			pix(math.random(i),math.random(j),math.random(i))
		end
		--pix(math.random(i),math.random(i),math.random(i))
		rim(100+t/200,65,60-i,40,10-i/4)
		--pix(230-i/4,150-i/4,i/16)
	end
	
	for y=0,136,2 do
		for x=0,240 do
			pix(x,y,pix(x,y)/2)
		end
	end
	
	-- box header left
	local bx = 16
	local by = 48
	local wid = 40
	local hei = 8
	--if (t//120%2 >= 1) then
	--	rect(bx,by,wid,hei,2)
	--end
	--rectb(bx,by,wid,hei,6)

	rect(bx,by+hei+2,wid,hei*4,0)
	rectb(bx,by+hei+2,wid,hei*4,6)
	local prsd = string.sub("crit lvl 4\ninit dyson\ncontainer\nprotocol", 0, t//140)
	print(prsd,bx+3,by+hei+5,6,false,1,true)
	
	-- box bottom right
	--if (t//120%2 >= 1) then
	--	local px = 178
	--	local py = 118
	--	rect(px,py,46,11,2)
	--	rectb(px,py,46,11,6)
		--print(string.format("%.0f",(20000+t)//15),px+20,py+3,2)
	--end

	--drawSprite("HUD_01",0,0)
	drawSprite("HUD_02",0,0)
	drawSprite("HUD_Frame",0,0)

	if (t//120%2 >= 1) then
		print("Flare Alert!",80,7,2)
		--local px = 178
		--local py = 116
		--rect(px,py,46,11,2)
		--rectb(px,py,46,11,6)
		--poke(0x3FF8,2)
	else
		--poke(0x3FF8,0)
	end

	if (t//160%2 >= 1) then
		line(8,122,46,122,2)
		rect(7,123,41,7,2)
		line(8,130,46,130,2)
	else
		line(9,123,44,123,3)
		rect(8,124,39,5,3)
		line(9,129,44,129,3)
	end

end


function HUD_01_Scene_Crit(tt)

	local t = (tt - HUD_01_st)
	
	cls()

	for i=1,240 do
	 for j=1,220,10 do
			--rim(j,66,1,1,10-i/4)
			pix(math.random(i),math.random(j),math.random(i))
		end
		--pix(math.random(i),math.random(i),math.random(i))
		rim(100+t/200,65,60-i,40,10-i/4)
		--pix(230-i/4,150-i/4,i/16)
	end
	
	for y=0,136,2 do
		for x=0,240 do
			pix(x,y,pix(x,y)/2)
		end
	end
	
	-- box header left
	local bx = 16
	local by = 48
	local wid = 40
	local hei = 8

	rect(bx,by+hei+2,wid,hei*4,0)
	rectb(bx,by+hei+2,wid,hei*4,6)
	local prsd = string.sub("crit lvl 5\nemergency\nexe dyson\ncontainer", 0, t//140)
	print(prsd,bx+3,by+hei+5,6,false,1,true)

	drawSprite("HUD_02",0,0)
	drawSprite("HUD_Frame",0,0)

	if (t//120%2 >= 1) then
		print("Ships Assemble!",80,7,2)
	end

	if (t//160%2 >= 1) then
		line(8,122,46,122,2)
		rect(7,123,41,7,2)
		line(8,130,46,130,2)
	else
		line(9,123,44,123,3)
		rect(8,124,39,5,3)
		line(9,129,44,129,3)
	end

end


function HUD_01_Scene_Construction(tt)

	local t = (tt - HUD_01_st)
	
	cls()

	for i=1,240 do
	 for j=1,220,10 do
			--rim(j,66,1,1,10-i/4)
			pix(math.random(i),math.random(j),math.random(i))
		end
		--pix(math.random(i),math.random(i),math.random(i))
		rim(100+t/200,65,60-i,40,10-i/4)
		--pix(230-i/4,150-i/4,i/16)
	end
	
	for y=0,136,2 do
		for x=0,240 do
			pix(x,y,pix(x,y)/2)
		end
	end
	
	-- box header left
	local bx = 16
	local by = 48
	local wid = 40
	local hei = 8

	rect(bx,by+hei+2,wid,hei*4,0)
	rectb(bx,by+hei+2,wid,hei*4,6)
	local prsd = string.sub("crit lvl 6\ninit\ncontainer\nconstruct", 0, t//140)
	print(prsd,bx+3,by+hei+5,6,false,1,true)

	drawSprite("HUD_02",0,0)
	drawSprite("HUD_Frame",0,0)

	if (t//120%2 >= 1) then
		print("Construct Begin",80,7,2)
	end

	if (t//160%2 >= 1) then
		line(8,122,46,122,2)
		rect(7,123,41,7,2)
		line(8,130,46,130,2)
	else
		line(9,123,44,123,3)
		rect(8,124,39,5,3)
		line(9,129,44,129,3)
	end

end


HUD_particleTrails = nil -- bottom logo ones.
HUD_particlesEnabled = true


function HUD_02_init()
	HUD_02_st = time()
	
	vbank(0)
	cls()
	vbank(1)
	cls()
	vbank(0)

	do
		HUD_particleTrails = {}
		local particleCount = 2

		for i=1,particleCount do
			local particleTrail = CreateParticleTrail({
		-- 	-- total hud area:
		-- 	-- areaX = 8,
		-- 	-- areaY = 9,
		-- 	-- areaW = 156,
		-- 	-- areaH = 113,
				areaX = 196,
				areaY = 63,
				areaW = 44,
				areaH = 26,
				seed = i,
				--gradient = Evoke_HUD_particleGradients[((i-1) % #Evoke_HUD_particleGradients) + 1],
				gradient = { 8,7,6,5 },
			})
			table.insert(HUD_particleTrails, particleTrail)
		end
	end

end

function HUD_02_Scene(tt, demoBeats, somaticState, sceneTime)

	local t = (tt - HUD_02_st)
	
	cls()
	drawSprite("HUD2_Background",0,0)

	local greets = {
		{"Spectrox","Agenda","Otomata Labs","TBL","Spectrals","Accession","konsumer"},
		{"TTE","Slipstream","SIMurai","Damage","Forsaken","Marquee Design","Joker"},
		{"Altair","AbCr","Oftenhide","Dreamweb","Rift","BionFX","Elude"},
		{"Rabenauge","Abyss C","Haujobb","K2","Akronyme A", "Stargaze"},
		{"Desire","Nah Kolor","TPOLM","RBBS","Poo-brain","Hornet","Trepaan"}
	}

	local idx = t//2000%#greets+1

	local grt = greets[idx]

	for i=1,#grt do
		local width = print(grt[i],240,0,1)
		local posX = 87 + math.sin(t/2000+(i*6.28)/#grt+idx*10)*40
		local posY = 70 + math.cos(t/2000+(i*6.28)/#grt+idx)*18
		circb(posX-6,posY+4,2,6)
		line(posX-6,posY+6,87,120,6)
		print(grt[i],posX-width*.5,posY-4,6*((t+i*100)//200%2+1))
	end

	-- screen on side
	drawSprite("HUD2_Consoleoverlay",195,60)
	-- todo some techy animation of the dyson

	-- bar on bottom
	barY = 2
	drawSprite("HUD2_Infobar",0,barY)
	--[[if t//200%4 > 1 then
		print("sectors",50,114,6,false,2)
	else
		print("called",50,114,6,false,2) 
	end--]]
	if t//100%4 > 1 then print("coordinating with\nneighbour sectors",50,barY+12,6,false) end


	for i, particleTrail in ipairs(HUD_particleTrails) do
		UpdateParticleTrail(particleTrail, somaticState, sceneTime)
	end

end
