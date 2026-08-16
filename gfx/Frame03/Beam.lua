-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\gfx\Frame03\\Beam.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000340P8C6PC6PC6PC6PC6PC6PDC5A7P2A4C2PPA2C4PPAC6PC21DDA31PA6CPA5DDPPA3C3PPA641PCDDC3PC2DDCCPCDC2DDPCCDDCCDPC2D2CPC4DDP2C3DP4C5D2C2DDC4DC6DC5DCDDCCDDC3DDC2DDCCDDC2D2CCDDC4DPAC2DDCCPCDDC4DC13EC4EEDC3ED2CCEED3A7PA6CPPA4CEPPA3EDEEPA2D4PAAD4PAADDPDDPA577P5CCP2OP6OP6OPOOP3OPO2P2OPO2P2OPO2P2OPO2CCD2C6DDCEPC2DDCEPC2DDCEPC2DDCEPC2DDCEPC2DDCEPC2DDCE2D11PPD3P3D2P4DDP5DDP3NODDP2NMMDDP2ONOP2DDPAAP2DDPAAP2DDPAAPOPPDPAAPPOOPA2P2OOPPAOOP2OOPMOOP3OA55PPA517P2OPO2P32C2DC2PC3DCCPC4DCPC3DCEPC5EPC5EPC5EPC5EC6EC6EC6EDDP2NONDDP2ONODDP2NONDDP2ONODDP2NONDDP2ONODDP2N2DDP4NOMMOOP2NONMNOOPON2MMNONONONOMMNNON5ONON3ON7ON5OOPPA3PPOOPA2P2OOPPAOOP2OOPMNOP3ONMMOOP2NONMNO3N2MMOOA31PPA5OOPA4O2PPA2O4PA449PC5DPC6PC6PC6PC6PC6PD6PC13EDC5ECD6C6EC6EC6ED6EC6EDDP2OPPDDP2OPODDP2OPODDP4ODDP3APDDPPA3EDPA4P2A4PN5OPPN3ONPOPPNONNPO2PN2PO3PPNPPO4PAAPO4A2PPO2N5MMN5PN5PGPN3PG2N2PG3NNPG4PGFG4OOG5O5PPMO6NMMO4PPNMNO2GGPNMMOOG2PPNMMG4PPNG5FPA7PA6OPPA4O2PPA2O4PAAO5PPMO6NMMO4A47PA6OPPA324P7A55P7A123PPOOA5PPA47O2PGFGGO4GGFPO5GAPPO4A2PPO2A3P2OA5PPA6PG4FG5FG2FGGFG5FG4OOGFG2FO2GGFFGO4GFFPPO3GGPPNMO3GGPNMMOOGFGPPNMMFG2FPNNG2FGGPPGGFGGF2GFGGF4GGF4O2PA3O3PPAAO5PAMO5PNMMO4PNNMO3FPPNMMOOF2PPNMMA23PA6OPPA4O2PA3O3PPAAO5PA577P2O2PAAP2O2A3P3A39GGFFMF2OOGFFM2P2GGFMMA4GFFA5GGA23F4PNNM2F2PPM4FFPF2M2F6M2GF4MMAGGF4A2GF3MO5PNMMO4PNNMO3FPPNMMOOF2PNNM3FFPPNNM2F2PNFFM2FFPPA6OPA5OOPPA3O3PPAAO5PAMO5PNMMO4PNNMO3A39PA6OPA5OOPPA583GGFFA5GFA6GA39F2M2F6M2GF4MMAGF5AAGGF3A3GF2A4GGFA6GFPPNMMOOF2PNNM2F2PPNNM2F2PNFM2F2PF2M2F5M3F5MMO3PA2O4PPAMO5PNMMO4PNNMO3FPPNMMOOFFPPNNM2F2PPNNA23PPA5OOPPA3O3PA2O4PPAMO5PA639GGF5AAGF4A2GGF2A4GGFA6GA23M2FFPPNFM2F2PF2MMF6MFFMF3MFFMGGFFMFFMAAGF3MA2GGFFMNMMO2NNPNNMON2FPPN3PFFPPNNPGMF2PPGGMF2MG2MF2MG2MF2MG2PA6PA6FA6FA6FA6FA6FA6FA651GFFA5GGA47MF2MG2F3MG3F2MG2AGGFMG2A2GGF2A4GGA16FA6FA6FA6FA6GA30"

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
