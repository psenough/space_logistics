-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame03\\Beam_transparency.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000300C6LC39DC7DDC4L7CCL5C3L3C5LLC14DC4DDC2D2C2L39DL6C2L4C3DL578C2DDC3DC2D2CCDDCCDDC2D2C6DDCAAC3DDPPAAC3P3AC2DDC19D3CCDDC3DDC3DCCDDACCD2CCDDCCD2C2ECCDDCCLLDDC19EEC3EEDDCCAED3CEED4ED5AL15EL6DEEL4D3L3D3L3DADDL3AADDL515PPOPPAACPPOP3APPOPOOPAPPOPO2APPOPO2APPOPO2APPOPO2APPOPO2AC2DDCEDC2DDCEDC2DDCEDC2DDCEDC2DDCEDC2DDCEDC2DDCEDC3DCED5A2D2AAPPADDAP4DAP5DAP2NOPDAPPNMMODAPPONOMDAPPNONOAADDL3AADDL3OAADL3POOL4PPOOL3OP2OOLLOOP3OLMMOOP2OL55OL454A7P6AP6A8C2DC7DC7DC7DC6EDC5EDC5EDC5EDC5EDC5EDC5EDC5EDDAPPONONDAPPNONODAPPONONDAPPNONNDAPPONONDAPPN2ODAPPAANNDAPPOPAAONMNOOPPN2MMNOPONONOMMONON4MONON12ON5ON5ONPOL5PPOOL3OP2OL2NOP3OLMMOOP2OONMNO3N2MMO2N4MMOL31OL6OOL5O3L3O4L386C6DC31D7C7L7C5ED8C5EDC5EDC5ED6EEC5EL8DAPPOPOPDAPPOPOPDAP2LOPDAPL3PDL6DL22AN3ONNOAANON2O2AN3O3AANNLO4ANLLO4AL3O3L4O2N4ANMN3AGAN3AG2ANNAG4NAG6FG5OG6OOAGFG2O6LMMO5ANMNO3GANMMO2GGAANMMOG3AANMG4FANG3FGGAL15OOL5O3L3O4L2O6LMMO5ANMO4L55OOL460OL55O3GGFGO5GFLLO4GL2O4L4O2L5OOL15G2FG5FG5FG4FOGFG2FGOOGGFFGGO3GFFGO4GGFLO4AGGANMMO2FGAANMMOG2FANNMGGFGGAANGFGGF2AFGGF4GGF5GFFMF3O2L4O4L2O5LLMMO5NNMO4AANMMO2FFAANMMOF3ANNML31OOL5O2L4O4L2O5L517O3L3P3L47OGFFM3PPGGFM2L3GF2L4GGFL6GL23MMF2AANM3F2AFFM2F6M2F5M2GGF4MLLGF4L2GGF2MMO5NNMO4AANMMO2FFANNMMOMFFAANNM2F2ANNFM2FFAAFFM2F2L7OL6O2L4O4L2O5LLMMO5NNMO4AANMMO2L47OL6O2L521GFFL5GGL47F3M2F5M2GF5MLGGF4L2GF3L3GGFFL5GFL6GFFANNMMOF2AANNM2F2ANNM2F2AAFFM2F5M3F5M2GF5MO3L3O5LLMMO4LNNMO4ANNMMO2FAANNMMOF2AN2M2FFAANNL23OL6O2L4O3L3O5LLMMO2NNL577GF5LLGGF3L3GGFFL5GFL6GL23M2F2AAFFMMF6MFFMF3MFFMMGFFMFFMMLGF3MMLLGGFFMML3GFFMNNMON2LAN4AFFAANNAGF3AAGGF3MG2F3MG2F3MG2F3MG2FL39A23L39A23L39A23L39A23L39A23L39A23L39A23L39A23L39A23L39A23L4GGFL6GL23A23F2MG2F3MG2FGGFMG2FLLGGF2GL3GGLLA23"

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
