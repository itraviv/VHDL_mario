#/usr/bin/env python
# Image To Mif
# Alon Rasehlbach, Ofer Fassler
# Spring 2017
# Technion EE Lab 1

import sys
import math
from PIL import Image

if len(sys.argv) < 3:
	print "Usage: %s ImagePath OutputPath" % sys.argv[0]
	exit()

# Get arguments
ImageName = sys.argv[1]
OutputFile = '%s.mif' % sys.argv[2]

# Initialzie objects
ImageObject = Image.open(ImageName)
RgbImage = ImageObject.convert('RGB')
Pixels = ImageObject.load()

# Request size of ROM
size_rom_power = float(raw_input('Rom size of power of 2:'))
size_rom = math.pow(2, size_rom_power)
zero_pad = int(math.floor(size_rom_power / 4)) + 1
print 'Rom size is %d' % size_rom

counter = 0
OutputText = 'DEPTH = %d;\nWIDTH = 8;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\nCONTENT\nBEGIN\n\n' % size_rom

for y in xrange(ImageObject.size[1]):
	for x in xrange(ImageObject.size[0]):
		r, g, b = RgbImage.getpixel((x, y))
		r = int(r*0.03) << 5;
		g = int(g*0.03) << 2;
		b = int(b*0.015);
		PixelString = hex(r|g|b)[2:].zfill(2).upper()
		CounterString = hex(counter)[2:].zfill(zero_pad).upper()
		counter+=1
		OutputText += '%s : %s;\n' % (CounterString, PixelString)

OutputText += '\n\nEND;\n\n'

with open(OutputFile, 'w') as f:
	f.write(OutputText)

print 'Written to file: %s' % OutputFile


