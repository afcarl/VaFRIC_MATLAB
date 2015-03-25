function normals = compute_normals(depth)

width = 320;
height = 240;

scale = 2;

[U V] = meshgrid(1:width,1:height);

fx = 520.9/scale;
fy = 521.0/scale;

u0 = 325.1/scale;
v0 = 249.7/scale;

x = ((U-u0)/fx).*depth;
y = ((V-v0)/fy).*depth;
z = depth;


b_x_u = [x(2:end,:)-x(1:end-1,:); zeros(1,width)];
b_y_u = [y(2:end,:)-y(1:end-1,:); zeros(1,width)];
b_z_u = [z(2:end,:)-z(1:end-1,:); zeros(1,width)];


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

%imagesc((1+normals)/2);
