-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\Frame03\\Ship.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000240A358OA3O3AACCO3AC4OOA5CCA3C3AADDC7DDCCOC4DDO3C3O5CCO7CD2A3C3D3C15DC7DDC7DDCCDOC3DDEA15DDA5CCDPA3CCDPA3CDEPA3DEEPA3E2PA274DA5DDA5DDA5CDA5CCA5CCA5C17DC6D2C4D4C3D6C3D3C5DDCO6C2O4C5OOC6DC5DECCD4ED3EEDED3EEDEO2CDE2O2NE3ONNME2JNM2EEJJM3EJ2M2J4MJ12PPEEPA4PCPA4PCPA4PCPA4PCPA4PCDPA3PCDPA3CDEPA265CCA6CA6DA6DA5DDA2D2CCAD2C2D2C2D2C7D2C4P2DDC2POP2DDCPOPOP2D2POPOPPD3POPOD3EEPOCD2EC3DC2DC2DCDCDC2DC2DCCDDC2DCCPDC2DCDPD3EDEPPDDEEDEJ4PPDJ3PDDEJJPPDE2PPDDE3DDMME3M3E3M3E3M3E3DEEPA3E2PA3E2PA3E2PA3E2PA3E2PA3E2PA3E2PA34CA5CCA4C2A3C3AAC3DDA3C2A2C5AC5DC4D2C2D4CCD3CCD4C2D2C2PPA15DA6DDA5CCA3DDCCAAD2CP2D2CCPPDDC2PA4D2A2D2CCAAD2CCD3C2PODC3P2C2PN3CPN13C2D4CD6OOD4EO3DDEEO3POPEP2OPOPPN2P4NNO2P2DDE18PE7PDEEPE2DCE2PDDEEPEDDE3PDCE4P2DDEDEEPPDEEDEEDPDDEDEDCPDDEDE2PDDEDE2PD3E2PDDEDE2PDDEDEM3E3M3E3M3E3M3EDEEM3EDDEM3EDEDM3EDEDM3EDE4PA3E2PA3E2PA3E2PA3E2PA3E2PA3E2PA3DEPA5OPPCD2JO2PCDDPJO2PCCJLJOONCCJLLONNCCJLMPNNCCJLMPNNCCJLMPNNCCDDC2P2C2P2DDCCPPEDC2PPDEC3PAC2PNCPAP2NNCPDP2ONCPD2PAODDC3NNC3PN2CCPN4PN29OON3O2N14ON5OON3O3NNO5NO5CO4CEEO2CCEEDNO5CO4CCEO3CEEDOOCCED2CCEED3EED10CD4PPCDDCE14DDE4D2E3DPDDEEDDPOD3P3DDPPA3DPA5EEPDDEDEDDPDDEDEDPPDDEDEPOPDDEDEOOPDDEDEP2D3EAAPD3EAAPD3EM3ED2M3EDDEM3EDEPM3EEPAM3EPAAM2PPA2MMPA4PPA5EEPA4EPA5PA46JJLPNNCCAJJP3CAAJD2PCA2P4A31CPD3PPCPD4P2D5PPD5AAPD4A2PD3A3PPDDA5PPO2NO3P2O3CDDP2OCEDDEEMMEEDDEEMMED2EEMMED2EEMMED2EEMMEDOCCEED2CEED3PED3P2D3PPOOD2PO3D2PPO2D2P2OOD3P3DP3CDPPONNP3O3NPCCO2PPC2OPPC4PC5DPC4DDC3D3P2A4C2PA3C3PA2C2DDPAACD4PAD3MEPAD2MMEPADEEMMEPA2PD2PPA2P2A305PD6AP6A47D2PAPCCP2AAOPPA3JO2A3PJOOA3JLJOA3JLLOA3JLMPA3JLMPCCD4ECD4EEPCDDE3OPCE4ONCE4NNCE4NNCE4NNCE2DDE2MMEPAE2MMEPAE2MMEPAE2MMDPAE2DDPAAEEDPPA2DDPA4PPA393JLMPA3JJLPA4JJPA5JDA6PA23NNCEEDPPNNCDDPAAPPDPPA2DDPA4PPA285"

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
