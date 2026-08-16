-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_07_transparency.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000240F118OF3O3F29OOF2O4FO20PPF4OOF3O26PPO2P4OP14F7OOF5O4F2PN2O3PN5OPN6PN6O3N3F31O2F4NNO2PFFN4O2N7F47PF6O2F74AAF5AAF5AAF5AAF5AAF5AAF5AAF5AAF14OF4O2F2NNMOOFFN5FFN13ON6FFO20PO4P2MO4PPNNMO4N4MOON5OMO3P3OP20OOP3O4P3O6P3O6P6OOP2O4PO38P2O11NO55N7OOPN4O5NNO29PPO3PPOON2O2FFN5OON7ON6O2NNO2P2O20F7OF6O3F3NO5FO11P3OOP3AOP3AOOPF5AAF5AAF5AAF5AAPPF3A3P2FAAOPA2PA3PPA3O2N4O4N2OOPO6P2O4POOPPO2PO3POOPO6PO4N4ON5ON5ON3O2N4O4N2PO7P2O4POOPPOONNO5N3MO2N6MN23OON5O3N3OOP2O6P2O6PPNNO5N3O3N3ONNON2ON5ON4O14PPO2P2OP3O19NO5PN2MOP2OP2O3PO20PPO3P3OP3AAOP2AO2PAAOOP3O4P2O2P3AP3AAOOPPAAOOPPAO2P3OP23AAOOPPAO2P2AAP5AAPPAPPA2PPAPPA2P3AAOAP3AOOAP2AOAOA2PAPA4PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPAAOOPO6PO6PO6PO6PO7NNO7NNOP2O3NOPO3PPOPO6PO6PO5PPO6PO6PO5NPO12NP2O7PPO7P2O6PO6PO6PO6PNON5ON6O3N3O5NNPPO7PPO7PPO6POON3PPAAN2PPAOONNPPAPPANP2APAANPPAPA2P2APA2PPAPA3PPAPA3OOP9AP6AP2AP6A2P4A4P2OOA4POAOOA2P67AOAOAPPAOAAOAPPAOAAOAPPAAO2APPA5P3A3P5AAP7AAPAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3P3A3P2FAAFPAPPO2FFPAAPPOF2PA2PF3PA2F4PPAF6PF15ONNO7N2OOPPO3NNAAPPO3A3PPOOPA4PPFPPA4F2P2AAO6PO6PO6PNNO4POON2OOPPO3NNPAPPO3NA2P2O6PO6PO6POOPO3PO6PO6POONO3PO2NNOOPOOPPAPA3PPAPA3PPAPA3PPAPA3PPAPA3PPAPA3PPAPA3PPAPA3OA2OAAPOA2OAAPOAAOAAPPOAOA2PPOOA2P2OA2P3A2P4A2P66AAP10AP6AP9AAP3AAP3AAPPFFAAPPF3PPF5P4FAAPAPPFFA2PPF2AAPPF3AAF5AAF5AAF5AAF5AAF69PPF55A5P3A5FFP2A2F4PPAF6PF23O2NNPOOPPO5AAP2O2A4PPOPA5PFPPA4F2P2AAF5P3APA3PPAPA3PPAPA3PPAPA2OPPAPAAOP2AAPAOPAPA2P2AAPA6P2APPAP3APPAP12AAP3AAP3AAPPFFAAPPF3PPF5P3AAP3AAPPFFAAPPF3PPF107AAF5AAF5AAF5AAF5AAF5AAF5AAF5AAF15A47F15A47F15A47F15A47PPAPAAPPFFP3FFA47F15A47F15A47F15A47F5AAF5A49"

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
