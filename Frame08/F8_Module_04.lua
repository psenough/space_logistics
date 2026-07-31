-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame08\\F8_Module_04.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000280A310CA3C3A36C2AAC21A13CCA2C33D2CCD2B2AC5AC22DC2D3BD2B3CB2C2DDC2D2BBA7C2A4CCDDCCAADDBBC2ABBCCDDBBCD2B3DB14A39BA6BBA5IA131C2A37MMA2CM3C15A14CA3C2BAC6M2C4M6CM7C3DDMOAC14B2C7B4C6BCCDDB2CMO2C2DOM2NDDBC5DDC2D2BBCDDB2CCB2C3DB3CDDBCCD2B2DDB13DDB2C2BBC2D2CCD2B2DDB27AAB2A4D2B26AAB2A2IIBA2IIPIAIIAPIIPIPBAIPPIB5IIB2AAIB2AAIAB2AI2AB2I2PAB2P3ABP2IPAAP5AP2AIA6BA6BA6BA53CA3M3A2D4AAD5ABO2D2ABP2O2BAAOOP2AAC13DC6M6CD6MD7OD6PO3D2C12D2CCD2B2DDCBBC2M2CCD7B2DDBCB3DBBCB3D3BBCCB2C2DDC2D2BBD2B31NB3M2NNBPBDN3BPBBN3BPBBN3BPBBN3BPBBN2OBPBBNNOOBPBBNO2BPB14AAB2A2IA4IAPAAIIAIA3IIA3PAPPAP2AAP2A6IIA4IIPAAIAAIPA2PAP2AAPPAP2AAP3A2P2A2P3BP4BBAPIPAPIPPIPBAP6AP5BAP4BBAP3B2AP2ABBAAPPA3P3AAPPAPPA2PPA5PAAPPA3PPA100BAO5BOP2O2BOPA4BOPAO2PBOPAO3BOPAOONPAOPAONOPAOPAONOPOP3O7PPOAO2POPAPA3OPAO2PPOPAO3POPANNOOPOPAOONOPOPAB2PB3ABBPBBNBOPBPBBNBOPBPBBNBOPBPBBNBOPBPBBNBOPBPBBNBOPBPB4N2B3N3B3N2B4N2B4NNB5NB5PB3P2B2PPB4NO2BPBBOONNBPBBN3BPBBN2PPB2NPPNB2PPN2BAABNNA3PBA3P2A5PPA2P3BAP3BBAAPPBBAAPABBAAP2AAP4AP3A3PPA5PPB2AAPBBA2P2AAP4AP3A3PA30P3A3PA182BOPAONOPBOPAOONPABOPO2PABOPO2PAAOPA2OAAOP3A3O2PPA2O6NOPOPAOONOPOPANNOOPOPAO3POPAO3POPA4OPPAP3OPABOP2OPABOPBPB2POPBBP2BOPB5OPB3AAOBPA3PBA3P2AAP4AP3A3PPB3AAB2A3PA4P2AAP4AP3A3PPA23P4AP3A3PPA371OOA55O3PABAAO2BBA49PPA509"

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
