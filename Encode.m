function[qy ,qcb ,qcr]=Encode(ycbcr)

    % This function we used from our project 2. It is the first part where
    % we quantize Y, Cb, and Cr functions. After doing such
    % we DCT'd the fucntion to combine it together.

    yycbcr  = ycbcr(:,:,1); 
    cbycbcr = ycbcr(:,:,2);
    crycbcr = ycbcr(:,:,3);


    CB = cbycbcr(1:2:end, 1:2:end); 
    CR = crycbcr(1:2:end, 1:2:end); 

    dctt=@(block_struct) dct2(block_struct.data); % DCT FUNCTION

    ydct=blockproc(yycbcr, [8 8], dctt, 'PadPartialBlocks', true); % Pad blocking lets the matrix be of the same size as others
    cbdct=blockproc(CB, [8 8], dctt, 'PadPartialBlocks', true);
    crdct=blockproc(CR, [8 8], dctt, 'PadPartialBlocks', true);



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

    Yquant=@(block_struct) round((block_struct.data)./Quant); % Completing the quantization for Y
    CBCRquant=@(block_struct) round((block_struct.data)./CBCRQuant); % Completing the quantization for CB and CR

    qy=blockproc(ydct, [8 8], Yquant);
    qcb=blockproc(cbdct, [8 8], CBCRquant);
    qcr=blockproc(crdct, [8 8], CBCRquant);
    
end
