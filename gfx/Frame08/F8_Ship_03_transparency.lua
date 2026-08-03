-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Ship_03_transparency.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000280B29EEB2E4BP2E2MBP3MMDBPPHPD2B23E3B3E2MMB2M2DDB2D4B2D4B127E2B37MMB2EEM2E15B14EB3E3BM2E3M6EM7EM6E2M4BBE2B2E31MME5M5EEM7B15EEB5E4B2E23ME6B39E2B4E6BE7B3A3B3A3B3A3B3A3B3A3B3A3B3A3EB2A3BPHFPD2BPHFPD2BPHFPD2BPHFPD2BPHFPD2BPHFPDOOBBHFPO2BBHPPOEED4B2D4B2D4B2D4B2DDO2BEEO3E4DDE8DE2B14EB3E3BE38BBE31DE19DE65DE10MME55M7EM6E2M4E6ME31M2E4M5EEM15EEM5E4M2E6ME3D3E15ME6M3E2DM4D2MMO2D2O4D2O4D2E2BA3E3A3EDDEA3DKKJA3DKKJA3DJ2A3D3A3DDPBA3BBHPPE2BBPPD2EBBP3DDBP2NAPPBPHN3APHFHHN2PHFFMHHNPHFFM2HE5DDE7DE6PD2E3AAPPDDEENA2PPDDN3AAPPHNNOAIAAE8DDE8DE8DDE15D2E4PAPD2E34DE9DE8DDE11DDE8DE40DE13DE7DDE8DDE7DDE5DDE2D4ED6E14DE4D2EED35PPEED35PID2PI2PDPIIP3IIP5O4D2O4P2O4I2O4P2O4PBBO3B3OOB13P2BA3I2BA3PPBBA3B3A3B3A3B3A3B3A3B3A3PHFFM3PHF3MMPAHHF3BP2HHFFBBAP2HHBBA2PPABBHA3PBBHFPIIAMHOOIAIAMHOOAIAIMHOOA3FHOOAIIAHHOA9PPAP2A6P2A2I2APPDDAIANAAPPAHN3AAIFHHN3HFFMHHNNHFFM2H2FFM4HF3M2E7D2E4P2DDMEEA2PDEEDN2PD3NNOAD3HOOAID2HOOAID2E2DEEDDE3D3ED35PIID2PIIPPD22PD4PIIDDPI2P2IIP4IP5BP3B3D3PI2DPPIIP2I2P10BBP2B4PB22P4B2P2B120A3B3A3B3A3B3A3B3A3B3A3B3A3B3A3BBHFPI2BBHFPIOOBPHFPIDOBPHFIDODBPHFIDDOBPHFPODDBPHFPODDBPHFPD2OA2P3DODAB2PODODB3DODOB3D3B3D3B3D3B3D3B3AHHF3MPAAHHF2BPPAAH2B2APA2B4APAB6AB15HOOAID2HOOAPDPIHOAAPPIPAAP5AAP11B17PPIIP3IIP4BP4B2PPB37PPB257A3B3A3B3A3B3A3B3A3B3A3B3A3B3A3BPHFPD2BPPHID2BP2ID2BBP2D2B2PPD2A23D3B3D3B3D3B3D2B4DDB5A23B39A23B39A23B39A23B39A23B39A23B39A23B39A23B3A3B3A3B3A3B3A3B3A27"

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
