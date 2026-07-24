-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame03\\Container_grey.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000200A246HA4H2A13HHA4H2A2H3OAAH2O2H3O3HHO4PHOOIOP2HHNNHHAAH3NNHAH5NNPPH5OPPH4P4H2P6HP7A15HA6NNHA4HHNNHA2H3NNHAH5NNPH6A47HA6NNHA163HA5HHA3H3A2H3OAH3O2A3H3AAH3OOAH3O2H2O3PHHO3PPO3P3OOIP4OOIP4O2IP3OOPOOP2OP3OOP7OP55OP7OOP7OOPPOP4OOIP3OOIHP2H4P4H2P4H2PPOPPH2POPPH2NOIH2N2IHHN2H3N2H4NHA3H2NHA2HHNNHHAAN2H2AANH2OHAAHHO2HAAHHO2HAAHHO2HA56HA4H2A13HHA4H2A2H2NNAAH2NOIH2NNO2HNNOOIOPNIOIOP2H2NO3HHO3PPNO3P2O2P4OIP5OOP7OOP7OOP4OOP7OOP7OP55OP5OPOOP2OIP2O2IHP2OIIHHPOOIH2NOIIHHN2P2OIIHHPOOIH2NOIH2N2IH2N2H2N2H3N2HHOONNH2OOHNHHO3HN2H2OONNHHO3H2O2HOHO4HO5HHO5HHO5HHO5HHOIHO2HAAIHHOOHAAIHOHOHAAIHO2HAAIHOHOHAAIHHOOHAAIHOHOHAAIHHOOHA4H3NAAOH4AOIIH4I2OOH2IIPIIOOHIIPOPIIHIIPOPOOHIIPOPOOI2OP3NNIP4HHNNIP2H3NNIPH5NIOH5NIPOH4OIIOOH2P5OOP23IP6NIIP2OOHNNIPOIIH2NNIHHP5O3P2OIIPPO2IHHPOOIH2NOIIH2NNIH2N2H3N2H2N2H2OIH2N2H2N2H3N2H2ONNH2O2NH2O3HHO5HO14HHO4HO6HOHO4HOHO4HOHO2HOHOHO4HOHOHOHOHOHO3HHO4HHO2HO2HOOHOHOHHO4HOHOOHOHOH2OOHOHOHOOHOHOH3OHOHOHOIH2OHAAIHHOHHAAIH2OHAAIH4AAIH4AAIH4AAIH4AAIH3A2HIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOHIIPOPO2POIIPHHNPO2IOONPO2PIIOPO2PO2PO2PO2PO2NNOOPO2PO2PO2POOH6NH5NNOOHHN3IIOHHNHHOOIOH2O2IOHO4IOHO4IOHO2N2H2OONH2O3H2O4HIHO5IHO5IHO5IHO3HOIHO11HHO6HOOHO2HHO6HHOHOH3O4HOHOOHOHOHHO2HOHOOHOHOH2OHOOHOHOOHOHOHOH3OHOHHOHOHOH3OHOHOHHOHOHOH3OHOH3OH2OH3OHOH3OHOH5OH11AAH4A2H2A4HHA5IH2A3H2A4HA46HIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOHIIPOPOOAOIIPO2AAOIIPO2PO2PO2PO2POONPO2POONPO2PO2PO2PO2PO2PO2PO2PO2PO2NNO2IOHHOHOOIOHOHO2IOHHOHOOIOHO4IOH3OOIOHOHO2IOHHOHOOIOHOHOOIHOOHOHOIHO5IHHO2HOIHO5IHHOH3IHO2HOOIHHOHOHHIHOHOHOHHOHOH3OHOHOHOHHOH2OHHOHOHOH5OH3OH7OH3AHOH3AAOH13AH4A2H3A3HHA5HA152HI2PPA2HI3A3HHIIA5HIA6HA23OPO2POOPPO2POOIPPOOPOOI2POPOOHI3POOAHHI2PPA2HI3A3HHIIOOIOHHOHOOIOHOHO2IOHHOHOOIOHOOHOOIOH3OOIOHOHHPOIOHHOHIPIOHOHOOIH5OIHOHOHOHIH5OIHOH4IH3AAOH3A2OHHA4HHA5OH2A3H2A4HA308HIA6HA47I2OH4IIOH2AAHOHHA4HHA355"

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
