-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Ship_02.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000280A197EEA4MMEA4EEMA4E2A4E2A4E2A4DEDA4EDE4A3E6AM2E2NNE2MMNPIE4NOIE4NAIE4NAIDEDEDNAIA15NA6NA6NA6NA6NA6NA315N2A2N3EA30NA6OA4E2NAE13A11NNA2N3E2N2E35MA4D2E2AAO2E5AOE21MME2M12EDEDENAID4NAIO3DNOIEEO2NOIEMMEONAIM5AIM11E3NA6NA6NA6NA6NA6NA6EEA5E4A258ON2E3OOE5PE6PEMME3PE2MMEEPE4MMPE6ADDE27ME3M3EM14NM6N2M2E5M3EEM27EEM2E20M14EM3E3MME37MME122DEEA7E2A4E5AAE17DE20A23EA6E3A3E6AE15A47EOA5EEDDA69ODDE2AAO2D2AAI2O2A2OOI2A4O2A6OA15N3EEMMN3E3N3E3ON2DE2NOONODDEN2OIIODAN2OOIIA2NNO2E7M2E7MME7M2E7DDE5IODDE3OIIOD2E32MME4DEEM2DDE4DMME7ME14DE3DDE3DDE3DE22ME8DE4DE51DDE37DDE3DE3DE27DDE2DDE3DE21DE4D2E2D5E4AAE13DDE3D3ED21KD4K2A7PA6DDPA4D2A4D3A3DKJDDA2KKJDDA2KJJDDA71O2A55O2IIOODO4I2AAO5A4O2A6OA23DE2DE2OD2E3IIOODDEEOOI2ODDO4IIOAAO4IA3O3A5OOEM2E7MME7MME7D2E4IIODDE2OOIIOD2O3I2OE2DE4DE5ME6DMME3ME2M2DEDE4ME8DDE20DEEDEED3EED4ED14ED5KKLD2K2ED21KD4K2D2K3JDK3JJDK2JJDDPKJJDDPPAD2K3JDK3JJDK2JJD2KJJD2PPJD2PPAADDPPA2P2A2PPA2P2A2JD2PA2DDP2A2PPAAPA5PA4PPA4PA279O5IA2O4A5OOA39IOD2E2OIIOODDEO2I2ODO5IPA2O4A4O2A6OA7KLLEDKKJKKLEDJJDDEKED2PPD3PPAP4A2OOPA2PPO2P2A9JDDPPA2DPPAAP3A2PA4PPA3PPA29PPA125"

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
