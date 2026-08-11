import sys
sys.path.append('ticfile')

from ticfile import TICFile, Chunk, ChunkType

# open the cart where the default palette, tiles and music is
#reference_cart = TICFile.open("source\\_touch.tic")
reference_cart = TICFile.open("music\\_music_no_fn.tic")

# remove all code from it
#for chunk in reference_cart.chunks:
#    if chunk.type == ChunkType.CODE:
#        reference_cart.chunks.remove(chunk)

# bank 1
bank1 = ""
bank1 = bank1 + open("source\\frame01_sprites.lua", "r").read()
bank1 = bank1 + open("source\\frame02_sprites.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 1, bytes(bank1,"ascii")))

# bank 2
bank2 = ""
bank2 = bank2 + open("source\\frame03_sprites.lua", "r").read()
bank2 = bank2 + open("source\\frame04_sprites.lua", "r").read()
bank2 = bank2 + open("source\\construction01_sprites.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 2, bytes(bank2,"ascii")))

# bank 3
bank3 = ""
bank3 = bank3 + open("source\\frame05_sprites.lua", "r").read()
bank3 = bank3 + open("source\\frame06_sprites.lua", "r").read()
bank3 = bank3 + open("source\\frame09_sprites.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 3, bytes(bank3,"ascii")))

# bank 4
bank4 = ""
bank4 = bank4 + open("source\\frame07_sprites.lua", "r").read()
bank4 = bank4 + open("source\\frame08_sprites.lua", "r").read()
bank4 = bank4 + open("source\\tunnel_sprites.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 4, bytes(bank4,"ascii")))

# bank 5
bank5 = ""
bank5 = bank5 + open("source\\bootstrap.lua", "r").read()
bank5 = bank5 + open("source\\frame01_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame02_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame03_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame04_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame05_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame06_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame07_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame08_calls.lua", "r").read()
bank5 = bank5 + open("source\\frame09_calls.lua", "r").read()
bank5 = bank5 + open("source\\supernova.lua", "r").read()
bank5 = bank5 + open("source\\tunnel.lua", "r").read()
bank5 = bank5 + open("source\\construction01_calls.lua", "r").read()
bank5 = bank5 + open("source\\main.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 5, bytes(bank5,"ascii")))


# save it to the final destination
reference_cart.save("space_logistics.tic")
