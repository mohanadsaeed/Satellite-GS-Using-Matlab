function command=packing(sensor,data,bytes)
    ID='21';
    if sensor=="ultraget"
        C1='02';
        C2='0A';
    elseif sensor=="ultratake"
        C1='02';
        C2='0B';
    else
        C1='03';
    end
    if sensor=="gyro"
        C2='0A';
    elseif sensor=="accel"
        C2='0B';
    elseif sensor=="temp"
        C2='0C';
    elseif sensor=="all"
        C2='0D';
    end
    NMI=bytes;
    NMO='00';
    Data=data;
    if sensor=="motor_1"
        C1='01';
        NMI='00';
        NMO=bytes;
        Data=dec2hex(abs(data));
        if data>0
        C2='0A';
        elseif data<0
            C2='0B';
        end
    elseif sensor=="motor_2"
        C1='11';
        NMI='00';
        NMO=bytes;
        Data=dec2hex(abs(data));
        if data>0
        C2='0A';
        elseif data<0
        C2='0B';
        end
    end
    command={ID,C1,C2,NMI,NMO,Data};
    command=hex2dec(command);
%     crc_tx=CRC_generate(command);
%     command=strcat(command,crc_tx);
end