function Encoder(clip)
    
    frames=read(clip);
    
    % The next three variables are  used for creating the multi-Dimension 
    %array where we will store pixel values of the 5 frames.
    dimensions=size(frames);
    width=dimensions(1);
    height=dimensions(2);
    
    mbSize = 16; 
    NumofFrames = 5;
    StepSize = 8; 
           
    frames= frames(:,:,:,1:5);
    
    %creating the empty arrays in which the values will be stored in and
    %used for transfering.
    %The reason we are doing this is becasue there are 5 frames so we need
    %to have a 5D array where we can stores the values(pixels) of the img
    
    MVY = zeros(2, width*height/mbSize.^2, NumofFrames); 
    MVCBCR = zeros(2, width*height/mbSize.^2, NumofFrames);
    
    emptyy = zeros(width, height, NumofFrames);
    emptycb = zeros(width/2, height/2, NumofFrames);
    emptycr = zeros(width/2, height/2, NumofFrames);
   
    
    for count = 0:4 %Count is 0-4 because there are a total of 5 frames that we have devided the video into
        
        % This is the current frame/ Refference frames
        current=double(rgb2ycbcr(frames(:,:,:,count+1))); 
        
            if(count == 0)
                
                %Simply obtains all the Quantized Y, Cb, and Cr from the current frame
                [qy, qcb, qcr] = Encode(current); 
                    
                % After Quanitize and DCT and compression the file is
                % broken up and stored into the in the first
                % dimension of the emptyy array.
                 emptyy(:,:,count+1)=qy; 
                 emptycb(:,:,count+1)=qcb;
                 emptycr(:,:,count+1)=qcr;

                % After inverse quantizing and Inverse DCT and Final
                % concatinated is stores as the next reference for the next
                % frame.
                next_ref = Decode(qy, qcb, qcr);
                Initcurrent = current; % The initial is frame is saved for as current for the next loop.
            else
                fprintf('Frame %d\n', count+1); % Printes the fame number so we know what frame the computer knows what frame we are working on.

                currentY=current(:,:,1); % The Y component of the current frame.
                
                %In the project 3 we used MotionEstEs to recieve multiple fields however
                %here we simply only needed the MotionVector and so we eddited that file to
                %only recieve that back.
                motionVecter = motionEstES(currentY,referenceY, mbSize, StepSize); 
                motionVecterOT = motionVecter./2; % Used for the Cb and Cr components

                MVY(:,:,count+1) = motionVecter;
                MVCBCR(:,:,count+1) = motionVecter./2;
                printMV(count, motionVecter);

                motioncomprY = motionComp(referenceY, motionVecter, mbSize);

                refsubcb=referenceCb(1:2:end, 1:2:end); % This is the simply subsampling we used in Project 1
                refsubcr=referenceCr(1:2:end, 1:2:end); 

                motioncomprCb = motionComp(refsubcb, motionVecterOT, mbSize/2); % Simpply compressed the CB and Cr componanent of the img
                motioncomprCr = motionComp(refsubcr, motionVecterOT, mbSize/2);

                ICB = zeros(144,176); % This is the Upsample Interpolation we used in Project 1.
                ICB(1:2:end, 1:2:end) = motioncomprCb;
                ICB(1:2:end,2:2:(end-2)) = (ICB(1:2:end,1:2:(end-2)) + ICB(1:2:end,3:2:end))/2;
                ICB(2:2:(end-2),1:1:end) = (ICB(1:2:(end-2),1:1:end) + ICB(3:2:end,1:1:end))/2;

                ICR = zeros(144,176);
                ICR(1:2:end, 1:2:end) = motioncomprCr;
                ICR(1:2:end,2:2:(end-2)) = (ICR(1:2:end,1:2:(end-2)) + ICR(1:2:end,3:2:end))/2;
                ICR(2:2:(end-2),1:1:end) = (ICR(1:2:(end-2),1:1:end) + ICR(3:2:end,1:1:end))/2;

                concat=cat(3,motioncomprY, ICB, ICR); % Just like in project 2 we had to concat all of the components together.

                errorr =  current - (concat); % Calculates the error.

                [qy, qcb, qcr] = Encode(errorr); % This will generates us the error image.

                emptyy(:,:,count +1)=qy; %Stores the value into the empty array created at the top.
                emptycb(:,:,count +1)=qcb;
                emptycr(:,:,count +1)=qcr;

                next_ref = Initcurrent;
            end
        
        referenceY=double(next_ref(:,:,1)); % Sets the reference, for the Else statement after it passes through the first if.
        referenceCb=double(next_ref(:,:,2));
        referenceCr=double(next_ref(:,:,3));
        
    end
    Decoder(emptyy, emptycb, emptycr, MVY, MVCBCR, frames); %Passes all of the variables to the Decoder.
end