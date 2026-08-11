
function rocks(x,y,seed,rid)
	dx=x+math.sin(time()/5000+seed)*25+math.sin(time()/15000+11+seed)*20
	dy=y+math.sin(time()/20000+seed)*10+math.sin(time()/8000+1+seed)*20
	drawSprite(rid,dx,dy)
end

F11_st=0

function Frame11_init()
	F11_st = time()
end

function Frame11(tt)

	local t = (tt - F11_st)
	
	cls()

	math.randomseed(8)
	stars_noscroll(t+10000)
	
	for i=0,12 do	
		rocks((200+math.random()*160-t/2000)%300,
					math.random()*130,
					math.random()*50,
					"F11_Rock_"..string.format("%02d", math.random(1,4)))
	end

	drawSprite("F11_Ship",30+t/3000,0)

	for i=0,8 do	
		rocks((200+math.random()*200-t/1400)%300,
					math.random()*130,
					math.random()*50,
					"F11_Rock_"..string.format("%02d", math.random(1,4)))
	end

end
