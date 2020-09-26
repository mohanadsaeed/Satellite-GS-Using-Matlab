function crc_hex=CRC_generate(command)
    n=length(command);
    crc7='91';
    crc7_bin=hexToBinaryVector(crc7,8);
    crc=0;
    crc_hex=cell(1,n);
    for i=1:n
        command_bin=hexToBinaryVector(command(i),8);
        crc_bin=xor(crc,command_bin);
        for j=1:length(crc_bin)
            if crc_bin(j) && 1
            crc_bin=xor(crc_bin,crc7_bin);  
            end
        end
%         crc_hex(i)=cellstr(dec2hex(bin2dec(char(crc_bin+'0'))));
%         if crc_bin(1:4)==0
%             crc_bin=crc_bin(5:8);
            crc_hex(i)=cellstr(binaryVectorToHex(crc_bin));
%         else
%             crc_hex(i)=cellstr(binaryVectorToHex(crc_bin));
%         end
    end
    crc_hex=char(crc_hex)';
    [R, C]=size(crc_hex);
    crc_hex=reshape(crc_hex,[1 R*C]);
end