
function tunnel_init()
	tunnel_st = time()
end

TUNNEL_Gradient = {9, 10, 11, 12}
TUNNEL_Gradient_Darker = {8, 9, 10, 11} -- same gradient but 1 shade darker

function tunnel(tt)
	local t = tt - tunnel_st
	
	cls()
	math.randomseed(1)

	--draw tunnel

	local y1 = 36--46+math.sin(t/700+10)*20
	local y2 = 100--110+math.sin(t/1000)*20

	local prevx = (-40-t/20)%280
	for x=-20,260,10 do
		local normColor = math.random()
		local colIndex = SelectNorm(TUNNEL_Gradient, normColor)
		local col = TUNNEL_Gradient[colIndex]
		local shadowCol = TUNNEL_Gradient_Darker[colIndex]
		local posx = (x-t/20)%280-20
		local seamSizeOnWall = math.random(3,15) -- keep out of below loop otherwise it messes with rand sequence
		if prevx < posx then
			-- ceiling
			tri(posx,y1,posx*2-120,0,prevx*2-120,0,col)
			tri(prevx,y1,posx,y1,prevx*2-120,0,col)
		
			-- wall
			tri(posx,y1,posx,y2,prevx,y1,col)
			tri(prevx,y1,posx,y2,prevx,y2,col)
			
			-- floor
			tri(posx,y2,posx*2-120,136,prevx*2-120,136,col)
			tri(prevx,y2,posx,y2,prevx*2-120,136,col)

			-- draw kind of ambent occlusion effect on wall.
			-- dynamic height of this effect actually makes no sense but it looks more dynamic than fixed,
			-- probably due to bayer noise.
			for seamRY = 0, seamSizeOnWall do
				local seam01 = 1 - (seamRY / seamSizeOnWall)
				local seamY1 = y1 + seamRY
				hlineBayerShadow(prevx, posx, seamY1, shadowCol, seam01)
				local seamY2 = y2 - seamRY
				hlineBayerShadow(prevx, posx, seamY2, shadowCol, seam01)
			end
		end
		prevx = posx
	end

	-- draw ships

	math.randomseed(t)

	local slx = math.sin(t/1000)*10+t/60-100
	local sly = 30+math.sin(t/800)*6
	drawSprite("Tunnel_Shiplarge", slx, sly)
	circ(slx+97,sly+54,math.random(2),math.random(3)+3)
	
	slx = math.sin(t/2100)*6+t/46-20
	sly = 98+math.sin(t/1800)*4
	drawSprite("Tunnel_Shipsmall_01", slx,sly)
	circ(slx+1,sly+16,math.random(2),math.random(3)+3)
	circ(slx+3,sly+19,math.random(1),math.random(3)+3)

	slx = math.sin(t/2000+10)*6+t/30-80
	sly = 5+math.sin(t/1700+2)*4
	drawSprite("Tunnel_Shipsmall_02",slx,sly)
	line(slx+2,sly+9,slx+6,sly+5,math.random(3)+3)

	drawSprite("Tunnel_Shipsmall_03", math.sin(t/2100+20)*6+t/58-140, 94+math.sin(t/1900+4)*5)

end
