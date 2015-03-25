%function [rotatedpoints, normals, HHA] = rotate_pointcloud2groundplane(img_num, DenoiseddepthMap, rawDepthMap)
function [rotatedpoints, normals, HHA] = rotate_pointcloud2groundplane(img_num, depthMap)

[height, width] = size(depthMap);

points3d = rgb_plane2rgb_world_hxw(depthMap);

rotations = load('data/office_chair/camera_rotations_office_chair.txt');

SE3poses  = load('data/office_chair/exp_posesFile.txt');

R = rotations(1:3,1:3);

T_wc = SE3poses(1+3*(img_num-1):3*img_num,1:4);

P_w(:,:,1) = T_wc(1,1) * points3d(:,:,1) + T_wc(1,2) * points3d(:,:,2) + T_wc(1,3) * points3d(:,:,3) + T_wc(1,4);
P_w(:,:,2) = T_wc(2,1) * points3d(:,:,1) + T_wc(2,2) * points3d(:,:,2) + T_wc(2,3) * points3d(:,:,3) + T_wc(2,4);
P_w(:,:,3) = T_wc(3,1) * points3d(:,:,1) + T_wc(3,2) * points3d(:,:,2) + T_wc(3,3) * points3d(:,:,3) + T_wc(3,4);


rotatedpoints(:,:,1) = R(1,1)*P_w(:,:,1) + R(1,2)*P_w(:,:,2) + R(1,3)*P_w(:,:,3);
rotatedpoints(:,:,2) = R(2,1)*P_w(:,:,1) + R(2,2)*P_w(:,:,2) + R(2,3)*P_w(:,:,3);
rotatedpoints(:,:,3) = R(3,1)*P_w(:,:,1) + R(3,2)*P_w(:,:,2) + R(3,3)*P_w(:,:,3);

Xr = rotatedpoints(:,:,1);
Yr = rotatedpoints(:,:,2);
Zr = rotatedpoints(:,:,3);

normals = zeros(height,width,3);

b_x_u = [Xr(2:end,:)-Xr(1:end-1,:); zeros(1,width)];
b_y_u = [Yr(2:end,:)-Yr(1:end-1,:); zeros(1,width)];
b_z_u = [Zr(2:end,:)-Zr(1:end-1,:); zeros(1,width)];


a_x_r = [Xr(:,2:end)-Xr(:,1:end-1)  zeros(height,1)];
a_y_r = [Yr(:,2:end)-Yr(:,1:end-1)  zeros(height,1)];
a_z_r = [Zr(:,2:end)-Zr(:,1:end-1)  zeros(height,1)];


normals(:,:,1) = a_y_r.*b_z_u - a_z_r.*b_y_u;
normals(:,:,2) = a_z_r.*b_x_u - a_x_r.*b_z_u;
normals(:,:,3) = a_x_r.*b_y_u - a_y_r.*b_x_u;

norm_normals = sqrt(normals(:,:,1).*normals(:,:,1) + normals(:,:,2).*normals(:,:,2) + normals(:,:,3).*normals(:,:,3));

normals(:,:,1) = normals(:,:,1)./norm_normals;
normals(:,:,2) = normals(:,:,2)./norm_normals;
normals(:,:,3) = normals(:,:,3)./norm_normals;


HHA(:,:,1) = uint8(31000./double(max(depthMap*100+200,100)));

height = rotatedpoints(:,:,2)*100;

HHA(:,:,2) = uint8(-height + 110);

ny = normals(:, :, 2);

HHA(:,:,3) = uint8((acosd(ny)/180)*255);

end
