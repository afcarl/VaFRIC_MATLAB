function normalize_hha_features(features)

min_height = min(min(min(features(:,2,:,:))));
max_height = 3;

for i = 1:size(features,1)

    features(i,1,:,:) = features(i,1,:,:)./max(max(features(i,1,:,:)));
    
    features(i,2,:,:) = ( features(i,2,:,:) - min_height ) / (max_height - min_height);
    
end