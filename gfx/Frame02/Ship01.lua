-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame02\\Ship01.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c0002c0A490P4AAEEDPDPAEEDPD2A47PA6DA77CA19CA10CA7CA412EA5EDA4EDDA3EDDPA2EDDPDAAEDDPDPAEDDPDPPEEDPDP2EEPENP2EPEN2P2EN4ADPPN2AEP3AAEDPPA2EDDPA2ED2PDAED3PPED3PAE4NPE4N2E3N3D2PPN2DDPBP2NDPB3PNPPA2CAAP2A2CAP3A3P4A2NP3A2NNPA4NNOAAPAANOOAP2A399EA5EEA5EA6EA6EA6EA6EAED2PDPPD3PDPPD3PDPAD3PDA2D2PDA2D2PAAEAD2AAEDADDAAEDDPAAED3AAED3PAED3PBEP4BBEP5BD3PB2D2PPB2DDPB4PBPBPBPPB5PAPB2PBPPB4APAPBPBPPAAB2APAAPPBAPAAPPBAPAAP2O2PAP2O2NPAPPOON2P2ON4P3N4AP2N2OAP3NOOAP3OOANA7PA380EA6EA23OA5OA4E2A3EED2ADAEED2AAEED3AEED3PEED3PBED3PPBA3PB2A3PBBPDDA2P2DPPBPBPBPB5APB2PBBPB5PAPBPBBPAAB3PA2PBBPA3BPPA4PPA2P3A2DP2A4DPPA5DPA6PA6PA6PA6NP2AOANAPPA2NAAPA2NA5NA5NA5NA5NA365EA5EEA4EEDA3EEDDA2EED2AAEED3AEED4EEP5ED4PAD4P2D3PPBBD2PPBBPDDPPBBPBDPA3P4A3PDP3A2PDP3A2PDP3ABAPDP3BBAPDP3BBAPDP3A4NPA4NAPA3NA25PANA4PNA5NA4NAANA2NA3NANA5NA386EA5EEA4EEDA3EEDDA2EED2AAEED3AEED4EED4PED4PPD4PPBD3PBPBD2P2BBDDPBPBPBDPPB4PPBBPBPBPBBPB2PBBPBPBPB5PBPPBPBPBPB3PBPBPPBPBPBPBBPBBAPDPPBPBBAPAB2PBBAPPBPPBAAP3BA2P2BAAPAPPBAAPPAPBAAPPAAPNA7PA6PA6PA6PA5PA373EA5EPA4E2A3E3A2E4AAEED3AEED4EED4PED4P9E3NNBBE2N2PBEEN4PDP2B3P2BPBPBPPB2NNPPBPBPBNNBPBNBPBNPBN2BPBBNNPNNBPBBNNPNNPBPBPBPPBPBPBPPBABPBPPBAAPBPBBAAPNP2AAPPNPBAAPPAPPAAPPAABAAPPA4PPA2NAPPA4PPA4NPA4NA5NA5NA5NA5NA355EA5EEA4EEDA4EDA5EA3EOD3AEOP4EED4PEDO2ADBDAO2AADAAO2A4O2A4OED2PDPBN4PB2N3BBPBPN2B5NNBBPBPBPNDBBPBPBPADPBP2BAADBBPBPPBBN2PBNPBPNPBANNPBPBAAN2PPA2N3A3N3A3PNNA4BNAOA5PA18NNA3NNA4NA5NA5NA5NA7NA5NA379EA6EA6EA6EAEA5EEA5EDA4EDDA3ED2AAED3PAED3PBE4NBBE3N2BE2N4DDPBN3DPB2N2PB4NNBAADP3BPAADPPABBPAADPAB2PA3BP3A2NPPA4NNPA4NANA6OOA2NAO2AANAAO2ANA2O2NA3OONA4OOA5NA5NA429EA5EDA4EDDA3EODDA2ED2PAAED2PBAED2PBBED2PB2D2PBBPBDDPB3PDPBBPBP2B4PPBBPBP2NB2P3APBP3AABBP2A2P4A2P3A3P2A3NPPA3NA3PA2NA5OA10NNA4NA5NA473EA5EAAI2AEA2I2AEAIAI2AEAIAI2AEAIAI2AEAAIAIIAAEAAIAIAAPBP3IIAP4I2AP2AI3APAAI4A2I3A3I2A3NIIACAANAPA3NA5NA5NA5NA5NA5NA537EAAIA4EAAIA4EA7EA32IACA12CA638CA686"

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
