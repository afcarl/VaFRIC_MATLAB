function [hAll gravityAngle depthAll] = computeHeight_realKinect

RotGravity = [0.999892 0.013922 -0.00468165
           -0.013922 0.796715 -0.604194
           -0.00468165 0.604194 0.796823];

poses   = load('viorik_real_bedroom/exp_posesFile.txt');

total_imgs = 650;

hAll = zeros(total_imgs,240,320);
gravityAngle = zeros(total_imgs,240,320);
depthAll = zeros(total_imgs,240,320);

for i = 1:total_imgs

    num = i;
    
fileName = sprintf('viorik_real_bedroom/raycastDepth_%04d.png',num)

cur_pose = poses(3*(num-1)+1:3*num,1:4);

R = cur_pose(1:3,1:3);
t = cur_pose(:,4);

depth = imread(fileName);
depth = double(depth)/5000.0;

u0 = 325.1/2.0;
v0 = 249.7/2.0;

fx = 520.9/2.0;
fy = 521.0/2.0;

W = 320;
H = 240;

[u v] = meshgrid(1:W,1:H);

X = depth.*(u - u0)/fx;
Y = depth.*(v - v0)/fy;
Z = depth;

XDash = R(1,1)*X + R(1,2)*Y + R(1,3)*Z + t(1);
YDash = R(2,1)*X + R(2,2)*Y + R(2,3)*Z + t(2);
ZDash = R(3,1)*X + R(3,2)*Y + R(3,3)*Z + t(3);

%RotGravity = RotGravity';

XFloor = RotGravity(1,1)*XDash + RotGravity(1,2)*YDash + RotGravity(1,3)*ZDash;
YFloor = RotGravity(2,1)*XDash + RotGravity(2,2)*YDash + RotGravity(2,3)*ZDash;
ZFloor = RotGravity(3,1)*XDash + RotGravity(3,2)*YDash + RotGravity(3,3)*ZDash;

hAll(i,:,:) = ZFloor;

normals = compute_normals(depth);

normals_x = R(1,1)*normals(:,:,1) + R(1,2) * normals(:,:,2) + R(1,3)*normals(:,:,3);
normals_y = R(2,1)*normals(:,:,1) + R(2,2) * normals(:,:,2) + R(2,3)*normals(:,:,3);
normals_z = R(3,1)*normals(:,:,1) + R(3,2) * normals(:,:,2) + R(3,3)*normals(:,:,3);

normals_z_ = RotGravity(3,1)*normals_x + RotGravity(3,2)*normals_y + RotGravity(3,3)*normals_z;

gravityAngle(i,:,:) = acosd(normals_z_)/180.0;

depthAll(i,:,:) = depth;
end
end
