function normals = compute_normals(depth, width, height, scale)

[U V] = meshgrid(1:width/scale,1:height/scale);

fx = 420/scale;
fy = 420/scale;

u0 = 320/scale;
v0 = 240/scale;

x = ((U-u0)/fx).*depth;
y = ((V-v0)/fy).*depth;
z = depth;


b_x_u = [x(2:end,:)-x(1:end-1,:); zeros(1,width/scale)];
b_y_u = [y(2:end,:)-y(1:end-1,:); zeros(1,width/scale)];
b_z_u = [z(2:end,:)-z(1:end-1,:); zeros(1,width/scale)];


a_x_r = [x(:,2:end)-x(:,1:end-1)  zeros(height/scale,1)];
a_y_r = [y(:,2:end)-y(:,1:end-1)  zeros(height/scale,1)];
a_z_r = [z(:,2:end)-z(:,1:end-1)  zeros(height/scale,1)];


normals(:,:,1) = a_y_r.*b_z_u - a_z_r.*b_y_u;
normals(:,:,2) = a_z_r.*b_x_u - a_x_r.*b_z_u;
normals(:,:,3) = a_x_r.*b_y_u - a_y_r.*b_x_u;

norm_normals = sqrt(normals(:,:,1).*normals(:,:,1) + normals(:,:,2).*normals(:,:,2) + normals(:,:,3).*normals(:,:,3)) + 1e-6;

normals(:,:,1) = normals(:,:,1)./(norm_normals+1e-6);
normals(:,:,2) = normals(:,:,2)./(norm_normals+1e-6);
normals(:,:,3) = normals(:,:,3)./(norm_normals+1e-6);

