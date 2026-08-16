-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_09.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000280A118CA3C3A29CCA3C3AC4PPC3P3CP5BA5CCA3C3AC3P2C2P4CP5BP3B2OPPBBO3BBO5CCP2A2P5AAP6APB4PABOOB2PAO5BAO2NNO2P3N3A47OA2C3OOC3PPA47P2A4P3A210CA4C2A3C3A2DDCPPAAD2P2AD3PPBAD2PPBBAC5PC4P2CCP11BBP2B2OOPBBO4BO5PNMO5P4BBOP2BBO2B2O10PPO2P4OP13COP3C2O5PPO2P4OP13CP4C2PPC4PC4P2C2P9NNCP3C3PPC4PC3P3CCP29C2P4CP29NP4BBNP2BBO2B2O2PCP4A2PB2PA2PO2PA2N3O2AN6CN3C3OC4PPC3P3A24C3P2C2P16B3PPBBNO2A31PA6PPA5BPA5O2A68D2PPBNND2PPBNNCDPPBN2CCPPBN2CCPPBOONCCPPBO2CCPPBO2CCPPBOON4MO2N5MON22DN6DO3NNDDPPO3DDOOPC4OOC3PPNDDCP3D2P3BD2PPBBODDPPBBNNDPPBN3DPPBN3P23BOOP2BBO5PPMO6N2MO2CN5DDP4B2P2BBO2B2O3CO3C3POC10P2C2P4CP4BBO3C3OOC4PC3P3CCP11BBP2B2OOPBBO4BO6CP5BP4BBOPPB2O2BBO18NOPO2NP3ONP3AABBO12NO4NPPO2NP3NP3AAOP2AO2PAAOOP3OOP3APO3PPAAP3AAP3AOOPA2OOPAAPPOPPA2PAPPA3PAPPA3PAPA4PA8PA7PA13PA6PPA5PPA5PPA5CCPPBOONCCPPBOONCCPPBOONCCPPBOONCCPPBOONCCPPBOONCCPPBOONCCPPBOONP3OOCDP2OPPCCP2O2CCP2O2CCP2O2CCP2O2CCP2O2CCP2O2CCPPBN4PPBON3PPBO2NNPPBO4PPBP2OOPPBPOOP3BPO3PPBPO3N4D2N3D3N3D2PN2D2PPO2D2PPO2CDPPBPPOCCPPBOOPCCPPBP3BBOOPPBBO3PBBNNO2BN5MBN13PN5PPOON2P2O4N2O2NNP2ONNP3ANP2AAOOPPAAOOP2AOOP3APPAP3APA2P6AO2PAAOOP2O2P20AP6AP20AP23AP6AP5AOP5AOP5AAPA4PA2OA2PAAOOA2PAOAOA2PAOAOA2PA2OA2PA2OA2PAO2A2PAPPA5PPA5PPA5PPA5PPA5PPA5PPA5PPA5CCPPBOONCCPPBO2CCPPBO2CCPPBO2CCPPBA2CCPPBPAABCAPPBPAABAP2BAP4OCCP5CCOP4CCO3PPCCO5CCAPPO2CCA2P2CCA5CCPPBPO3PPBPO3PPBPO3PPBO4PPBP2OOPPBP6BP6BO2PPO2CCPPBO2CCPPBO2CCPPBO2CCPPBO2CCPPBPOOCCPPBP2CCPPBP2CCPPBO3NPPAPO2P2AOPOOPPAPOPOOPPAPOPOOPPAPOPOOPPAPOPOOPPAPOPOOPPAPPA5PPA10OOA5OAOOA3OA6OA6OAAOA3OAOAP7AP6A2P4A2P4OAAP4OAAP4AAP5AAP11AAP38AP6AP7A5PA6PAPPA3P5AAP14AP5APPAPPAAPPAAPPA5PPA5PPA5PA6PA32BBP2BA3BP2A4BPPA5BPA32PPA2CCB2PPACCPB3PCCPPA3CCA5BCA6BA15PPBO4PPBPPO2PPBAAPPOPPBPA2PAPPBPA3P2BPAABBP2BPPAABP2BBP2CCPPBOOPCCPPBO2CCPPBPPOCCPPBAAPCCPPBA2CCPPBPAACCPPBBPPCCPPBOPOOPPAP2OOPPAP2OOPPAP2OOPPAPOPOOPPAPO3PPAPPO2PPAPAPPOPPAPA3OOA5OA9PA6PA5PPA4P2A4P2A2OP3AP31AP6AP3AAP3AAP3AAPPAAP13AAP3AAP3AAPPA3PPA3PPA23PPA3PPA248BP2BA3BP2A47B2CCPPB4CP2A3BAPPA4BBPA6BA23PAAP2APBPAAPPAAPBA2PAAPPBPAAPAP2BPPAPBP2BBPPABP2BBA10OP5AOP2A2P2AAPPA3PPA3PPA3PPA23PPA3PPA245"

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
