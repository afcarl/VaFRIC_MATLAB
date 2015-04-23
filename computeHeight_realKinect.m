function [hAll gravityAngle img_normals, depthAll] = computeHeight_realKinect

% RotGravity = [0.999892 0.013922 -0.00468165
%            -0.013922 0.796715 -0.604194
%            -0.00468165 0.604194 0.796823];
       
%all_chairs       
% RotGravity = [0.979762 0.19166 0.0577393
%              -0.19166 0.815034 0.546796
%               0.0577393 -0.546796 0.835273];

%scr chair
RotGravity  = [0.980317 0.189287 0.0561221
              -0.189287 0.820299 0.539704
               0.0561221 -0.539704 0.839982];

%office chair
% RotGravity = [0.991566 0.124096 0.0373761
%              -0.124096 0.825929 0.549947
%               0.0373761 -0.549947 0.834363];

          
base_dir = '/home/ankur/workspace/code/kufrap/data/all_chairs'

scale = 4;

width  = 640;
height = 480;

poses   = load(sprintf('%s/exp_posesFile.txt',base_dir));

total_imgs = 400;

hAll = zeros(total_imgs,height/scale,width/scale);
gravityAngle = zeros(total_imgs,height/scale,width/scale);
img_normals = zeros(total_imgs,height/scale,width/scale,3);
depthAll = zeros(total_imgs,height/scale,width/scale);

for i = 1:total_imgs

    num = i;
    
    fileName = sprintf('%s/raycastDepth_%04d.png',base_dir,num)

    cur_pose = poses(3*(num-1)+1:3*num,1:4);
    
    R = cur_pose(1:3,1:3);
    t = cur_pose(:,4);

    depth = imread(fileName);
    depth = double(depth)/5000.0;
    
    %depth = depth(1:scale:end,1:scale:end)
    depthsz = size(depth);
    depth = imresize(depth,[depthsz(1)/scale, depthsz(2)/scale],'cubic');

    u0 = 325.1/scale;
    v0 = 249.7/scale;

    fx = 520.9/scale;
    fy = 521.0/scale;

    W = width/scale;
    H = height/scale;

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

    hAll(i,:,:) = -YFloor;

    normals = compute_normals(depth,W,H, scale);

    normals_x = R(1,1)*normals(:,:,1) + R(1,2) * normals(:,:,2) + R(1,3)*normals(:,:,3);
    normals_y = R(2,1)*normals(:,:,1) + R(2,2) * normals(:,:,2) + R(2,3)*normals(:,:,3);
    normals_z = R(3,1)*normals(:,:,1) + R(3,2) * normals(:,:,2) + R(3,3)*normals(:,:,3);
    
    img_normals(i,:,:,1) = normals_x;
    img_normals(i,:,:,2) = normals_y;
    img_normals(i,:,:,3) = normals_z;
    
%     rgbImage(:,:,1) = uint8((1+normals_x)*127);
%     rgbImage(:,:,2) = uint8((1+normals_y)*127);
%     rgbImage(:,:,3) = uint8((1+normals_z)*127);
%     
%     imgFileName = sprintf('normals_%04d.png',i);
%     
%     imwrite(rgbImage,imgFileName,'png');

    normals_y_ = RotGravity(2,1)*normals_x + RotGravity(2,2)*normals_y + RotGravity(2,3)*normals_z;

    gravityAngle(i,:,:) = acosd(normals_y_)/180;

    depthAll(i,:,:) = depth;
end


end
