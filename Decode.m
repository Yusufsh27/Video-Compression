function [Decodee]=Decode(qy, qcb, qcr)

    % This function we used from our project 2. It is the second part where
    % we Dequantize the Quantized Y, Cb, and Cr functions. After doing such
    % we Inverse DCT'd the fucntion and concatinated it togoether recieved a
    % compressed img.
    Quant=[...
        16 11 10 16 24 40 51 61
        12 12 14 19 26 58 60 55
        14 13 16 24 40 57 69 56
        14 17 22 29 51 87 80 62
        18 22 37 56 68 109 103 77
        24 35 55 64 81 104 113 92
        49 64 78 87 103 121 120 101
        72 92 95 98 112 100 103 99];

    CBCRQuant = [
        17 18 24 47 99 99 99 99
        18 21 26 66 99 99 99 99
        24 26 56 99 99 99 99 99
        47 66 99 99 99 99 99 99
        99 99 99 99 99 99 99 99
        99 99 99 99 99 99 99 99
        99 99 99 99 99 99 99 99
        99 99 99 99 99 99 99 99
        ];

    INVYQUANT=@(block_struct)  round(block_struct.data.*Quant); %Inverse Quant
    INVCBCRQUANT=@(block_struct)  round(block_struct.data.*CBCRQuant);


    YIQ=blockproc(qy, [8 8], INVYQUANT);
    CBIQ=blockproc(qcb, [8 8], INVCBCRQUANT);
    CRIQ=blockproc(qcr, [8 8], INVCBCRQUANT);


    INVDCT=@(block_struct) idct2(block_struct.data); % Inverse DCT

    iydct=blockproc(YIQ, [8 8], INVDCT);
    icbdct=blockproc(CBIQ, [8 8], INVDCT);
    icrdct=blockproc(CRIQ, [8 8], INVDCT);


    ICB = zeros(144,176);
    ICB(1:2:end, 1:2:end) = icbdct;
    ICB(1:2:end,2:2:(end-2)) = (ICB(1:2:end,1:2:(end-2)) + ICB(1:2:end,3:2:end))/2;
    ICB(2:2:(end-2),1:1:end) = (ICB(1:2:(end-2),1:1:end) + ICB(3:2:end,1:1:end))/2;

    ICR = zeros(144,176);
    ICR(1:2:end, 1:2:end) = icrdct;
    ICR(1:2:end,2:2:(end-2)) = (ICR(1:2:end,1:2:(end-2)) + ICR(1:2:end,3:2:end))/2;
    ICR(2:2:(end-2),1:1:end) = (ICR(1:2:(end-2),1:1:end) + ICR(3:2:end,1:1:end))/2;

    Decodee = cat(3, iydct, ICB, ICR);
    Decodee = uint8(Decodee);
end
