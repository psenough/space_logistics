-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_06.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c0002c0A181CCA3C3A29CCA2C18BBC2B2PJA5CCA2C19BC3B2PB2P6J2P2JPJ3PPA7C2BA3CB2A3B4A2PB3A2PPB3AAPPBCCB2PC4ABA55BA301CA4C2A2DC3AADMMDCCA11C3AAPM2DCACD3MMPD14CCD5CDDBBD2C13BBC2B2PJMBBPPJPJDPJ3PJDPJ3PJDPJ2P2DPJPPC2B2PPJ2PPJJPJ6PJ6P3JJP2CCDPPCD3C2D2A2D2AAB2JPJ2PPCJP3C2PPC2DDACCDDA2BDDAAB3AAB2O2B2O3PO3P3C2A4DAAB2OOAB2O3BBO3PNO3P2NOP5NP6NP5OOBA6BA6O2A4NNO3AAN4O2N15OON5A31OA6O3A3N2O2AAN5OOA55OA135D4MMAD14C2D4C5DBC23DBBC4DBDMMC2BD3MMCBD5MD15CCD5C4DDBDPPC3DC5AAC3AABBMA2B2ODABBNNMOABBNNMNNBBN4MBN6DAAB2OOB3O2PBO3P2O2P4O3P3MO5PN2MO3NNMNNMO3P20OP3O3PPO4P3O3POOP3O6P6O2PPO5PO15PPO5PPO21PO4NNPO54N7ON6O3N3P2O4P2O10PPO3PPO3PPO3NO2A3N3O2AN5OON6OONNO4PO20PPA15OOA5O4A2O5PPOOP3AAP3AOOP2AOOPA41P2A7PA3PPA5C3D3C2DC5DCCPOC2BCPO2CCBCPO2CCBCPO2CCBCPO2CCBCCPOODC5ADDC4BCDDC3BCCDDC2BOCBBC2BOCDDC2BOCBBC2BOCBBC2ABN6BO2N3BO4NNBO6BO6BO4POBO4POBO4PON23ON6O2N4O5NNO23N2O4NNONNO2N3MN9ON15OON5P2O3POOP2OOPO3P3O5PPNNO5N4O2N3ONNON7PO5PPO3PPOPOP2O2PPO20PO4P2NOOP2AAPPO19PPO3P3OOP3AOP2AAOOPPAO2P2OOP5O2P3AOP3AOOPPAAOOPPAAOOP3OOP29AOOPPA2OP2A3P3A4PPA5PPA4PPAAOA2PPAOOA2PAOAOA2PAPA4PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3C2BCCPOAACCBC2AAPPCB2A3P2CAAPA3PA2PPA7PPA7PCCBBC2ACBBC3B2C4BC5BBPOC2BBOAP2O3A3PPOOPA4PPBO4POBO4POBO4PO6PO2PO2PO2P2O5P3O6PPO4POPO4PO6PO6PO6PO6PO6POOPPO10N2O6NO47N15OON5O3N2PO5NPO5PPOPO3PPO2POOPPNOPPAAOOP2AOOP3APPAP3APA2PPAPA4PAPA5PA3OOAPA3OAP9AP6AP12AP6A2P4A4P2OOA2P67AOAOA3OAAOA3OAAOA4O2A10PPA5P3A3P5AAPAPPA3PAPPA3PAPPA3PAPPA3PAPPA3PAPPA3P3A3P2A69P2A7PPA7PPA39P2O4A2PPO2A4P5A7PPA7PPA7PA7P3OP2O2P4O4P4O5AAPPO3A3P2OPA5PAP2A3O7PPAO4PPA2O2PPA5OOPPA3O3P2APO5PAP2O6POOPPO2POOPPO2POOPPO2POOPPAAOPOOPPAAPPOOP5OOPPOP2OOPPAPA3OAAPA3OAAPA3OAAPA3OAAPA3OOAPA3OAAPA6PA7OAAP2AAOAAP2AOAAP3OA2P3A2P4AAP5AP6AP60AAP3AAP10AP4APAP3AP4AAP3AAPPA3PPA3PPA13P2A4PPA5PA242PPA7PPA51PPOOA5P4A7PPA7PPA7PA15O2POOPPO5P4O2PPA2PPOPPA4P3A4PPAP2A2PA3PPA2PA6PA4PAPA4PAPA2OPPAPAAOP2AAPAOP2A2P2AAPA4P4AP6AP9AAP3AAP3AAPPA3PPA3PPA13PPAAPPA3PPA3PPA499PPA56PAAPPAAP3A307"

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
