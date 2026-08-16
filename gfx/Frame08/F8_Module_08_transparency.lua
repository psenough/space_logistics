-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_08_transparency.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000240F118OF3O3F29OOF2O4FO12NNO3NNOOF4OOF3O18NNO3NNO2N2O3NO14F7OOF4PO4P4O7P2O7P2O15F7PPF5P4F2P6FO2P3FO4PPFP2O7P2OOF47PF6O2F74AAF5AAF5AAF5AAF5AAF5AAF5AAF5AAF14OF4O2F2NNMOOFFN5FFN13ON6FFO12NO5NNO4N2MO3PPN2MO3PN4MOON5OMON2O3NO14N2O4N4O2PPN5OOP2N2O4P2O47N2O4N5O47PPO3PPO3PPO9PPO6PO4PPO3PPO3PPO3PPO3P2O2P10AAPO4FFP3O7PPO3P4OP4O2PPAAO3A4O2A2O4F7OF6O3F3O6FO11P3OOP3AOP3AOOPF5AAF5AAF5AAF5AAPPF3A3P2FAAOPA2PA3PPA3O2N4O4N2OOPO6P2O4POOPPO2PO3POOPO6PO4N4ON5ON5ON3O2N4O4NNOPO7P2O4POOPPOONNO5NNONMO2NON4MON22OON5O3N3PPN5OOP2N2O4P2NNO5N3O3N3ONNON2ON5ON4PPO3PPN2P4N2P3APPNPO19NO5PN2MOP5A4PA5OA3O3AAO3PPO3P3OP3AAOP2AO2PAAOOP3AO3P2O2P3AP3AAOOPPAAOOPPAO2P3OP23AAOOPPAO2P2AAP5AAPPAPPA2PPAPPA2P3AAOAP3AOOAP2AOAOA2PAPA4PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPAAOOPO6PO6PO6PO6PO7NNO7NNOP2O3NOPO2PO2PO2PO2PO2PO2PO2POOPPO2PONOPO2POPOPO2POPNPO2POPO6NO10N3OON7P3N2PA3PPNAP3APNAP3AAPNON5ON6O3N4O4N3O5N2PO3N3PO2N4POON3PPAAN2PPAOONNPPAPPANP2APAANPPAPA2P2APA2PPAPA3PPAPA3OOP9AP6AP2AP6A2P4A4P2OOA3OPOAOOAAOP67AOAOAPPAOAAOAPPAOAAOAPPAAO2APPA5P3A3P5AAP7AAPAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3P3A3P2FAAFPAPPO2FFPAAPPOF2PA2PF3PA2F4PPAF6PF15ONNOOPOPO2N2OP2O3NPAAPPO2PA3PPOPPA4PPFPPA3PF2P2APAPOOPAPAAPOOPAPPAPOOPAPOAPOOPAPOAPOOPAPOAPPOPAPOAP3APOAP3APOPN3POOAPNP2O2AOP2O2AOP2O2AOP2O2AOP2O2AOP2OOPAOP2OOPPAPA3PPAPA3PPAPA3PPAPA3PPAPA3PPAPA3PPAPA3PPAPA3OA2OAOPOA2OAOPOAAOAAOPOAOAAOPPOOAAOP2OA2OP2A2OP3AAOP66AAP10AP6AP9AAP3AAP3AAPPFFAAPPF3PPF5P4FAAPAPPFFA2PPF2AAPPF3AAF5AAF5AAF5AAF5AAF69PPF55AP3AP6AP2AP2APPFPAP4FFPPA3F3P2AF6PF7PAOP2OOPAOP2OOPAOP2OOPAOP3OAAOPA2P3A4PFFP2AAF5P3APA3PPAPA3PPAPA3PPAPA2OPPAPAAOP2AAPAOPAPA2P2AAPA5OP2APPAOP2APPOP12AAP3AAP3AAPPFFAAPPF3PPF5P3AAP3AAPPFFAAPPF3PPF107AAF5AAF5AAF5AAF5AAF5AAF5AAF5AAF15A47F15A47F15A47F15A47PPAPAAPPFFP3FFA47F15A47F15A47F15A47F5AAF5A49"

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
