-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame04\\F4_Ship01.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000140A133PPA4PPDA3PIDDA3PI2A2PIIJPA2PIJJPA2PIJPPAAPPIJP2J2PIPPD6ID5IEI6EP3JIJEP3JJEJP2JJIJLP2JJKLLP3A3EJJPPA2EJLJ2AAJLLKJJAAJL2JJAAL2KJA2LLKJJA2LKLJJA121PA6PAAPIIJ2AAPIJ3APPIJ3APIN4PPN5PIN5PIJ5IJN5J4KLLJ3IL2J3KL2N2OMMLKN2OM2LNNOM4JJKLM3JIKLLM2LLKJA3LKJJA3KLJJA3LJJA4KJJA4KJA5MJA5JA77PA5PPA5PIA4PPIA4PIJA4PIJA3PPIJA3PIJIIJJNNJ2IJ29IIJ5KJ5IKJJIJ2IKJKJLLKMMIKL3KMKKL2KKJKJLLKLKJKLLKLKKAKLKLKKJAL2K2JALLKLKKAAJA6JA90P3A2PJ3AAPJ3KAPJ4KA3PIIJA2PPIJIA2PIJIJAAPPIPJIP3IPIPKPPIJIJIOPIPIPIPIIJIJIJIIJ4KJJIJJIIKLIJIJJKKLJIJPPKILIPIPPKIIJIJPKKJIIPIPKJJPPIPPKJPPLKLKKJAALLK2JAALKLKKA2KLKKJA2LK2P3IIP2J2PIIPJ3P2J4A31PPA5JLPA4JLLJA3L3JA3PJ3KOAPJ2KOIPN3KOIPN2KOIP4JOIPPELLPJOPE2LLPPOAAEELMPPIPIPIPIPPIPIPIPIPPIPIPIP17O6P7OP2O3IPIKKJP2IPKJJPPIPKKJJP3KJJP5JJP2OOP13O4P5J4P2J4PPN4LPPN4MP4JMMPPEELPJMPPEELMJMAPEELMPJLLKLJA2LKLKLJAAKLKLKJAALKLKJA2KLKKJA2MKKJA3MKKJA3MMKJA6EELMPA3EELPA3EELLA4P2A31JJP5JPPA4PPA5PA38P6A57PAEELMPA3ELLPA3EELLA4P2A31MMJA4JMJA4PJA5PA38"

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
