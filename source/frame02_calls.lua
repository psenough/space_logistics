
function rotate(points, pitch, roll, yaw)
    local cosa = math.cos(yaw)
    local sina = math.sin(yaw)

    local cosb = math.cos(pitch)
    local sinb = math.sin(pitch)

    local cosc = math.cos(roll)
    local sinc = math.sin(roll)

    local Axx = cosa*cosb
    local Axy = cosa*sinb*sinc - sina*cosc
    local Axz = cosa*sinb*cosc + sina*sinc

    local Ayx = sina*cosb
    local Ayy = sina*sinb*sinc + cosa*cosc
    local Ayz = sina*sinb*cosc - cosa*sinc

    local Azx = -sinb
    local Azy = cosb*sinc
    local Azz = cosb*cosc

    local px = points[1]
    local py = points[2]
    local pz = points[3]

    local ox = Axx*px + Axy*py + Axz*pz
    local oy = Ayx*px + Ayy*py + Ayz*pz
    local oz = Azx*px + Azy*py + Azz*pz
    
	return {ox,oy,oz}
end

function Frame02(t)
	cls()
	local id=t//2000%4
	math.randomseed(id)
	local r=500
 for i=0,700 do
 	-- random generate points on a sphere
  local u=math.random()*2-1
  local theta=math.random()*2*math.pi
  local x=r*math.sqrt(1-u*u)*math.cos(theta)
  local y=r*math.sqrt(1-u*u)*math.sin(theta)
  local z=r*u
  -- rotate them
  local drag = (math.sin(t/2000)*.5+1)*.02
  local rp = rotate({x,y,z},t/2000,t/3200,t/1800)
  local rpb = rotate({x,y,z},t/2000+drag,t/3200+drag,t/1800+drag)
  -- project them to viewport
		if rp[3]<0 and rpb[3]<0 then
			local screenX = 120+(rp[1] / -rp[3])*240
	  local screenY = 68+(rp[2] * 1.7647 / -rp[3])*136
			local screenX2 = 120+(rpb[1] / -rpb[3])*240
	  local screenY2 = 68+(rpb[2] * 1.7647 / -rpb[3])*136	  
	  --pix(screenX,screenY,12)
			--pix(screenX2,screenY2,4)
			line(screenX,screenY,screenX2,screenY2,12)
  end
 end

	-- draw planet and spaceship
	if id==0 then
		drawSprite("Planet_01",86,30)
		drawSprite("Ship_01",80,20)
	elseif id==1 then
		drawSprite("Planet_02",86,30)
		drawSprite("Ship_02",86,26)
	elseif id==2 then
	 drawSprite("Planet_03",86,30)
		drawSprite("Ship_03",84,24)
	elseif id==3 then
	 drawSprite("Planet_04",86,30)
		drawSprite("Ship_04",80,20)
	end	
end
