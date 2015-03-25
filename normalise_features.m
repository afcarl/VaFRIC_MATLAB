features_chair3(:,1,:,:) = features_chair3(:,1,:,:)/max_d;
features_chair4(:,1,:,:) = features_chair4(:,1,:,:)/max_d;
features_chair5(:,1,:,:) = features_chair5(:,1,:,:)/max_d;
features_chair6(:,1,:,:) = features_chair6(:,1,:,:)/max_d;
features_chair7(:,1,:,:) = features_chair7(:,1,:,:)/max_d;
features_chair8(:,1,:,:) = features_chair8(:,1,:,:)/max_d;

features_chair3(:,2,:,:) = (features_chair3(:,2,:,:)-min_h)/(max_h-min_h);
features_chair4(:,2,:,:) = (features_chair4(:,2,:,:)-min_h)/(max_h-min_h);
features_chair5(:,2,:,:) = (features_chair5(:,2,:,:)-min_h)/(max_h-min_h);
features_chair6(:,2,:,:) = (features_chair6(:,2,:,:)-min_h)/(max_h-min_h);
features_chair7(:,2,:,:) = (features_chair7(:,2,:,:)-min_h)/(max_h-min_h);
features_chair8(:,2,:,:) = (features_chair8(:,2,:,:)-min_h)/(max_h-min_h);

