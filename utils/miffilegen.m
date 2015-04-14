function [outfname, rows, cols] = miffilegen(infile, outfname)

img = imread(infile);

[rows, cols, rgb] = size(img);

fid = fopen(outfname,'w');

fprintf(fid,'WIDTH = 24;\n');
fprintf(fid,'DEPTH = %4u;\n\n',rows*cols);
fprintf(fid,'ADDRESS_RADIX = UNS;\n');
fprintf(fid,'DATA_RADIX = UNS;\n\n');
fprintf(fid,'CONTENT BEGIN\n');

count = 0;
for r = 1:rows
    for c = 1:cols
         red = uint16(img(r,c,1));
         green = uint16(img(r,c,2));
         blue = uint16(img(r,c,3));
         color = red*65536 + green*256 + blue;
        fprintf(fid,'%4u : %24u;\n',count, color);
        count = count + 1;
    end
end

fprintf(fid,'END;');
fclose(fid);