function features = compute_opengl_dhac(scene_dir)

max_imgs = 1463;

desired = 411;

offset = uint16(max_imgs/desired);

n_imgs = uint16(max_imgs/offset);

features = zeros(120,160,5,n_imgs+1);

count = 0;

for i = 0:offset:min(n_imgs*offset,max_imgs)                                                                                                                                                                                                                                    
    
    i
    
    img = imread(sprintf('/home/ankur/workspace/code/kufrap/data/%s/scenedepth_00_%07d.png',scene_dir,i));
    
    img = double(img)/50;    
    img(img>50)=0;   
    
    label = imread(sprintf('/home/ankur/workspace/code/kufrap/data/%s/label_00_%07d.png',scene_dir,i));
    
    depth = img;
    
    depth = imresize(depth,0.25,'bicubic');  
    img_4 = img(1:4:480,1:4:640);
    
    depth(img_4==0) =0;
    
    [height, R] = getHeightOpenglModel(depth,scene_dir,i,4);
    
    R = [-1 0 0; 0 1 0; 0 0 -1] * R * [-1 0 0; 0 1 0; 0 0 -1];
    
    normals = compute_normals(depth,640,480,4);
    
    normals_img(:,:,1) = R(1,1)*normals(:,:,1) + R(1,2)*normals(:,:,2) + R(1,3)*normals(:,:,3);
    normals_img(:,:,2) = R(2,1)*normals(:,:,1) + R(2,2)*normals(:,:,2) + R(2,3)*normals(:,:,3);
    normals_img(:,:,3) = R(3,1)*normals(:,:,1) + R(3,2)*normals(:,:,2) + R(3,3)*normals(:,:,3);
    
    normals_abs_x = abs(normals_img(:,2:end,1) -normals_img(:,1:end-1,1)) + abs(normals_img(:,2:end,2) -normals_img(:,1:end-1,2)) + abs(normals_img(:,2:end,3) -normals_img(:,1:end-1,3));
    normals_abs_x = [normals_abs_x zeros(size(normals_abs_x,1),1)];
    normals_abs_y = abs(normals_img(2:end,:,1) -normals_img(1:end-1,:,1)) + abs(normals_img(2:end,:,2) -normals_img(1:end-1,:,2)) + abs(normals_img(2:end,:,3) -normals_img(1:end-1,:,3));
    normals_abs_y = [normals_abs_y; zeros(1,size(normals_abs_x,2))];
    normals_abs = sqrt(normals_abs_x.^2 + normals_abs_y.^2); 
    
    normals_exp = 1 - exp(-normals_abs/0.2);
    
    normals_exp(isinf(normals_exp))=0;
    normals_exp(isnan(normals_exp))=0;
    
    angle_with_gravity = acosd(normals_img(:,:,2))/180.0;    
    angle_with_gravity(isnan(angle_with_gravity))=0;
    angle_with_gravity(isinf(angle_with_gravity))=0;
    
    features(:,:,1,count+1) = depth;
    features(:,:,2,count+1) = height;
    features(:,:,3,count+1) = angle_with_gravity;
    features(:,:,4,count+1) = normals_exp;
    features(:,:,5,count+1) = label(1:4:480,1:4:640);
%     features(:,:,6:8,i+1) = normals_img;
       
    count = count + 1;
end

if ( count -1 < size(features,4) )
    features(:,:,:,count+1:n_imgs+1) = [];
end

features = permute(features, [4 3 1 2]);

unique(features(:,5,:,:))

labels = features(:,5,:,:);

labels_floor = labels == 1;
labels_ceiling = labels == 2;
labels_wall = labels == 3;
labels_chair = labels == 5;
labels_table = labels == 13;

labels_unknown = labels == 17;


labels(labels_chair) = 4;
labels(labels_table) = 5;
labels(labels_unknown) = 3;

% max_label = max(max(max(labels)))

% labels_max = labels == max_label;

% labels(labels_max)=4;

annot = get_annotations_from_labels_bedroom(labels,5);

data.train = features(:,1:4,:,:);
data.trainannot = annot;

size(annot)


data_fileName = sprintf('data_%s.mat',scene_dir);

save(data_fileName,'data','-v7.3');

% features = [];

% annot = get_annotations_from_labels_bedroom(labels,17);

% save('features_SceneFiles.mat','features','-v7.3');

end