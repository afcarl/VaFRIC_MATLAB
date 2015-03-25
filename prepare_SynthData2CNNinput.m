function [features, label] = prepare_SynthData2CNNinput

class_colours;

mapping = zeros(1,256*256*256);
mapping(colour_hash+1) = classes+1;
MappingSparse = sparse(mapping);

max_img = 123;
channels = 6;
height = 120;
width  = 160;

% count = 0;
% imgs2consider = [];
% 
% for i = 0:max_img-1
%     
%     i
%     
%     img = imread(sprintf('scene_00_%04d.png',i));
%     
%     r = double(img(:,:,1));
%     g = double(img(:,:,2));
%     b = double(img(:,:,3));
%     
%     colour_id = r + g*256.0 + b*256.0*256.0;
%     
%     label_class_img = MappingSparse(colour_id+1)-1;
%     
%     if ( size(unique(label_class_img),1) > 3 ) 
%         count = count + 1;
%         imgs2consider = [imgs2consider i];
%     end
% end
% 
% imgs2consider
% 
% count

features = zeros(100,channels,height,width);
label = zeros(100,1,height,width);

count = 1;

max_y =-1E20;
min_y = 1E20;
max_d =-1E20;

for i = 0:100
    
    img_num = i;
    
    txt_file   = sprintf('scene_00_%04d.txt',img_num);
    depth_file = sprintf('scene_00_%04d.depth',img_num);

    [x, y, z]  = compute3Dpositions(txt_file,depth_file);
    [R t] = computeRT(txt_file)

    T = [-1 0 0 0; 0 1 0 0 ; 0 0 1 0; 0 0 0 1];


    Rt = T * [R t; zeros(1,3) 1] * T'

    R = Rt(1:3,1:3);
    det(R)
    t = Rt(:,4)

    %z_new = R(3,1)*x + R(3,2)*y + R(3,3)*z + t(3);
    %x_new = R(1,1)*x + R(1,2)*y + R(1,3)*z + t(1);
    y_new = R(2,1)*x + R(2,2)*y + R(2,3)*z + t(2);
    
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
    
    
    angle_with_gravity = acosd(normals_img(:,:,2))/180.0;
    
    depth = z;
    
    cur_depth = max(max(depth(~isinf(depth))));
    
    depth(isnan(depth)) = 0;
    depth(isinf(depth)) = 0;
    
    
    
    cur_max = max(max(y_new(~isinf(y_new))));
    
    if ( cur_max > max_y )         
        max_y = cur_max;        
    end
    
    cur_min = min(min(y_new(~isinf(y_new))));
    
    if (cur_min <  min_y )
        min_y = cur_min;
    end
    
    y_new(isnan(y_new)) = 0;
    y_new(isinf(y_new)) = 0;
    
    img = imread(sprintf('scene_00_%04d.png',i));
    
    r = double(img(:,:,1));
    g = double(img(:,:,2));
    b = double(img(:,:,3));
   
    colour_id = r + g*256.0 + b*256.0*256.0;
    
    label_class_img = MappingSparse(colour_id+1)-1;           
    
    features(i+1,1,:,:) = depth(1:4:end,1:4:end);
    features(i+1,2,:,:) = y_new(1:4:end,1:4:end);
    features(i+1,3,:,:) = (normals(1:4:end,1:4:end,1)+1)/2;
    features(i+1,4,:,:) = (normals(1:4:end,1:4:end,2)+1)/2;
    features(i+1,5,:,:) = (normals(1:4:end,1:4:end,3)+1)/2;
    features(i+1,6,:,:) = angle_with_gravity(1:4:end,1:4:end);
    
    label(i+1,1,:,:) = label_class_img(1:4:end,1:4:end);
    
    count = count + 1;   
    
    if ( cur_depth > max_d )         
        max_d = cur_depth;
    end
    
end

[min_y max_y max_d]

count

end
