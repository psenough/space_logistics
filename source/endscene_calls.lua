
EndScene_st=0

function EndScene_init()
	EndScene_st = time()
	clsall()

	TwinkleSetStarPositions({
		{ 167,32 },
		{ 18,100 },
		{ 62, 20 },
		{ 152, 60 },
		{ 200, 30 }})

	End_em = 0
	End_ep = 0
	End_el = 0

end

End_em = 0
End_ep = 0
End_el = 0

function EndScene(tt, _, somaticState, sceneTime)

	local t = (tt - EndScene_st)

	vbank(0)
	-- cant use cls() on vbank0 because of rendering optimization
	-- gradually hide the sun
	if t < 1000 then
		RenderSun(65,61, 8, { 12,4,3,2,1,3,4 }, t)
	elseif t < 2000 then
		RenderSun(65,61, 8, { 12,4,3,0,0,0,4 }, t)
	elseif t < 3000 then
		RenderSun(65,61, 8, { 12,4,0,0,3 }, t)
	elseif t < 4000 then
		RenderSun(65,61, 8, { 3,4,0,0,1 }, t)
	elseif t < 5000 then
		RenderSun(65,61, 8, { 3,2,0,0,1 }, t)
	elseif t < 6000 then
		RenderSun(65,61, 8, { 1,2,0,0,1 }, t)
	elseif t < 7000 then
		RenderSun(65,61, 8, { 0,1,0,1 }, t)
	else
		cls()
	end

	vbank(1)
	cls()
	math.randomseed(123)
	stars_side(10000+t,0,0)
	math.randomseed(t)

	local moonX = 9
	local moonY = 10
	drawSprite("End_Moon",moonX,moonY)
	if t > 7000 then 

		-- twilight anim
		local posX = 65
		local posY = 61

		local paths = {
			{ st = 7000, endt = 7300, pivots={{5,5,4},{0,0,0}}},
			{ st = 7000, endt = 7300, pivots={{-5,-5,4},{0,0,0}}},
			{ st = 7000, endt = 7300, pivots={{5,-5,4},{0,0,0}}},
			{ st = 7000, endt = 7300, pivots={{-5,5,4},{0,0,0}}},
		
			{ st = 7000, endt = 7400, pivots={{12,0,6},{0,0,0}}},
			{ st = 7000, endt = 7400, pivots={{-12,0,6},{0,0,0}}},
			{ st = 7000, endt = 7400, pivots={{0,12,6},{0,0,0}}},
			{ st = 7000, endt = 7400, pivots={{0,-12,6},{0,0,0}}},
			
			{ st = 7000, endt = 7600, pivots={{18,0,6},{0,0,0}}},
			{ st = 7000, endt = 7600, pivots={{-18,0,6},{0,0,0}}},
			{ st = 7000, endt = 7600, pivots={{0,20,6},{0,0,0}}},
			{ st = 7000, endt = 7600, pivots={{0,-20,6},{0,0,0}}},
		}
		
		local linegrad = {3,4,0,4,0}  

		for p=1,#paths do
			local linestart = paths[p].st
			local lineend = paths[p].endt
			local linepath = paths[p].pivots
			if t > linestart and t < lineend+1000 then
				
				local st = lineend - linestart
				local pt = t - linestart
				local steps = 0
				for i=1,#linepath-1 do
					steps = steps + linepath[i][3]
				end
				
				local cstep = (pt/st)*steps//1
				
				local count = 1
				local lastx = linepath[1][1]
				local lasty = linepath[1][2]
				
				for i=1,#linepath-1 do
					local refx = (linepath[i+1][1]-linepath[i][1])/linepath[i][3]
					local refy = (linepath[i+1][2]-linepath[i][2])/linepath[i][3]
					for s=1,linepath[i][3] do
						local px = linepath[i][1]+refx*s
						local py = linepath[i][2]+refy*s
						local c = (cstep-count)//1 
						if c > 1 and c < #linegrad then
							line(posX+lastx,posY+lasty,posX+px,posY+py,linegrad[c])
						end
						count = count + 1
						lastx = px
						lasty = py
					end
				end
			end
		end

		local aid = End_em
		if End_em < 4 then
			aid = (t-7000)//360%4+1
			End_em=aid+1
		end
		drawSprite("End_Moonlights_"..string.format("%02d", aid),0,0)
	end

	local planetX = 68
	local planetY = 34
	drawSprite("End_Planet",planetX,planetY)
	if t > 7000 then
		local aid = End_ep
		if End_ep < 6 then
			aid = (t-7000)//360%6+1
			End_ep = aid+1
		end
		drawSprite("End_Planetlights_"..string.format("%02d", aid),1,0)
	end

	local sat1X = 44
	local sat1Y = 80
	drawSprite("End_Sat_03",sat1X,sat1Y)

	local sat2X = 90
	local sat2Y = 40
	drawSprite("End_Sat_01",sat2X,sat2Y)

	local sat3X = 174-t/5000
	local sat3Y = 10
	drawSprite("End_Sat_02",sat3X,sat3Y)

	if t > 10000 then 
		local aid = End_el
		if End_el < 36 then
			aid = (t-10000)//120%36+1
			End_el = aid+1
		end
		drawSprite("End_Logo_"..string.format("%02d", aid),0,0)
	end

	TwinkleTick(somaticState, "starz")
	vbank(0)
end
