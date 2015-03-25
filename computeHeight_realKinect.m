function [hAll gravityAngle depthAll] = computeHeight_realKinect

% RotGravity = [0.999892 0.013922 -0.00468165
%            -0.013922 0.796715 -0.604194
%            -0.00468165 0.604194 0.796823];
       
%all_chairs       
RotGravity = [0.981318 -0.184773 0.0536018
              0.184773 0.827522 -0.530157
              0.0536018 0.530157 0.846204];       
       

          
base_dir = '/home/ankur/workspace/code/kufrap/data/all_chairs'

width  = 640;
height = 480;


poses   = load(sprintf('%s/exp_posesFile.txt',base_dir));

total_imgs = 650;

hAll = zeros(total_imgs,height,width);
gravityAngle = zeros(total_imgs,height,width);
depthAll = zeros(total_imgs,height,width);

for i = 1:total_imgs

    num = i;
    
    fileName = sprintf('%s/raycastDepth_%04d.png',base_dir,num)

    cur_pose = poses(3*(num-1)+1:3*num,1:4);
    
    R = cur_pose(1:3,1:3);
    t = cur_pose(:,4);

    depth = imread(fileName);
    depth = double(depth)/5000.0;

    u0 = 325.1;
    v0 = 249.7;

    fx = 520.9;
    fy = 521.0;

    W = width;
    H = height;

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
