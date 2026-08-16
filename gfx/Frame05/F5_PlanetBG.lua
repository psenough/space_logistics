-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame05\\F5_PlanetBG.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000200A245GGA3GGHHA29GGA2G3HG4H2GH7GGHGHGHA12G2AG10HHGH13P2HPHP2HP2GP4A3G5HHGHGH7PHHGHGHGH3PHPHPHPGPHPGPPHHPHPHPHPHP2APG2A4HHGA4HPHA4PHGA4HPHA4HPPA4P2A4PPA163GGA4GHHA2GGH2AAGGH3AGH5A2G4AGGHG5HG2HPHG2H4GH2PHPH10P2HPHPHP4GHHPHPHPHHGHP3HPHP2HP5H3PH3PPH3PPAP10AP2APHPHPHPH2P2HPHP2HPPHPH3P2AP7HAPA5PPAPAPA9HHPHP3APAPAPAPPHPHPHAHHPAPHA3HAHA2HA8HA2PA9P2A5PA6HA30HA92GA5GHA4GHHA3GH2A2GGH2A2GH3AAGH4GH11PHPH7PHHPHPHPHPH3PH5P2H3PHPPH3P3H3PH3PHP2APPH2PHPHHP7HPHPHPHP5APPHPHPHPAP3HPAP3HPHAP2APAP3HPHPPAPAPA2PAPAHAHAPAPAPAPAPA2HA3PPA7P5AP5A7PAAP2A4PPAAPAAPA2PA3P2A15PAPAPA8PA2PA12PA2PA12PA26PA30PA44GA5GHA5GHA4GHHA3GH2AGH5GGH5GH2PH5P2H4PH5PPHPH2PHHPHP3HPHP2H5PHHP2HP7HP6HP5HHPPH4PAPPHHP3AP3APAPPHPHAHAP2APAPAAP2AAPA2PAPA4PAPA2PAPAPA3PPA4PAPAPA2PA2PA2PA47PA9PA2PA30PA26PA2PA30PA40PA48GH3A2GH3AAGH4AAGH4AGHHP3AHHP4AGP5GHP4HHPPHHP2HP2HP10HP6HHPHP2HHP6HHPHPHPAHP10APAP4APAP3APPAAPPAPAPAPPAPHA2HPPAPAPAPPHA2HA2PAPAPAPA2PAAPPAPAP4AHAP2A2PA14PAPA12PA261HHP4HA55HHPHPHPHA55PAAHAHAPA375"

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
