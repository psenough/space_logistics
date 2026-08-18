
function rim(x,y,w,q,c)
	for i=0,q do
		local r = w * math.sqrt(1-math.random()*math.random())
		local theta = math.random() * 2 * math.pi
		local px = x + r * math.cos(theta)
		local py = y + r * math.sin(theta)
		pix(px,py,c)
	end
end

function supernova_init()
	supernova_st = time()
end

function supernova(tt)
	local t = tt - supernova_st
	--cls()

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
	
	local px = 10
	local py = 120
	rect(px,py,40,9,0)
	print(string.format("%.0f",(20000+t)//15),px+16,py+2,2)

end
