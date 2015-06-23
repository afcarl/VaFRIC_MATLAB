function [height, R] = getHeightOpenglModel(depth, scene_dir, fileNum, scale)

im = depth;

u = repmat([1:640/scale],480/scale,1);
v = repmat([1:480/scale]',1,640/scale);

u0 = 320/scale;
v0 = 240/scale;
fx = 420/scale; 
fy = -420/scale;

X = ((u-u0)/fx).*im;
Y = ((v-v0)/fy).*im;
Z = im;


T = [ 1 0 0 0; 
      0 1 0 0; 
      0 0 1 0; 
      0 0 0 1];


pose = load(sprintf('~/workspace/code/kufrap/data/%s/pose_%07d.txt',scene_dir,fileNum));

cur_pose = [pose; 0 0 0 1];

pose_ = T' * cur_pose * T;



% XDash = pose_(1,1).*X + pose_(1,2).*Y + pose_(1,3).*Z + pose_(1,4);
YDash = pose_(2,1).*X + pose_(2,2).*Y + pose_(2,3).*Z + pose_(2,4);
% ZDash = pose_(3,1).*X + pose_(3,2).*Y + pose_(3,3).*Z + pose_(3,4);

YDash(im==0)=0;

% figure; imagesc(YDash);

height = YDash;

R = pose_(1:3,1:3);
% figure; imagesc(XDash);
% figure; imagesc(ZDash);


end
