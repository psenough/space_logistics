-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Ship_01.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000280A252E2A38MA2EEM2E15A14EA2E4AEMME3M6EM7EM6E2M4AAE2AANE31MME5M5EEM7NA6N3A3EEN3AAE4OAAE23ME6A6EA3E3AE6ANNE3DANPPND2ENPHND2ENIAND2ENIAND2E2A4E3A3EED2A2D4A2D4A2D4A2D4A2D4A65EA37EEA2OE3ADDE8DE2A14EA3E3AE38AAE31DE19DE65DE10MME55M7EM6E2M4E6ME31M2E4M5EEM15EEM5E4M2E6OE4DDOENIAND2ENIAND2MNIAND2MNIOND2MNIOND2MNIAND2ONIAND2ONIAND7A2D4A2D4A2D4A2D4A2D4A2D4A2D4A6PMMEAAPE3MAAE5ADE5DEKLE3DEKL2EEDEKKL3PD2KKLLE5DDME7MME7MME7MME7ME7LLE14DDE8DE8DDE7ME7M2E7MME34DE9DE8DDE11DDE8DE40DE13DE7DDE8DDE7DE13D2E2D4E22DE3D3EED13OD6OD4AAE2D3OED5OD6OD6AD4AAOD2AAIIOA2IP2OIIP4OONIAND2ONIAND2ONIOND2ANIOND2ONIOND2ONIAND2ONIAND2ANIAND7A2D4A2D4A2D4A2D4A2D4A2D4A2D4A2P2D2KKPOOPPD2APAOOPPDAAPPAOOPA3PPAOA5PPA15L3E3KKL3EEDDKKL3PD2KKLLOPPD2KKAOOP2DDP2O2PPA2PPAOOE5MME15LLE5L3E3KKL3EEDDKKL3PPDDKKLLE7MMDE6MMDME5MMDE11D4EEDKJD2EDKKJD2E2DE10DE3D3EED2OD6OD6ODAD4AAID2AAIPPED21AD3A2IDDAAIIPPAAIP4IP5AP3A3ODDA2IIDAAIIP2AIIP10AAP2A4PA22P4A2P2A53NIAND2ANIAND2ANIONDDOANIONOOEANIONEEDANIAND2ANIAND2ANIAND5ODA2DOOEEA2OEEDDA2ED3A2D4A2D4A2D4A2D4A71P2A55OOPPDDKKPAOOPPDDAPPAOOPPA2PPAOOA4PPA7PA15EDKJJD2EDJD2AAD3AAIP8OAP5OP4A20IP3IIP4AP4A2PPA37PPA190NIAND2ANIAND2ANIOND2ANPOND2AANPND2A2NNDDA16D4A2D4A2D4A2D3A3D2A28"

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

-- call the decoders
col = unpac(pal)
tomem(col)
pix = unpac(gfx)
tomem(pix)

-- the viewer
m=2 -- mode
t=0 -- tiles/sprites
r=0 -- range

function draw()
  if m==2 and r>0 then r=0 end
  if m==4 and r>16 then r=16 end
  if t==0 then s=r else s=r+(128*m) end
  poke4(2*0x03ffc,m)
  cls(0)
  for y = 0,128-8,8 do
    for x = 0,(m*64)-8,8 do
      spr(s,x+56,y+4) s=s+1
    end
  end
  rect(184,2,56,132,00)
  rectb(54,2,132,132,10)
  print("Tiles",4-(t*32),4,15)
  print("Sprites",-40+(t*44),4,15)
  print("Page: "..(r//16),4,12,15)
  print("Mode: "..m,4,20,15)
  print("CTRL\n toggle\n Tiles or\n Sprites",4,32,10,false,1,true)
  print("Up/Down\n switch\n color\n mode",4,62,10,false,1,true)
  print("Left/Right\n switch\n pages",4,92,10,false,1,true)
  print("TAB\n display\n system font",4,116,10,false,1,true)
  for c = 0,15,1 do
    rect(208,(c*8)+4,8,8,c)
    print(c,218,(c*8)+6,15,false,1,true)
  end
end

-- call the viewer
draw()

-- system font demo - https://github.com/nesbox/TIC-80/wiki/system-font
offy=4
offx=65

function font()
  cls()
  print("SYSTEM",0,5,12)
  print("FONT",0,12,12)
  print("CTRL\n back to\n Tiles or\n Sprites",0,24,10,false,1,true)
  for x = 0,15 do
    off = x*16
    print(string.format("%+3s",off),offx-20,x*8+offy+1,14,true,1, true)
    for y =0,15 do
      char = y*16+x
      rect(x*11+offx,y*8+offy,8,7,15)
      print(string.char(char),x*11+offx,y*8+offy,12)
    end
  end
end

function TIC()
  if btnp(00,60,6) and m<8 then m=m*2 draw() end
  if btnp(01,60,6) and m>2 then m=m//2 draw() end 
  if btnp(03,60,6) and r<48 then r=r+16 draw() end
  if btnp(02,60,6) and r>0 then r=r-16 draw() end 
  if keyp(63,60,6) then t=1-t draw() end
  if keyp(49,60,6) then t=1-t font() end
end
