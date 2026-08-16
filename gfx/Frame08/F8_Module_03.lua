-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_03.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000340A174CA2C12A28C2AAC29A5CCA2C34NNC2N4CN6CBBA4C2B3AC5NBC2N4CN12CCN3C3NC5DA15BBA5NNB3AANNC3BBC3D2BCD2B3DB6A39BA6BBA5B2A347CA4C2A2C4AACDMMCCAACD2MMACD5A4C2AAC42N2M2N4C28N2C2N18CCN2C10NNC2N18CCN2C10DDC2D2BBD2B4N5CCN3C3NC4DDC2D2BBCDDB4DB3C2B2C9D2C3D2BCD2B3DB4CCB2C11DC3D2CCD2C3DC6B2C3BBC11BBC2DDCCBBDDC27B3A5CCB2A2C4B3C6B3C5B3CCB7C7A23BBA5CCB2A2C4B3CB11PPA39BA6B2A4PCCB2A194CD5C2D4C4D2C17BC6BC6BC4D2M2NNDDM5DDM3D2M4DDCNM2D2CN3D2CN3CCDCN3C7D2C2DDB2MMDB3CD2BBMMCDDB2DDMDDBBD4B2D4BBD4B4C2BBC21MC6DM2C3D3M3D6MC3D3C2D4C4D2C23MC6M2C4MMC5DDM2C2D4M2D7CCD5C4D2C6DC11BBC4BC6BC3MMCBC3DDMBMC2DDCDDM2DCD5BD6C47MMC5D4C4BP2C6B2C6BCN2C4N5CCN3C3NNC2BBC3B3C5B2C6B2C8BC5B3CB21CCBA6CBBA4C2B2AAC5BBC6BBC3B3CCB4CB4A25BA6B2A4B3A3B5A3B5A63C27PPC5P3C3PAOPC3PAOOC3PAOOCN3C3N3C3N3C3N3C3N3C3N3C3N3C3N3C2DBBCD4BBC3DDBBC4DBBC4DBBC4DBBC4DBBC4DBBC4D15CD6C3D3C5DDC23DM4CCD3M3D6MD15CD6C2D3BC5BBC5BBC3B2PMMB2PPCDBBPPC2BBPDMMCCBPD3MMBPD5PD6BD14CCD5C3D3C6DMC6DM2C3D3MMCCD6CD14BD6BD5BBCCD3BBC3DBC4BCCBBCCB20CB4CCB3CCB2C2B3AB4A2B2A4B3CCB3CCB3CCB4AB3A3BBA4PA4P2AAP13B2A4BA4PPA3P2A2P3AAP5AAPPAPPA2PPAPPA2P3AAOAPPA2B2AAPPAABBAAPAPABBAAPAPPBBAAPAPPBBAAPAPPBBAAPAPPBBAAPAPPB2A6BA6BA6BA6BA6BA6BA6BA6BC2PPOOABBCCPPOAAB2CCPA2B3CA3B3A6BA15CN3C3N3C3N3C3N3C2BPN2C2BBPPNC2ABBP2CCA2BP2BDBBC4DB3C2DB4PCDB4PPDB4PPDB4PPDB4OOBCB3OOC23PPC5P3CBCCP3C3P3C3O2PC9BPC5BPC5BPC5BPC5BPC5BPC5BPC3BCBPD7C2D4C4D2C39D5MMD23CCD5C4DDBC6BC5BBC3B3DCB3AADB2A3DBBA2PPB2AAPPABBA2PAABBAAPA2BA2PA8PPA2P4AP10AP6AP2AP6A2P4A4P70AOOAP2AOAOAP2AOAOAPPAOAAOAPPAOAAOAPPAAO2APPA5P3A5PAPPBBAAPAPPBBAAPAPPBBAAPAPPBBAAPAPPBBAAPAPPBBAAPAPPBA2PAPPAABA6BA6BA6BA107P2A6PA47BBCB2P2BBCBBA2B2CPA7PPA31O4C2PPO2C2AAP2OCCA4PCCPPA4CAAP2A7PPA7PC5BPC5BPC5BPC5PPC5OPAC4OOA2C2OOPA3CPPC69BBCCNNCCBBCCNNCCBBCCNNCCBBCCNNCCBBCCNNCCBBCCNNCCBBCCNNCCB2AAPA3BAAPA3BAAPA3BAAPA3BAAPA3BAAPA3BAAPA3BAAPA3OOA4POAOOA2POA2OAAPOA2OAAPOAAOAAPPOAOA2PPOOA2P2OA2P73AAP18AP6AP9AAP3AAP3AAPPA3P3A3P2A2P4A2PAPPA4PPA4PPA342PPA7P2A7PPA39BBC5AB2C3A2B2CCPPA2B2AAP2AABA4PPA7PA7CCNNCCBBCCNNCCBBC2NCCB2C4B4C2BBAB3CBBPAAB4APPAAB3PAPA3BPAPA3BPAPA3BPAPA3BPAPA3BPAPA2OBPAPAAOPBPAAPAOPA2P4A2P4AAP2APPAP3APPAP12AAP3AAP3AAPPAAP13AAP3AAP3AAPPA3PPA3PPA23PPA3PPA568P2ABA5PPA47BPA2P2AAPA4PPAPAAPPAAP3A35PPA3PPA309"

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
