-- title:  C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\space_logistics\gfx\Frame01\\Logo02.png
-- author: TicMcTile
-- script: lua

local pal = "07F80060KBMBMCNFHCNFBLODDFPONHHFPPNMFHHKAPAHIDHLEGFCBHJHJCGDPGLDNFJMBEGKGPDHPOHPEPEPEPEJALCMGFMGGIDDMDHF0"

local gfx = "0c000200A3C3A2C4AAH5AH18PAAH3PPAAH3PPCAHC2A2C3PCAC2HPCPH5PPH5PPH5PPH6PH6AH3C5AAC4PPAH3P2CH4PCPH5P3AH2P3AH2PCPPAH3PA3C3A2C3PAAH3PPAAH3PPAAH3PPCAH3PCPH5PPH5PA6CA5CCA4H2A3H3CAAH4PAAH3PPAAH3PPAAH3PC5AAC4PAAH3PPCAH3PCPAH4PPAPH3PPAPAH2PAAPAH2A4C5AC6H26PPA2H2PPA2H2PPA2C2A4CCPA4HPPA4HPA5HA30H2PCPCCH3PCCPH5PCAH6AAH5A3H3A5HHAAC2AAHA3H3CCAAH3CPPAH3P2CH4PCPH5PPH5PPH6PH3PPAH3P2AH3P2CH2P2H4PAH5AAH4A2H2A4PPA4HAH5PAH5PAH10PH5PPH5PPH5PPH10PCAH3PCPAH3P2AH3P2AH3P2AH3P2CH3PPCPH3PHPPH3PPA6PA6PA6PA6PA6PA6PA6PA2C2AH2PPA2H2PC3H2C4H26PPA2H2PPA10C2A4CCPA4HPA5HA31C2PAAH3PPCAH3PCPPH4PPH9AH6AAH5A7H2PH6PH5PPH5PAH5AAH4A2H3A3H3A7PPA4HPPA4HPPA4HPPA4HPPA3HHPA4HHA5HHA7H25PPAAH3PA2H3A4HHA5HA7HPPH3PHPPH3PHPCH3PHHPH3CHHPPH5PAH5A2H2A7PAAC2PAPAH2PPACCH2PPACH3PAAH4A2H3A3H2A12H2PPA2H2PPA2H2PC3H2C4H23A23C2A4CCPA4HPPA4HPA5HA14"

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
