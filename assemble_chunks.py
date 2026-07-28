import sys
sys.path.append('ticfile')

from ticfile import TICFile, Chunk, ChunkType

# open the cart where the default palette, tiles and music is
reference_cart = TICFile.open("source\\_touch.tic")

# remove all code from it
for chunk in reference_cart.chunks:
    if chunk.type == ChunkType.CODE:
        reference_cart.chunks.remove(chunk)

# add lua code

# bank 0 main code
reference_cart.chunks.append(Chunk(ChunkType.CODE, 0, bytes(open("source\\main.lua", "r").read(),"ascii")))

# bank 1
bank1 = ""
bank1 = bank1 + open("source\\bootstrap.lua", "r").read()
bank1 = bank1 + open("source\\frame01_sprites.lua", "r").read()
bank1 = bank1 + open("source\\frame01_calls.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 1, bytes(bank1,"ascii")))

# bank 1
bank2 = ""
bank2 = bank2 + open("source\\frame02_sprites.lua", "r").read()
bank2 = bank2 + open("source\\frame02_calls.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 2, bytes(bank2,"ascii")))

# bank 3
bank3 = ""
bank3 = bank3 + open("source\\frame03_sprites.lua", "r").read()
bank3 = bank3 + open("source\\frame03_calls.lua", "r").read()
bank3 = bank3 + open("source\\frame04_sprites.lua", "r").read()
bank3 = bank3 + open("source\\frame04_calls.lua", "r").read()
reference_cart.chunks.append(Chunk(ChunkType.CODE, 3, bytes(bank3,"ascii")))


# save it to the final destination
reference_cart.save("space_logistics.tic")
