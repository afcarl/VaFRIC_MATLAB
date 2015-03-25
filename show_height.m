function show_height(img_num)

txt_file = sprintf('scene_00_%04d.txt',img_num);
depth_file = sprintf('scene_00_%04d.depth',img_num);

[x, y, z] = compute3Dpositions(txt_file,depth_file);
[R t] = computeRT(txt_file)

T = [-1 0 0 0; 0 1 0 0 ; 0 0 1 0; 0 0 0 1];


Rt = T * [R t; zeros(1,3) 1] * T'

R = Rt(1:3,1:3);
det(R)
t = Rt(:,4)

z_new = R(3,1)*x + R(3,2)*y + R(3,3)*z + t(3);
x_new = R(1,1)*x + R(1,2)*y + R(1,3)*z + t(1);
y_new = R(2,1)*x + R(2,2)*y + R(2,3)*z + t(2);

figure, imagesc(y_new);

width = 640;
b_x_u = [x(2:end,:)-x(1:end-1,:); zeros(1,width)];
b_y_u = [y(2:end,:)-y(1:end-1,:); zeros(1,width)];
b_z_u = [z(2:end,:)-z(1:end-1,:); zeros(1,width)];

height = 480;

a_x_r = [x(:,2:end)-x(:,1:end-1)  zeros(height,1)];
a_y_r = [y(:,2:end)-y(:,1:end-1)  zeros(height,1)];
a_z_r = [z(:,2:end)-z(:,1:end-1)  zeros(height,1)];


normals(:,:,1) = a_y_r.*b_z_u - a_z_r.*b_y_u;
normals(:,:,2) = a_z_r.*b_x_u - a_x_r.*b_z_u;
normals(:,:,3) = a_x_r.*b_y_u - a_y_r.*b_x_u;

norm_normals = sqrt(normals(:,:,1).*normals(:,:,1) + normals(:,:,2).*normals(:,:,2) + normals(:,:,3).*normals(:,:,3));

normals(:,:,1) = normals(:,:,1)./norm_normals;
normals(:,:,2) = normals(:,:,2)./norm_normals;
normals(:,:,3) = normals(:,:,3)./norm_normals;


normals_img(:,:,1) = R(1,1)*normals(:,:,1) + R(1,2)*normals(:,:,2) + R(1,3)*normals(:,:,3);
normals_img(:,:,2) = R(2,1)*normals(:,:,1) + R(2,2)*normals(:,:,2) + R(2,3)*normals(:,:,3);
normals_img(:,:,3) = R(3,1)*normals(:,:,1) + R(3,2)*normals(:,:,2) + R(3,3)*normals(:,:,3);

figure, imagesc((1+normals_img(1:2:end,1:2:end,:))/2);
end
