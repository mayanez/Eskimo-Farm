import png, sys

infile = sys.argv[1]
f = open(infile + '.mif', 'w')
infile = infile + '.png'

pngReader = png.Reader(filename=infile)
colors = pngReader.asRGB()
row = colors[0]
col = colors[1]
f.write('WIDTH = 12;\n')
f.write('DEPTH = %d;\n' % (row*col))
f.write('ADDRESS_RADIX = UNS;\n')
f.write('DATA_RADIX = UNS;\n\n')
f.write('CONTENT BEGIN\n')

count = 0
for row in colors[2]:
	i= 0
	while i < len(row):
		red = row[i]
		green = row[i+1]
		blue = row[i+2]
		color = red*256 + green*16 + blue
		f.write('%d : %d;\n' % (count, color))
		i += 3 
		count += 1

f.write('END;\n')
f.close()