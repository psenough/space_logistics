-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame05\\F5_Ship01_transparency.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000340F211C3FFI5FFIP3AFFIPPI2F4IAAF4IAAFFD13C7I7A7I7A6IA6ID6CD3C2DC7I7A9I5AAIA6IA4CD14C7I7A7I4AAIA3IAAIA3IAAID2CCD2C2D4C7I7A7I6OA5IOA5IOD14EC3E3IOOCE3IOOCE3IOOCE3IOI6OOA4DE46I7A6OEDEEMF2EEDEEMFFEEDEEMFFEEDEEMIIEEDEEMOOEDE2OI5AO10F23I7O7I7O7IOIOIO2F3A3F3A3F3A3IF2A3O2FA3I3A3O3A3O3A3F30DF5DCF4DCAF4DCAF4DCIF5DDF2N4D7C7A7B7I7B6ID7N7D7C7A7B7I7B7D6CN3C2ND2CD3C7A7B7I7B4IBBCCD5N7D7C7A7B7I7B7D4C2NNC2N2DCD5C7A7B7I7B7D7N7D7C7A7B7I7B7D7N7D6EC5EEA5CEB2I2ACIIO3ICBO4ICD4E2DDE5MMDE3DEMMDE2DEEMMDEEDE2MMDE4MMDE4MMDE17DE3MEEDDE3MEDI5E40DDE3MED2E3MDDI5E24DE3MOEEDE3MEEDE3MEEDE3MEEDE3MEEDE3MEEDE3MEEDE3MO3A3O3A3O3A3O3A3O3A3O3A3O2FA3O2FA3F4DIIF4DIIF4AIIF5AAF6DF5DIF4DIAF2D4I15A2P2A9D7I7PAAPAAPAD7I15AP2A2PA7D7I7APAAPAAPD7I15PPA2P2A7D7I7AAPAAPAAD7I15A2P2A9D7I7PAAPAAPAD7I15AP2A2PA7D7I7APAAPAAPD7I14OPPAAIIOOA5IID6EI6DAAPAAPAID3E3O5ICO5ICO5IIA7EM3E4M3EEOOPN3PE3M3E2MMDE4MMDEEI7A7E15OPOPOPOPE17IDE2I8A2I4E15OPOPOPOPE15DE6I2E4I7E15OPOPOPPE5MPPEEDE3MEDE4ODE4OOI4O2EEAIIO2EEAI4E2IIF2E2F4OOFFA3OOFFA3OOFFA3OOFFA3OOFFA3IF2A3F3A3F3A3FDDC4DDCCPPAADCPPAAPPDCPPIPIIDCPPIPAADCPPIPAIDCPPIP2DCPPBPJJC7A7P7I7A7I7P7JKJKJKKJC7A7P7I7A7I7P7K7C7A7P7I7A7I7P7KKLK4C7A7P7I7A7I5OOP5OOKL3POOC7A7P7I7A8I6AB6OAI5C3DE2A3CDEEP2AACDEI4CDEA3ICDEI2AICDEB2AICDEI3ACDE4M3E3M3E3M3E3M3EEDDM3EEDEM3EEDEM3EEDEM3E31D7E9M2EEMEEME3ME31D7E7MMEM2EMEMEEMEEME5MPE6ME6ME6MD5EME5M3E4ME6ME2F4E2F4E2F4E2F40A3F3A3F3A3F3A3F3A3F3A3F3A3F3A3DCPPIPIJDCPPAIBIDCPPAIAIDCPPAIAAFA3IAAF4AIIF5AAF6AJJKJKJKKJ2KJKJKIJ2KJKJBIJ2KJKAAIJ2KJI3J2KIA2IJ2I5JJLKLKL3KLKLKL2KKLKLKLLJKKLKLKLKJKKLKLKJKJKKLKLKJKJK3JKJKJK2LKKM4LLKLMLML2KLLMLMLLKL2ML2KL3MKLKL5KKL4K6LKKM3IOMKL4IMKLM5KLM5KLM5KLM5KLM5KLM4OIAB4OIIAI7AB2MI3AIIMMI3AAM2I4M3IA2M4IIAB3ICDEI4CDEB4CDEI4CDEA6I8A7I7EEDEM3EEDEM3EEDEM3EEDEM3IIAEM3IIAI4A2IIO2I3O3EEME3MEEMEMMEMEEMEEMEMEEM2EEME7I7O15EMEEMEEM2EEMEEMEMEEMEEMEMEEMEEME7I5FFO4F2O3F3E6MME5FE6FMME3FFE5F93A3F3A3F3A3F3A3F3A3F3A3F3A3F3A3F6AF47A7DA4IJDCA4IDCCA3IFDCA4FFDC3AF2D3CF6DA7JJKJKJKKJ7I7A15C7D7A7K7J7I7A15C7D7A7MLLM4J7I7A15C7D7A7M5IAJ5AAI7A14C7D8A7IA6IA2CDEEIAACDE2A2CD3C2DE3D15A15E4DE5DE2D3ED2EEDE4DDED6ED4A15E15D7E6FD3F11A10F4EEF5EF38A7F55A7F55A7F3A3F3A3F3A3F3A3F3A3F3A3F3A11"

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
