-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\gfx\Frame03\\BgDitterBottom.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000300A629PA28PAPA12PA10PAPA2PA8PA30PA14PA562PA12PA2PA12PA10PAPAPAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPA2PA8PA30PA14PA452PA28PAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPAPAPA8PA14PA14PA14PA370PA12PA2PA12PA10PAPAPAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPAPAPA8PA2PA10PAPAPAPA8PAPAPA8PAPAPAPAPA4PAAPPA2PA10PAPAPAPA3PA3PAPAPAPA2PA4PAPAPAPAPA2PAAPPA14PA6PA6PA14PA6PA252PA18PA6PAPAPA8PA2PA10PAPA2PA8PA2PA4PA4PAPAPAPA8PA2PA10PAPA2PA8PA2PA10PAPAPAPA8PA2PA10PAPAPAPA8PA2PAPA8PAPAPAPA8PAPAPA10PAPAPAPA4PAAPPA2PAPA8PAPAPAPA3PA3PAPAPAPA2PA2PAPAPAPAPA4PAAPPAPAPAPA2PA2PAPAPAPAPAPAAPA3PAPAPAPA2PA2PAPAPAPAPA4PAAPPAPAPAPA2PAPAPAPAPAPAPAPAAPPA2PAPAPAPA2PA2PAPAPAPAPAPAAP2APPA14PA6PA6PA6PPA5PA6PPA155PA12PA10PAPA2PA12PA4PA4PAPAPAPA8PA2PA10PAPA2PA8PA2PA4PA4PAPAPAPA8PA2PA10PAPAPAPA8PA2PA4PA4PAPAPAPA8PAPAPA10PAPAPAPA8PA2PAPA2PA4PAPAPAPA8PAPAPAPA6PAPAPAPAPA4PAAPPAPAPAPA2PA2PAPAPAPAPA3PA3PAPAPAPA2PA2PAPAPAPAPA4PAAPPAPAPAPA2PA2PAPAPAPAPA3PA3PAPAPAPA2PA2PAPAPAPAPA4PPAPPAPAPAPA2PA2PAPAPAPAPAPAAPAPAPPAPAPAPAAP2AP3APAPAPPAPAP2APPAPAPAPAAP7AP2AP3AP2APPAPAPAPAAP2AP3APAPAP3AP2APPA6PPA5PA6PPA5PA6PPA5PA6PPA55PA2PA18PA6PAPAPA8PA2PA8PAPAPA2PA8PA2PA4PA4PAPAPAPA8PA2PA8PAPAPA2PA8PA2PA4PA4PAPAPAPA8PA2PA8PAPAPAPAPA8PA2PA4PA4PAPAPAPA8PAPAPAPA6PAPAPAPAPA4PA2PA2PAPA2PA2PAPAPAPAPA8PAPAPAPA2PA2PAPAPAPAPA4PA2PAPAPAPA2PA2PAPAPAPAPA3PA3PAPAPAPA2PA2PAPAPAPAPA4PAAPPAPAPAPA2PA2PAPAPAPAPA3PAPAPPAPAPAPAAP2AP3APAPAPPAPAP2APPAPAPAPAAPPAAP3AP2AP3APAPAPPAPAPAPAAP2AP3APAPAPPAPAP2APPAPAPAPAAP2AP3AP2AP3AP2APPAPAPAPAP3AP3APAPAP3AP2APPAPAPAPAAP7AP2AP3AP2APPAPAPAP10AP14A6PPA5PA6PPA5PPA5PPA5PPA5PPA5PA2PA4PA52PA2PA4PA52PA2PA4PA52PA2PAPA2PA2PA48PA2PAPA2PA2PA48PAPAPAPA2PA2PA48PAPAPAPA2PAAP2A47PAPAPAPAAP2AP2A47PAPAPAPAAP6A47PAPAP11A47P15A47PPA5PPA53"

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
