-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame02\\Ship04.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000300A134DA6DA6DA6DA6DA6DA6DA6DEA6DEA5IDEA4IADEA3IAADEA2IAADDA2IAADDA2IAADDA609EA5DA5DA6DA6DA8DA6DA5DPE4DPA4DPAIA2DPAIIAADPAIIJADPAIIJJIAADDEAAIAADDOEA3DDODEAIIADODDIJBDAD2JJDPBADDJDBBPBADDBPPBPBA24EA6DEA5DDEA4D2EA3D3EA519DA6DPDA4PDPA4DPA4DPAIA2DPAIIAADPAIIJAADPAIJJDPAIIJJDPAIIJJDBAIIJJDBAIIJJDPAAIJJDBA2JJDBA3JDPA4DPAD4PDP2BPBAEP3BPAEDP3BAEDDP3AED2P2AED3BPDBED3B3ED3AD3EAABAD3EAPBAD3EBPBAD3PBPBAD2PPBPBADDP2BPBADP3BPBA24EA6DEA5DDEA4D2EA3D3EA398CAACCA2CAACA41DPAIJDAADPAIDPAADPADA3NPPDAPA2NPDPPA3NDPPA4NPPA5NPPAP3BPA2P3BPIA5IPIAAPPIPIPIAAP3IPIAAP2IIPIAAP2IIPIAB3ED2PB3EDDAAB3EDJJAB3EIJJAB3PIJJAB2A5BBAPPI2ABDBP2BPBDDBP2BPD2BP2BD3BP2ED3BPPBED3PPBBED3PB2ED3AD3EAABAD3EAPBAD3EBPBAD3PBPBAD2PPBPBADDP2BPBADP3BPBA24EA6DEA5DDEA4D2EA3D3EA393NA55P2IPIPINP2IPIPANPPIPPIAANPPIIPA2NPPIPA3NPPIA4NPPA5NPAP5AIA4JJPIAAPPIJIPIAAPPI2PIA3I2PIAAPIPPIPIAPPIPIIPIAB3ED2AB3EDDJAB3EDJJAB3EA3B3PI2AB2P4ABBA3JJABDBP2BPBDDP4BD2P2BPD3P2BED3P2BED3PPBBED3PB2ED3AD3EAABAD3EABBAD3EPBBAD3BPBBAD2PBPBBADDPPBPBBADP2BPBBA24EA6DMA5DMMA4DM2A3DM3A393NA55PPIPPIPINPPIPPIPANPPIIPIAANP2IPA2NP2IA3NP2A4NPPA5NPAAPPIJJAIAAPPIJJPIA5IPIAAPPI2PIAP2IPIPIA2PIPIPIAAPPIPIPIAB3ED2AB3EDDAAB3EDIIAB3EPPAAB3AAJJAB2PPIJJABBAPPI2ABDP2BPBBDDP2BPBD2P2BOD3PPOOED3O2BED2MOOBBEDDMMOB2EDM2AM4AAOAM3EAOOAM2DEO2AMMDDO3AMDDO4ADDO3BBADO2BPBBA24E4A2DEEPEEAADDEEPEEADEDEEPEED3EAPEA55EA333NA55P2IPIPINP2IPIPANPO4AANPOPPOA2NPOOPA3NP2A4NPOA5NOAAP3BAIA6OIAP4IPOAAO2PO2AAO6AAO6AAO6AB3EM2AB2NM2BPBN2MMO2N3MO3N3O4N2O5NNAO5BMOPPBPBBMDP2BPBMDDP2BPMD2P2BMD3P2NED3PPBBED3PPBBED3AD3MAPBAD2NMABBADDNNAPBBAPNNABPBBANNAPBPAANNAPPAAOONAPAAO3AEEA5E2A4E3A3EDDEEA2EPDDEEAAP2DDEEAEEPPDDE2DEPPDDEA33CA6CA12EA3CA328NA55O5PINO3PIPANOOP2IAANP4A2NP3A3NP2A4NPPA5NPAAP5IAAP3BPIAAP3IPIA3PPIPIA3PPIPIIPAP2IPINAP3INPAB3ED2PNB2EDDBPNB2EDPBPNB2EPPBPNB2APPBPNBBAAP3NBA2P3NDAO3AADDO2A2D2OA2BD3AAPPED3PPBBED2P2BBEDDP2B2EDP2EDDEPPDDED2EPPDAD3EPPBAD3EPPBAD3EPPBAD3PBPBAD2P3BADDEEA2CAADEEA4DDEEA3PDDEEA2PPDDEEAAEPPDDEEADEPPDDEEDDEPPDDEA15CA6CA30EA333NA55P3NPAANPPNAAPPANNA3PA43P6AAPBP4A3NP6ANP5AAN4A6NPA6NNB2AAPPBNBAAPAPA5PABPBBA2PPBPBBA10P4BPBP5BP3BPBADP5BAP4BPBAPA5PAP5AP6AAP5BAP5D2EPPD5EPPDAD3EPPBAD3EPPBAD3EPPBAD3PBPBADDAP3NNAAEEA5DEA5DDA5PDA5PPA542NP4BAAP5A2NP3A2N4A31PBAP4BPBAPPNPPBNANNAAN2PNA5NA27PBPBA3N2A116"

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
