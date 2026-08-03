-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_02.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c0002c0A124C2A44C2AC14A28C2AAC29A5CCA2C34NNC2N4CN6CBBA4C2B3AC4NNBC2N4CN12CCN3C3NC5DA15BBA5NNB3AANC3B2C2D3BCDDB3CDBBC4A31BA6B4A2C5BBC7A55CCBBA138CA5CMA4CDDA3CD2A2CD3AACD4AACD4ACDDCCDDC7MDC5DM2C3D3M2CD6MD22MC28N2M2N4DM4NNM12D2C5NNC2N18CCN2C10DDMCCD2BBDMMB2CCN5CCN3C3NC4DDC2D2BBCDDB2CCDBBC4BC18D2BCD2B2CDB2C3BC13BC4BBC3BBC4BC4BC12BBC3BBC3BBC3BBC11PPC2P2BBCPPB4C7B7C3PPBBCCPPB3PPB11AAB3AAPPBA2P3B2IBBAABI4BABI5B5I2A2B2IIP2AB2IPAPPAC2PAPBC3A23BA6IBA5IIBA4B2A4CCB2A67CDDCDC3PDCD2CCPOCBBDCCPOCPJBCCPOCPJKCCPOCPJKCCPOCPJKCCPOCPJKD5MMCCD2M2DDCCM3BDDM4KBBM4K2B2MDK4JBBK4JKKM3D3M2D4MMD5MD5C2D3CD2CCDCD5C2DB2CD2CDDCMMC2DCD2M2CD29CD5CDCD3CDDC15MMC5DCMMC4D2MMBBD4CCPD3CCPJD2CCPJJCCBC3PCCBCCPPBCCBPPB10DDB3AAPDBBAAP2CBBAPPAPCBBAPPAPB5AB4AAPBBA2P2AAP12APPAPPAACPPA2C2PAC5AP4AP6AP3A2CCPA2C3AC12BBC3B3CCB5PABC18BBC2B4CB5AB4A2B2A10PPC3B2AB17A3BBA3PPA3PPAAP4A2PAPPA3PA16BBA5B3A4B2A5BBA3PABBA3PPBBA3C2PCPJJAAC2P2AAPPC3AAP2ACCAAPOOAOPAAPOOAOPAAPO2AOAAPO3AJK3JKKJ2KKJKKPPJ3KKCCPPJ3PCNNP2JP2N2CPOP3NCCAOOP3CK2BBD2K3JBBDK3JKKBK3JK2JJKKJK2PJ3K2CPPJ3KC2PPJ2DC3D5C2DDBBCD2CCKKBBD2CK3BBPCK5PCK5PCJK4PCDDCCPJ2DCCPJ3CCPJ4CPJ4PBIIJ2PDBJJIJPDBBJ2PDB2J2PCBAPCBBAPPCJPB2C2PCBBC3DBBPC3BBADMCB2AD3BBAD3B2D4BBAC6BC4B2CCB12AB3A3BBA4PA4P2AAP5B5AAB2A4BA4PPA3P3AAP21AP6A2P4AP4AP6AP23AP6AP5AOPPA3PAPA4PAPA4PA2OA2PAAOOA2PAOAOA2PAOAOA2PA2OA2PAPPBBA3PPA5PPA5PPA5PPA5PPA5PPA5PPA7P2OOA3PAPPA4PAAPA3PPA7PPA26OOP5AAOOPAP3AAOAAP5A3P5A3PPAAP2A7PPAPC3P5C4OP3C2AO2P5AAOOP6AOOAP5A3P4J2K2PCPPJ2KPC2PPJJPC4P2CPPC5P3C3OOP2C2PAOOPC2BJ2PCBPBJ2PCBPBJ2PCBPBJ2PCBPBJ2PCBPBPJJPCBPBCP2CBPB2CPCBPD3B2ACCDB2AAC2B2AACCB2PAACCBBPPAPCCBBPPAPCCBBPPAPCCBBPPAPAPPAP3APA2P3A5PPA10OOA5OAOOA3OA6OA3P22AP6A2P4A2P4OAAP4OAAP10AOP5AAP5AAP38A2OA2PAO2A2PA6PA6PAPPA3P5AAP14AP3A5PPA5PPA5PPA5PPA5PA6PA85PA55PA4PPAPPA7P2A7PPA31P2APPCCP3APCCAAPPAPPCA6P2A7P2A7PPA7PB4CBPB6PC2B3P2C2BPA2PPCCPA4P2A6PAPA6CCBBPPAPCCBBPAAP2BBPAAP2BBPAAPO3PPAPO3PPAPO3PPAPO3PPAPA3OAAOA3OAOA4OOA5OA9PA6PA5PPA4P2AAP5AAP5AP31AP6AP3AAP6AP21AAP3AAP3AAPPA3PPA3PPA5P3APPAPPAAPPA3PPA3PPA358PPA3PA2P2A7PPA39PO2PPAPAPPOPPAPA2P2AP2AAPPA3PPAPA5P2A6PPA12P2A2OP3AAOP5AOP2A2P2AAPPA3PPA3PPA3PPA5P3AAP3AAPPA3PPA3PPA229"

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
