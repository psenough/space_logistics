-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\gfx\Frame03\\Container_grey.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000200A253PPA14PA5PHA3PPHHA2PH3APPH2OOPH3O2H2O4AP5APHHNNHHPH4NNH7NOPPH4OOPPH3OP4HHP7A15PPA5NHPPA3HNNHPPAAH2NNHPPH4NNH7NA47PPA5NHPPA170PA4PPHA3PH2AAPPH3A4PHHA2PPH2AAPH3OPPH3OOH3O3H2O3PHO3P2O2IP3HHOOIOPPHO2IP2O2POOPPOOP3OOP63OOP7OOP7OOP7OOPPH5P3H3P5HHP5HHP2OPPHHPPOPPH2OOIH2NNIIHHN2HHNNHPA2H2NHPAAH3NHPAH2NNHHPHN2H2PNNH2OHPNHHO2HPH2O2HPA61PPA14PA5PHA3PPHHA2PH2NAPPH2NOPH2NNOOHHNNOOIOAPH3OOPH2NO2H2O3PHNO3PPNO2P3IOIP4O2P7OOP2O2IP3OP2OOP7OOP63OOP7OOP2OP3O2IP3OIIHPPOOIH2P4OOIP3OIIHPPOOIH2OOIH2NNIIH2N2H2N2H3N2HHON2H2OOH2N2H2N2H2ON2HHO2NH2O2H2O4HHO4HHO5H2O4H4O2HPOIHO2HPOIHHOOHPOIHOHOHPOIHO2HPOIHOHOHPOIHHOOHPOIHOHOHPA3PPHHA2PH3AAPOH3APOIIH2PHI2OOHPHIIPIIOPHIIPOPIPHIIPOPOHNIOIOPPNI2OP2HNNIP3H2NNIPPH4NNIOH5NIOH5OIPOH3P4OOP7OP23IIP5NNIIP2OHHNNIPOIP7OP5OPOOP2OIP2O2IHPPOOIH2POIIH2NOIH2N2IH2N2HPOIIHHNNOIH2N2IHHN2H3N2H2N2H2OONNH2O2H2O4HHO5NNHHO3H2O4HO8HO6HO6HO2HO2HO6HOHOHOHO4H2O4H2OOHO2HHOHOHOH2O3HOHHOHOHOH2OOHOHOHHOHOHOHHOIHHOOHPOIH2OHPOIHHOHHPOIH2OHPOIH4PHIH4POIH4PHIH4PPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPO2IIOOHHOOPOIIPHONPO2IOONPO2PIOOPO2PO2PO2PO2PO2NNOOPO2POH3NNIH8OH5NIOOHHN2OIIOHHNHO2IOH2O2IOHO4IOHOOHHN2H2N3H2ONNH2O2NH2O3HHIHO5IHO5IHO5IHO20HO6HOOHO3HO6HHOHOHHOHO4H2OOHOHO2HO3HHOHOHOHHOOHOOHOHHOHOHOHOOH2OHOHHOHOHOHHOHOHOHOHHOHOHOH3OHOHOHHOH2OHHOHOHOH3OHOH5OH11PH5PAH3PPAAOIH3PPHIH2PAAH3PA2HHPPA3HPA5PA22PHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOPHIIPOPOAPOIIPO3PO2PO2PO2PO2PO2POONPO2POONPO2PO2PO2PO2PO2PO2PO2PO3IOHO4IOHHO3IOHOHO2IOHHO3IOHO4IOH2O2IOHOHO2IOHHO2IHO3HOIHOOHO2IHO3HOIHHO4IHO3HOIHHOHHOHIHO2HHOIHHOHOOHO2HOH3OHOHHOHOHOHOH3OH2OOHOHOHOH5OHHOHOH7OH3OHOHOH3OH5OH12PPH4PAAH2PPA2HHPA4PPA5H2PA3HPPA4PA111PPOIIPOAAPHI2PA2PHI2A3PHHIA4PPHA6PA15OOPO2NNPOPO2POIPPO2POIIPPOOPOI3POPOHHI3POPPHHI2PAAPPHI2O2IOHOHO2IOHHO3IOHOHO2IOHHO3IOHO4IOH2POOIOHOHIPOIOHHOOHIHOHOHHOIH4OOIHOHOH2IH5OIHOH4IH3PHOH3PAHOHHPPAAOHOH3PHOH2PPAOH2PA2HHPPA3HPA5PA282PHHIA4PPHA6PA39IIPIOHOHI3OH4IIOH2PPHOHHPPAAPHHPA4PPA18OHHPA3HPPA4PA302"

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
