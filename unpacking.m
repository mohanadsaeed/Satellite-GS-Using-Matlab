function Data=unpacking(command)
    ID=command(1:2);
    C1=command(3:4);
    C2=command(5:6);
    NMI=command(7:8);
    NMO=command(9:10);
    NMI=str2num(NMI);
    if NMI==2
        data=command(11:11+NMI-1);
        Data=hex2dec(data);
    elseif NMI==4
        data=command(11:12);
        Data(1)=hex2dec(data);
        data=command(13:11+NMI-1);
        Data(2)=hex2dec(data);
    elseif NMI==6
        data=command(11:12);
        Data(1)=hex2dec(data);
        data=command(13:14);
        Data(2)=hex2dec(data);
        data=command(15:11+NMI-1);
        Data(3)=hex2dec(data);
    end
%     crc=command(NMO,:);
end    
