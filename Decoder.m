function Decoder(yy, ccb, ccr, mvy,mvc, fframes)

    for count=1:5

        % Dequanitized and Inverse DCT the function based on the Y, Cb, Cr it was given
        decodee = Decode(yy(:,:,count), ccb(:,:,count), ccr(:,:,count)); 
        y = decodee(:,:,1);
        cb = decodee(:,:,2);
        cr = decodee(:,:,3);
        %Stores such values as it's corresponding variable.
        
            if count==1
            % we need to save the orginal values of the functions to be
            % used in compression.
            OrgY = (y);
            Orgcb =(cb);
            Orbcr =(cr);
            else        

            %Decode P Frames for Y
            compensated = motionComp(OrgY, mvy(:,:,count), 16); % Used from project 3 compression functions.
            y = uint8(compensated) + uint8(y);

            %Decode P Frames for Cb
            compensated = motionComp(Orgcb, mvc(:,:,count), 16);
            cb = uint8(compensated) + uint8(cb);

            %Decode P Frames for Cr
            compensated = motionComp(Orbcr, mvc(:,:,count), 16);
            cr = uint8(compensated) + uint8(cr);

            end
    
        concat = cat(3, y, cb, cr); %Combining all the components together.
        
        fframe = fframes(:,:,:,count);
        error = fframe-concat; % Obtaining the error rate.
        
        figure(); %Printing the original image, Deccoded img, and the Actuall Error between the two.
        subplot(2,2,1),subimage(fframe), title(['Original Frame #', num2str(count)]);
        subplot(2,2,2),subimage(ycbcr2rgb(concat)), title(['Reconstructed Frame #', num2str(count)]);
        subplot(2,2,3),subimage(error), title(['Error of Frame #', num2str(count)]);
        
    end

end