-- space logistics

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

-- the rle-decoder
function unpac(str)
  local r = str:sub(1,5) -- get (o)ffset into (r)aw data
  local r = r .. str:sub(6,8) -- get (w)idth into (r)aw data
  local e=str:sub(9,str:len()) -- remove header to get (e)ncoded data
  local d = "" -- (d)ecoded data
  for m, c in e:gmatch("(%u+)([^%u]+)") do -- decode rle, (m)atch & (c)ounter
    d = d .. m .. (m:sub(-1):rep(c)) -- (d)ecoded data
  end
  for x = 1,#d,1 do -- get (d)ecoded data into (r)aw data
    r = r .. string.format("%x",(string.byte(d:sub(x,x))-65))
  end
  return r
end

function unpac_noheader(str)
  local r = ""
  local d = "" -- (d)ecoded data
  for m, c in str:gmatch("(%u+)([^%u]+)") do -- decode rle, (m)atch & (c)ounter
    d = d .. m .. (m:sub(-1):rep(c)) -- (d)ecoded data
  end
  for x = 1,#d,1 do -- get (d)ecoded data into (r)aw data
    r = r .. string.format("%x",(string.byte(d:sub(x,x))-65))
  end
  return r
end

-- the raw-decoder
function tomem(str,adr)
  local o = adr or tonumber(str:sub(1,5),16) -- get (o)ffset, from param or string
  local w=tonumber(str:sub(6,8),16)-1 -- get (w)idth
  local d=str:sub(9,str:len()) -- remove header to get (d)ata
  local y=0
  for x = 1,#d,1 do -- write to mem
    local c=tonumber(d:sub(x,x),16) -- get (c)olor value
    poke4(o+y,c) y=y+1
    if y>w then y=0 o=o+1024 end
  end
end

local sprites = {}

function loadSprite(name,w,h,bg)
	sprites[name] = { w=w, h=h, bg=bg, data={}	}
	cls(sprites[name].bg)
	spr(256,0,0,sprites[name].bg,1,0,0,16,16)
	for x=0,sprites[name].w-1 do
		for y=0,sprites[name].h-1 do
			sprites[name].data[x+y*sprites[name].w] = pix(x,y)
		end
	end
end

function loadExtendedSprite(ref,name,w,h,bg)
	sprites[name] = { w=w, h=h, bg=bg, data={}	}
	--cls(sprites[name].bg)
	--spr(256,0,0,sprites[name].bg,1,0,0,16,16)
	local i=0
	for m in string.gmatch(ref, '%x') do
	 sprites[name].data[i]=tonumber(m,16)
	 i=i+1
	end	
end

function sweetie16_init()
	tomem(unpac(pal))
	poke(0x3FF8, 0) -- border
	poke(0x3FF9, 0) -- screen offset
	poke(0x3FFA, 0)
end

function no_fn()
end
