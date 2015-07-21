%clear all, close all

%depth = [1.111 2.222 3.333; 4.444 5.555 6.666; 7.777 8.888 9.999];
%height = [1.101 2.202 3.303; 4.404 5.505 6.606; 7.707 8.808 9.909];
%angle = [1.1001 2.2002 3.3003; 4.4004 5.5005 6.6006; 7.7007 8.8008 9.9009];

%load('BedroomsData_18classes.mat');

%features = data.train;
%labels = data.trainannot;

%listimgnamesbin = 'list_of_training_images_bin.txt';
%listimgnameslabel = 'list_of_training_labels.txt';

%imglist = fopen(listimgnamesbin,'w'); 
%labellist = fopen(listimgnameslabel,'w');

%foldername = './BedroomDataTraining/';

for count = 1:size(features,1)
    count
    imgname = sprintf('BedroomDataTraining/img-%07d.bin',count);
    file1 = fopen(imgname,'wb');
    labelname = sprintf('BedroomDataTraining/label-%07d.png',count);
    lbls = uint8(squeeze(labels(count,1,:,:)));
    imwrite(lbls,labelname);
    for i = 1:size(features,3)
        for j = 1:size(features,4)
            fwrite(file1,features(count,1,i,j),'float');
            fwrite(file1,features(count,2,i,j),'float');
            fwrite(file1,features(count,3,i,j),'float');            
        end
    end
    fclose (file1);
    %fprintf(imglist,'%s\n',imgname);
    %fprintf(labellist,'%s\n',labelname);
end

%fclose(imglist);
%fclose(labellist);
        

%fclose (file2);
