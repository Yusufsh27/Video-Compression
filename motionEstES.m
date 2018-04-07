% Computes motion vectors using exhaustive search method
%
% Input
%   imgP : The image for which we want to find motion vectors
%   imgI : The reference image
%   mbSize : Size of the macroblock
%   p : Search parameter  (read literature to find what this means)
%
% Ouput
%   motionVect : the motion vectors for each integral macroblock in imgP
%   EScomputations: The average number of points searched for a macroblock
%
% Creddited to Aroh Barjatya

function [motionVect] = motionEstES(imgP, imgI, mbSize, p)

[row col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);
costs = ones(2*p + 1, 2*p +1) * 65536;

mad_computations = 0;
mins=[];


mbCount = 1;
%this shifts the search window
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        

        
        %this shifts the search MB relative to the search frame. Compares P
        %against I1608
        for m = -p : p        
            for n = -p : p
                refBlkVert = i + m;   % row/Vert co-ordinate for ref block
                refBlkHor = j + n;   % col/Horizontal co-ordinate
                if ( refBlkVert < 1 || refBlkVert+mbSize-1 > row  || refBlkHor < 1 || refBlkHor+mbSize-1 > col) %pathalogical case where we are off the image edge
                    continue;
                end
                costs(m+p+1,n+p+1) = costFuncMAD(imgP(i:i+mbSize-1, j:j+mbSize-1), imgI(refBlkVert:refBlkVert+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                mad_computations = mad_computations + 1;
                
            end
        end
        
        % Now we find the vector where the cost is minimum
        % and store it ... this is what will be passed back.
        
        [dx, dy, min] = minCost(costs); % finds which macroblock in imgI gave us min Cost
        mins=[mins min];
        vectors(1,mbCount) = dy-p-1;    % row co-ordinate for the vector
        vectors(2,mbCount) = dx-p-1;    % col co-ordinate for the vector
        mbCount = mbCount + 1;
        costs = ones(2*p + 1, 2*p +1) * 65536; %reset for next iteration
    end
end

motionVect = vectors;
                    