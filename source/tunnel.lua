
function tunnel_init()
	tunnel_st = time()
end

function tunnel(tt)
	local t = tt - tunnel_st
	
	cls()
	math.randomseed(1)

	--draw tunnel

	local y1 = 36--46+math.sin(t/700+10)*20
	local y2 = 100--110+math.sin(t/1000)*20

	local prevx = (-40-t/20)%280
	for x=-20,260,10 do
	 col = math.random(4)+9
		local posx = (x-t/20)%280-20
		if prevx < posx then
			tri(posx,y1,posx*2-120,0,prevx*2-120,0,col)
			tri(prevx,y1,posx,y1,prevx*2-120,0,col)
		
			tri(posx,y1,posx,y2,prevx,y1,col)
			tri(prevx,y1,posx,y2,prevx,y2,col)
			
			tri(posx,y2,posx*2-120,136,prevx*2-120,136,col)
			tri(prevx,y2,posx,y2,prevx*2-120,136,col)
		end
		prevx = posx
	end

	-- draw ships

	math.randomseed(t)

	local slx = math.sin(t/1000)*10+t/60-60
	local sly = 50+math.sin(t/800)*6
	drawSprite("Tunnel_Shiplarge", slx, sly)
	circ(slx+97,sly+54,math.random(2),math.random(3)+3)
	
	slx = math.sin(t/2100)*6+t/52-180
	sly = 60+math.sin(t/1800)*4
	drawSprite("Tunnel_Shipsmall_01", slx,sly)
	circ(slx+1,sly+16,math.random(2),math.random(3)+3)
	circ(slx+3,sly+19,math.random(1),math.random(3)+3)

	slx = math.sin(t/2000+10)*6+t/52-235
	sly = 55+math.sin(t/1700+2)*4
	drawSprite("Tunnel_Shipsmall_02",slx,sly)
	line(slx+2,sly+9,slx+6,sly+5,math.random(3)+3)

	drawSprite("Tunnel_Shipsmall_03", math.sin(t/2100+20)*6+t/50-290, 90+math.sin(t/1900+4)*5)

end
