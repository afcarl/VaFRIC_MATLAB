function FilterWithGaborAndSave

features3 = load('features_chair3.mat');
features3 = features3.features_chair3;
normalize_hha_features(features3);

features4 = load('features_chair4.mat');
features4 = features4.features_chair4;
normalize_hha_features(features4);

features5 = load('features_chair5.mat');
features5 = features5.features_chair5;
normalize_hha_features(features5);

features6 = load('features_chair6.mat');
features6 = features6.features_chair6;
normalize_hha_features(features6);

features7 = load('features_chair7.mat');
features7 = features7.features_chair7;
normalize_hha_features(features7);

features8 = load('features_chair8.mat');
features8 = features8.features_chair8;
normalize_hha_features(features8);

ApplyGaborFilters(features8,160,120,100,'features_chairs8_normalized');
ApplyGaborFilters(features7,160,120,100,'features_chairs7_normalized');
ApplyGaborFilters(features6,160,120,100,'features_chairs6_normalized');
ApplyGaborFilters(features5,160,120,100,'features_chairs5_normalized');
ApplyGaborFilters(features4,160,120,100,'features_chairs4_normalized');
ApplyGaborFilters(features3,160,120,100,'features_chairs3_normalized');

end