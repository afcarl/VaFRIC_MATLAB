function hha_features = convert_dha2hha

features8 = load('features_chair8.mat');
features8 = invd_height_uint8(features8.features_chair8);

features7 = load('features_chair7.mat');
features7 = invd_height_uint8(features7.features_chair7);

features6 = load('features_chair6.mat');
features6 = invd_height_uint8(features6.features_chair6);

features5 = load('features_chair5.mat');
features5 = invd_height_uint8(features5.features_chair5);

features4 = load('features_chair4.mat');
features4 = invd_height_uint8(features4.features_chair4);

features3 = load('features_chair3.mat');
features3 = invd_height_uint8(features3.features_chair3);

hha_features = cat(1,features3,features4,features5,features6,features7,features8);

end

function hha = invd_height_uint8(features)

features(:,1,:,:) = uint8(31000./(max(features(:,1,:,:)*100,100)));
features(:,2,:,:) = uint8(features(:,2,:,:)*100);
features(:,3,:,:) = uint8(features(:,3,:,:)*255);

hha = features;

end
