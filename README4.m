% CompE565 Homework 4
% April 16, 2016
% Name: Benjamin Hunt(815841735), Yusuf Shaikh(816921177)
% Email: btjammin@sbcglobal.net, yusufsh23@gmail.com

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Homework4 is essentially the combination of the previous three homeworks.
% It includes sub/upsampling functions from Homework1, the DCT,
% quantization, and zigzag functions from Homework2, and the motion estimation 
% functions from Homework3. We had to combine the functions, many of which
% call each other, into a single program. The video file is broken into
% frames, each frame is treated like a single picture where it is
% compressed. Then motion estimation is performed on the group, using the
% first frame as the I-frame, with subsequent P-frames.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running "Project4"...');
Execute;  % invoke M-file