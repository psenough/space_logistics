
function tunnel_init()
	tunnel_st = time()
end

function tunnel(tt)
	local t = tt - tunnel_st
	
	cls()
	math.randomseed(1)
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

end
