-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame01\\Door.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c0002c0IIA7I2A7I2A63I3A34DA55DA589DA6DA6DA6DA6DA6DA6DA7D3A3D3A3D4A2D2ADA2D2ADDAAD2ADDEED2AD6AD3A47E2A4D2E3A184IA391DDAD3AADAD3AADAD3AADAD3AADAD3AADAD3AADAD3ADDAD8E2D22ED5ED5EDED3EDEED2EDEDE2A5DEMEEA2EDMEEMMEDEMEEMME2MEEMME2MEEMME2MEEMMEDEMEEMMEA15EA6EEMA4EEM2A2EEM5EEM5EEM5A2IA43M3A3M6A27I2A4D2IIAAD2A3D2MA2D2MMA56IA7IA55IIA198DDAD3ADDAD3ADDAD3AADAD3AADADDEDAADAD4ADADDEDDADAED4EDE2DDEDEDEDEEDE5DEDEDEDEEDEDE2DDEDEDEDEEDEDE3DEDEDEDE2MEEMMEDEMEEMME2MEEMMEDEMEEMME2MEEMMEDEMEEMME2MEEMMEDEMEEMME2M5EEM5EEM5EEM5EEM5EEM5EEM5EEM74A2M4A2M4A2M4A2M4A2M5AAM6AM7A65I2A7I2A63IIA173DADADDEDDADAD4ADAEDEDDADAD4ADADDEDDADAED3ADADDEDDADAD5EDE3DEDEDEDEEDE5DEDEDEDE3DE3DEDEDE3DE4DDEDED2E2MEEMMEDEMEEMME2MEEMMDEEMEEDDMEEMDDE2D2M4DE17M4EDM8E2M2E4ME8ME7M2E7M2EM31E3M4EMEMEMME9MEMEMEM46AEEM4AMEMEM2A271DA5DDA5DDA5DDA5DDA5DDA6DDADAEDEDDADAD4ADAD4ADAED3AD6A2D4A4D4A4E2DDEED3EDEDEDDE2DEEDEDEDEDEDDEDEDED5EDED15E7DEDEDE3DE5DEDEDEDEEDEDE2DDEDEDEDEEDEDEDEDDED2EDDE6ME15DE14DEDEDE7DEEDEDEDEDEMME7M2E7M2E31DEDE11AME2MEEAE7M2E7M2E7MME14A323DDA7DDA7DA42D4A4D4A4DAADDA7DDA7DDA15D3EDED7ED7AAD5A3D4A5DADDA7DDA2EDEDE2DDEDEDEDEDDEDEDED5ED7ED8AD6A2D4E7DEDEDEDEEDE5DEDEDEDEEDEDEDEEDEDEDEDEDDEDEDED5EDE7AE6AE6ADEDEDEEAE6ADEDEDEDAEDE4ADEDEDEDA9DA6DA6DA6DA6DA6DA6DA394DDA7DA53D3A7DDA7DDA7DDA23D15AAD5A3D4A4DDADDA7DDA7D2EDEDEDEAD2EDEDAD3EDEAD6AD6AAD5A3D3A5DDAADA6DA6DA6DA6DA6DA6DA6DA581DDA7DDA7D2A7DA32DA6DDA5DDA4D2A5DDA5DDA6DA140"

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
