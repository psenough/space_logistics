#!/usr/bin/python3
#
# TicPanel - convert images to TIC-80 hex Arrays
#
# Hint: python -m pip install pillow (install PIL on Windows)
#
# last updated by ps / TPOLM on 30.07.2026
#

# import modules
from PIL import Image
# import argparse
import os.path
import sys

imageFile = sys.argv[1]

outputFile = sys.argv[1]+".lua"


# load image file
print("       Image: " + imageFile)
try:
    orgImg = Image.open(imageFile)
except Exception as error:
    print("ERROR: " + str(error), file=sys.stderr)
    exit(1)


# get image mode & format
orgMode = orgImg.mode
orgFormat = orgImg.format
orgFormat = '.' + orgFormat.lower()
print("      Format: " + orgFormat + " (" + orgMode + ")")


# get image dimensions
orgSizeX, orgSizeY = orgImg.size
print("  Resolution: " + str(orgSizeX) + " x " + str(orgSizeY))

# convert image to limited colors and use that palette
srcImg = orgImg.convert("P", palette=Image.ADAPTIVE, colors=16)
srcPalette = srcImg.getpalette()

# get palette
stdPalette = "1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57"  # SWEETIE-16 palette
#srcPalette = orgImg.getpalette()  # get original palette from image
#print(srcPalette)
rgbEntries = (2 ** 4) * 3
rgbPalette = srcPalette[:rgbEntries]
Palette = ""
for entry in rgbPalette:
	hexVal = '%0*x' % (2, entry)
	Palette = Palette + hexVal
Palette = Palette + stdPalette[len(Palette):]  # fill up with default palette

# prep palette output decoder
paletteFile = os.path.join(os.path.curdir, "decoders", "palette.lua")
outputPalette = '\nlocal pal = "' + Palette + '"\n'
if os.path.isfile(paletteFile):
	with open(paletteFile, "r") as file:
		fileLines = [line.strip('\n') for line in file.readlines()]
		codeStart = next((index for index, tag in enumerate(fileLines) if tag == '-- CODEBLOCK'), -1)
		outputPalette = outputPalette + "\n".join(fileLines[codeStart+1:]) + "\n"
else:
	outputPalette = outputPalette + "\n -- No palette-routine found!\n"
	print("No palette-routine found!\n")

# get image data
Data = ""
posY = 0
while posY < orgSizeY:
	posX = 0
	while posX < orgSizeX:
		hexVal = '%0*x' % (1, srcImg.getpixel((posX, posY)))
		Data = Data + hexVal
		posX = posX + 1
	posY = posY + 1

def encode_rle(data):
    enc = ""
    prev = ""
    count = 1
    for symbol in data:
        value = chr(int(symbol, 16) + 65)
        if value != prev:
            if prev:
                enc = enc + prev
                if count == 2:
                    enc = enc + prev
                elif count > 2:
                    enc = enc + str(count - 1)
            count = 1
            prev = value
        else:
            count = count + 1
    enc = enc + prev
    if count == 2:
        enc = enc + prev
    elif count > 2:
        enc = enc + str(count - 1)
    if not enc[-1].isdigit():
        enc = enc + "0"
    return enc

# write data as RLE-encoded to output file
def write_rle():
    encPalette = encode_rle(Palette)
    outputPalette = '\n' + outputVar + 'pal = "' + "07F80" + PaletteLen + encPalette + '"\n'  # Offset and width for palette
    outputCode = '\n' + outputVar + 'gfx = "'
    outputCode = outputCode + offsetAdr
    outputCode = outputCode + str(hexWidth)
    # encode serialized tile values
    encData = encode_rle(serialTiles)
    outputCode = outputCode + encData + '"\n'
    try:
        with open(outputFile, 'w') as file:
            file.write(outputCmnt + "title:  " + str(imageFile) + "\n")  # write header
            file.write(outputCmnt + "author: TicMcTile\n")
            file.write(outputCmnt + "script: " + outputLang + "\n")
            file.write(outputPalette)
            file.write(outputCode)
            file.write(outputDecoder)
            file.write(outputViewer)
    except Exception as error:
        print("ERROR: " + str(error), file=sys.stderr)
        exit(1)
    return
	
# prep image output decoder
outputHexdata = '\nlocal st = "' + encode_rle(Data) + '"\n'
outputHexdata = outputHexdata + "local sx = " + str(orgSizeX) + "\n"
outputHexdata = outputHexdata + "local sy = " + str(orgSizeY) + "\n"
hexdataFile = os.path.join(os.path.curdir, "decoders", "hexdata.lua")
if os.path.isfile(hexdataFile):
	with open(hexdataFile, "r") as file:
		fileLines = [line.strip('\n') for line in file.readlines()]
		codeStart = next((index for index, tag in enumerate(fileLines) if tag == '-- CODEBLOCK'), -1)
		outputHexdata = outputHexdata + "\n".join(fileLines[codeStart+1:]) + "\n"
else:
	outputHexdata = outputHexdata + "\n -- No hexdata-routine found!\n"
	print("No hexdata-routine found!\n")


#hexByte = '%0*x' % ((len(pixelByte) + 3) // 4, int(pixelByte, 2))  # convert byte to hex


#open(viewerFile, "r") as file:
#fileLines = [line.strip('\n') for line in file.readlines()]
#codeStart = next((index for index, tag in enumerate(fileLines) if tag == outputCmnt + 'CODEBLOCK'), -1)
#outputViewer = "\n".join(fileLines[codeStart+1:]) + "\n"


try:
	with open(outputFile, 'w') as file:
		file.write("-- title:  " + str(imageFile) + "\n")  # write header
		file.write("-- author: TicPanel\n")
		file.write("-- script: lua\n")
		file.write(outputPalette)
		file.write(outputHexdata)
except Exception as error:
	print("ERROR: " + str(error), file=sys.stderr)
	exit(1)

