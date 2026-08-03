-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Ship_04.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000280A52E2A2E4A30EA3E3AE22A6EA3E3AAE35MME2M4EEA5E4A2E20M2EEM21A23M2A4M5AAM6EM2E4ME6A39EA6E3A3E6A257E15MME4K2MME2K2EEM2E6NDDE4NAODDE2NE13MME2M27ENNM2E2N2EEMMEEM27E2MME29M5EEM2E4ME162DE3DE7A5E4A2E16DE29A23E2A4E5AAE22DA47EDA5E4A67O2D2NAI2O2NAAOOI2OA3O2NA5ONA23N2E3MN2E4N2DE3OONODDEENNOIIODDN2OOI2AANNO3A3O3MME7MME7M2E7MDE6ODDE4IIOD2EEOOIIOODDE23ME4DDEM2DDE4DMME7MME2DE9DDE2DDE3DDE10DDE2M2EDE2ME5M2E2M2EEM2E31D2E7D2EDE3DDE4P2E24DE3DDE3DE26DDE3DDE2DDE26DDE3DDPPED2PPAADPAPAAIAE6AE4D2E2D2PPD2P2ANPPA2N2A2N3HN4HHMONNHHM2A7PPA5PPA5P2A4NHPA4HFHPA3FFHPA3FFHPA74OA55O3I2OAO5IA3O3A5OOA31D2E4IOODDE2OI2ODDEO3IIODAO4IIA2O4A4O2A7EEME6ME6ME4DDME4IOME4OIME4OOME4OOME4MMP3E3PHPPE3PFHPMDEEPFHPEDEEPFHPEDEEPFHPEDEEPFHPDIEEPFHPPIE3DDPPED2PPAADP2AANNPA2N3PN4HHAONNHHMMAOOHM3AOOHM2FAI2AIAINAIAIAIANNHA4HHFIAIIAMFFHA3MFFHAPPAMFFHA3F2HA2POOHM4OOHM2FFOOHMF3OOHF2HHAOH3PPA4PPAAP3A2PPA5FFHPA3FFHPA3HHAPA3P2A4PA288ME4AAME4AAME4AAME4AAME4AAME4AAME4AAME6PFHPPIEEPFHP2EEPFHP2EEPFHPOPEEPFHPOOEEPHHPOOEEPHHPAAEEPIHPA2OOHMF2AOOHF2HAAOH3APPA4POPA2PAAOOPPA19FHHAP3HAAPPA3PPA430ME4AAME4AAME4AAME4AAME4AAME4AAME4AAEDE5PIHPAAEEPIHPAAEEPHHPAAEEPHHPAAEEPFHPAAEEPFHPAAEEPFHPAAEEPFHPA515ME2DEAAEDEDEEAAEEDEDEAAEDEDEDAAED3EAAEEDEDDAAED4A2D4EEPFHPAAEEIFHPAADEPFHPAAEEPFHPAADEPFHPAADDPFHPAAEDIFHPAADDIHPPA517D3A4D2A47DDP2A2DDPPA307"

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
