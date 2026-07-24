-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame03\\Container_Red.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000200A246CA4C2A13CCA4C2A2C3OAAC2O2C3O3CCO4CCOOBOC4DDCCAAC3DDCAC5DDBBC5OBBC4B4C5B3C5B2A15CA6DDCA4CCDDCA2C3DDCAC5DDBC6A47CA6DDCA163CA5CCA3C3A2C3OAC3O2A3C3AAC3OOAC3O2C2O3C2O3CCO3C3OOBC4OOBC4O2BC3OOCOOC2OC3OOC7OC38BC15OC7OOC7OOCCOC4OOBC3OOBCB2C4B4C4B2C4OBBC3OBBC2NOBC2N2BCCN2C3N2C4DCA3C2NCA2CCNNCCAAN2C2AANC2DCAACCD2CAACCD2CAACCD2CA56CA4C2A13CCA4C2A2C2DDAAC2DOBC2DDO2CDDOOBOCDBOBOC5DO3CCO3CCDO3C2O2C4OBC5OOC7OOC7OOC4OOC7OOC7OC55OC5OCOOC2OBC2O2BC3OBBC2OOBC2NOBBCCN2C2OBBC2OOBC2NOBC2N2BC2N2C2N2C3N2CCDDNNC2DDCNCCD3CN2C2DDNNCCD3C2D4CD4CD5CD7CD5CD7CDBCD2CAABCD2CAABCD2CAABCD2CAABCD2CAABCD2CAABCD2CAABCD2CA4C3DAAOC4AOIIC4I2OOC2IIPIIOOCIIPOPIICIIPOPOOCIIPOPOOB2OC3DDBC6DDBC6DDBC6DBOC5DIPOC4OIIOOC8OOC23BC6DBBC2OOCDDBCOBBC2DDBC7O3C2OBBCCO2BC2OOBC2NOBBC2NNBC2N2C3N2C2N2C2DBC2N2C2N2C3N2C2DNNC2D2NC2D3CCD5CDDCD6CD3CCD4CD6CDCD4CDCD6CD4CDCD12CD12CD7CD5CCD6CD5CCD6CD5CCD6CDBCD2CAABCCDDCAABCDCDCAABCCDCCAABCDCDCAABCCDCCAABC4AABC3A2CIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOCIIPOPO2POIIPCCNPO2IOONPO2PIIOPO2PO2PO2PO2PO2NNOOPO2PO2PO2POOC6NC5NNOOCCN3IIOCCNCCOOIOC2DOOIOCD2OOIOCD2OOIOCD2N2C2DDNC2D3C2D4CBCD5BCD5BCD5BCDDCD2BCD7CD6CD22CD14CD12CD4CD8CD4CD8CD4CD8CD3CCD3CDCCD4CCD5C2D3C3D2C4DCDC2AACDC2A2C2A4CCA5BC2A3C2A4CA46CIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOCIIPOPOOAOIIPO2AAOIIPO2PO2PO2PO2POONPO2POONPO2PO2PO2PO2PO2PO2PO2PO2PO2NNO2IOCD2OOIOCD2OOIOCD2OOIOCD2OOIOCD2OOIOCD2OOIOCD2OOIOCD3BCD5BCD5BCDDCD2BCDCD3BCDCCD2BCDCDCDDBCDDCDDCBCDCDCD3CD14CD9CD3CDCDCD2C4DCDC3ACDC3AADDCCDC2DCCDC2ACDC2A2DC2A3CCA5CA152CI2PPA2CI3A3CCIIA5CIA6CA23OPO2POOPPO2POOIPPOOPOOI2POPOOCI3POOACCI2PPA2CI3A3CCIIOOIOCDDCOOIOCDCDOOIOCDDCOOIOCDCDOOIOCCDCOOIOCDCDPOIODCDCIPIOCDCDDBCDCCDCCBCDCDCDDBCDC4BCDC4BC3AAC4A2DCCA4CCA5DC2A3C2A4CA308CIA6CA47I2OC4IIOC2AACOCCA4CCA355"

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
