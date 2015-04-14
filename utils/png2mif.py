import png, sys

f = open('ship.mif', 'w')
f.write('WIDTH = 24;\n')
f.write('DEPTH = 1024;\n')
f.write('ADDRESS_RADIX = UNS;\n')
f.write('DATA_RADIX = UNS;\n\n')
f.write('CONTENT BEGIN\n')

pngReader = png.Reader(filename='player_ship.png')
colors = pngReader.asRGB()

i= 0
count = 0
for row in colors[2]:
	while i < len(row):
		red = row[i]
		green = row[i+1]
		blue = row[i+2]
		color = red*65536 + green*256 + blue
		f.write('%d : %d;\n' % (count, color))
		i += 3 
		count += 1

f.close()