function cost = costFuncMAD(currentBlk,refBlk, n)

error = 0;
for i = 1:n
    for j = 1:n
        error = error + abs((currentBlk(i,j) - refBlk(i,j)));
        
    end
end
cost = error / (n*n);

