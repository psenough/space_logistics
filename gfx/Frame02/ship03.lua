-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame02\\ship03.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000240A30PA5PA5PA5PAAHA2PPAHA3P3AAPPAH2APAAHA5HAH2AAHAH2AMHAHGGAEMAHGGAEMMHGGAEM2EA6NEA5NNEA4N2EA3MN2EA2MMN2EAAM2N2EAM3N2EA385PPAHAHAPPAHAHGPPAHA3PA4DNNPA4DNBBPDP2NBPBPDA2NBPBPDAGGAEM3GAEM4AEM3EENNM2E2N2ME3D3E3AD3E2AAD3EEM4NNDM5NDE3M2E4M2E12MEME4MEME4MEMEEA6DEA5DDEA4EDDEA3EEDDEA2E2DDEAAE3DDEAE4DDEA321NBPBPA3NBPBA4NBA6NPA6PPA5NPA6NA10D3EADEAD3ADEEAD2ADE2ADDPPDE2ADPPADE2AP2ADE2NP2ADE5MEME4MEMEDE2MEMEDDEEMEMED2EMEMED3MEMEAD2NEMEEADDNDE7DDE6DE48A6DEA5DDEA4EDDEA3EEDDEA2E2DDEAAE3DDEAE4DDEA320NP3DEAANPPA6NB2A4NBPA5NBA6NA15EEADNDNEA3NDNDPDA2DNDBPDA2NDPBPDA2DBPBPDA2NBPBPDA2NBPBPDAE15DE6DDE5D2E4D3E3AD3E2AAD3E7DDE6DE48A6DEA5DDEA4EDDEA3EEDDEA2E2DDEAAE3DDEAE4DDEA321NBPBPDA2NBPBPA3NBPBA4NBPA5NBA4PA5PA5PA6D3EDA2D3PDA2D2BPDA2DDBBP4DA4PPA6PPA4OOPE15DE6DDE5D2E4D3E3AD3E2PAD3E7DDE6DE13ME5M2E3M2E3M2E3M2EMEEA6DEA5DDEA4EDDMA3EENNMA2EMMNDEAAM2EDDEAEME2DDEA222PA5PA6PA6NA5NA3PA3PAPA3PDPA3PDDA3PD2A2PD2EAAPD2EEAPD2E2PD2E3D2EO3DDEMEO2DEM2EOOEM4EOE10M4E2M4E6APPAD3EOPPAD3OOPPAD2O2PPADDOPOOPPADAPPOOPPA2PPOOPPA3O2PEM2E2MEEM2EMMDEEM3EDDEEMMEED2E4D3E2DAD3EDEPADE8DEDDE2DE2DEEDE5DE5DE5DE5DE5DE5DE3A6DEA5DEA5DEA5EEA5E2A4E3A3E4A134NAAPA3NAPPA4NBPA5NBA6NA23D2E4D2E4BD2E3PBD2E2BPBD2EENBPBD2EANBPBD2AANNBPDAE5AAEEDDEAADEDEEAAD2EEAAD2EEAAD2EEAAD2EEAAD2E2AD2E3D2EO3DDEMEO2DEM2EOOEM4EOE10M4E2M4E6APPAD3EOPPAD3OOPPAD2O2PPADEOPOOPPADAPPOOPPA2PPOOPPA3O2PE2DE5DE4DDE13D2E4D3E3AD3E2PAD3E7AAE5AAE5AAE5AAE5AAE5AAE5AAE5A207PPA4NBPA5NBA6NA23D2E4D2E4BD2E3PBD2E2BPBD2EENBPBD2EANBPBD2AANNPPDAE5AAEEDDEAADEDEEAADADEEAADADEEAADADEEAADADEEAADADE2ADADE3D2EO3ADEMEO2DEM2EOOEM4EOE10M4E2M4E6APPAD3EOP2D3OOPPAD2O2PPADDOPOOPPADAPPOOPPA2PPOOPPA3O2PE5AAE5AADE4AADDE3AOD2E2AOD3EEAOAD3EAOPAD2AAOA31OA6OA6OA6OA212PPA4NBPA5NBA6NA23DADE4D2E4BD2E3PBD2E2BPBD2EENBPBD2EANBPBD2AANNPPDAE5AAEEDDEAADEDEEAAD2EEAAD2EEAAD2EEAAD2EEAAD2E2AD2E3D2EO3DDEMEO2DEM2EOOEM4EOE10M4E2M4E6APA5OOPA3PO2PAAOPO3POOPO4POPOAAO2PPOA2O2POA3O4A6OA6OA6OA6OA6OA6OA6OA276PPA4NBPA5NBA6NA23D2E4D2E4BD2E3PBD2E2BPBD2EENBPBD2EANBPBD2AANNPPDAE5AAEEDDEAADEDEEAAD2EEAAD2EEAAD2EEAAD2EEAAD2E2AD2E3D2EO3DDEMEO2DEM2EOOEM4EOE10M4E2M4E6AOA6OA6OA6OA372PPA4NBPA5NBA6NA23D2E4D2E4BD2E3PBD2E2BPBD2EENBPBD2EANBPBD2AANNPPDAE5AAEEDDEA2EDEEA3DEEA4EEA5EA86"

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
