-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\gfx\Frame03\\Container_Red.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000200A253PPA14PA5PCA3PPCCA2PC3APPC2OOPC3O2C2O4AP5APCCDDCCPC4DDC7DOBBC4OOBBC3OB4C5B3A15PPA5DCPPA3CDDCPPAAC2DDCPPC4DDC7DA47PPA5DCPPA170PA4PPCA3PC2AAPPC3A4PCCA2PPC2AAPC3OPPC3OOC3O3C2O3CCO3C2O2BC5OOBOC2O2BC2O2COOCCOOC3OOC37BBC23OOC7OOC7OOC7OOBBC5B3C4B4C4B2C4OBBC3OBBC2OOBC2NNBBCCN2CCDDCPA2C2DCPAAC3NCPAC2NNCCPCN2C2PNNC2DCPNCCD2CPC2D2CPA61PPA14PA5PCA3PPCCA2PC2DAPPC2DOPC2DDOOCCDDOOBOAPC3OOPC2DO2C2O3CCDO3CCDO2C3BOBC4O2C7OOC2O2BC3OC2OOC7OOC63OOC7OOC2OC3O2BC3OBBC2OOBC7OOBC3OBBC2OOBC2OOBC2NNBBC2N2C2N2C3N2CCDN2C2DDC2N2C2N2C2DN2CCD2NC2D3CCD4CCD4CD7CCD4CDC2D2CPDBCD2CPDBCD2CPDBCD2CPDBCD2CPDBCD2CPDBCD2CPDBCD2CPA3PPCCA2PC3AAPOC3APOIIC2PCI2OOCPCIIPIIOPCIIPOPIPCIIPOPOCDBOBOCCDB2OC3DDBC6DDBC6DDBOC5DIOC5OIPOC8OOC7OC23BBC5DDBBC2OCCDDBCOBC7OC5OCOOC2OBC2O2BC2OOBC3OBBC2NOBC2N2BC2N2CCOBBCCNNOBC2N2BCCN2C3N2C2N2C2DDNNC2D2C2D4CCDDCD2NNCCD3C2D4CD8CD6CD6CD6CD12CD5CCD4CDCD5CCD4CCD6CCD4CCD6CCD4CCDBCD2CPDBCD2CPDBCCDDCPDBCDCDCPDBCCDCCPDBCDCDCPDBCCDCCPDBC4PPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPO2IIOOCCOOPOIIPCONPO2IOONPO2PIOOPO2PO2PO2PO2PO2NNOOPO2POC3DDBC8OC5NIOOCCN2OIIOCCNCO2IOC2O2IOCDDO2IOCDDCCN2C2N3C2DNNC2D2NC2D3CCBCD5BCD5BCD5BCDDCD4CD6CD6CD22CD14CD12CD14CD14CD14CD3CD6CCD4CCD5C2D3C2D3C4DCDC2PDCDC2PAC3PPAADBC3PADBC2PAAC3PA2CCPPA3CPA5PA22PCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOPCIIPOPOAPOIIPO3PO2PO2PO2PO2PO2POONPO2POONPO2PO2PO2PO2PO2PO2PO2PO3IOCDDO2IOCDDO2IOCDDO2IOCDDO2IOCDDO2IOCDDO2IOCDDO2IOCD3BCD5BCD5BCD5BCDDCD2BCDCD3BCDCCD2BCDCDCDDBCDDCD12CD14CD9CD3CDCD4C3DDCDC3D4CDCD2CCDCCDDCCDC2DCDC2PPDDC2PAAC2PPA2CCPA4PPA5C2PA3CPPA4PA111PPOIIPOAAPCI2PA2PCI2A3PCCIA4PACA5PPA15OOPO2NNPOPO2POIPPO2POIIPPOOPOI3POPOCCI3POPPCCI2PAAPPCI2O2IOCDDO2IOCDDO2IOCDCO2IOCDDO2IOCDCO2IOCCDPOOIOCDCIPOIODCDDCBCDCDCCDBCDCCDDCBCDCDCCDBCDC2DCBCDC4BC3PDC4PACDCCPPAADCDC3PCDC2PPADC2PA2CCPPA3CPA5PA282PCCIA4PPCA6PA39IIPIOCDCI3OC4IIOC2PPCOCCPPAAPPCPA4PPA18DCCPA3CPPA4PA302"

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
