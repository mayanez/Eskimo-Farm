import scipy.io.wavfile, sys, numpy

filename = sys.argv[1]

rate, data = scipy.io.wavfile.read(filename + '.wav')
f = open(filename + '.mif', 'w')

f.write('WIDTH = 8;\n')
f.write('DEPTH = %d;\n' % data.size)
f.write('ADDRESS_RADIX = UNS;\n')
f.write('DATA_RADIX = UNS;\n\n')
f.write('CONTENT BEGIN\n')

count = 0
for i in data:
	f.write('%d : %d;\n' % (count, i))
	count += 1
f.write('END;\n')
f.close()