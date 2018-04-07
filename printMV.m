function printMV(countt, motionVect )

   % We used this function is project 3. It is simply printing the movtion
   % Vector. The first few lines simply show the layout of how the ends of
   % the vectors will be plotted. We chose to evenly distribute it at space
   % of 20. We then set the figure at 200 x and 230 Y.
  
   x=[1    20    40    60    80    100    120   140   160];
   x_axis=[x x x x x x x x x x x];
   y=[1    20    40    60    80    100    120   140   160   180   199];
   y_axis=[y y y y y y y y y];


   figure %motion vector figure
   quiver(x_axis,y_axis,motionVect(2,:), motionVect(1,:))
   axis([-20 180 -20 210]);
   title(sprintf(' Motion Vectors: Frames between %d to %d',countt,countt+1));
end