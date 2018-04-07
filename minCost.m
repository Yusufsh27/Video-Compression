% Finds the indices of the cell that holds the minimum cost
%
% Input
%   costs : The matrix that contains the estimation costs for a macroblock
%
% Output
%   dx : the motion vector component in columns
%   dy : the motion vector component in rows
%
% Creddited to Aroh Barjatya


function [dx, dy, min] = minCost(costs)

[row, col] = size(costs);

min = 65536;

for i = 1:row
    for j = 1:col
        if (costs(i,j) < min)
            min = costs(i,j);
            dx = j; dy = i;
        end
    end
end




