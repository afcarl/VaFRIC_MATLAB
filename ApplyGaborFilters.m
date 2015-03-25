function data = ApplyGaborFilters(hha_features, width, height, num_images,name)
%Vijay Badrinarayanan, Engineering Department, University of Cambridge, UK.
%This function reads the train and test data for the NYU dataset.

hha = permute(hha_features,[3 4 2 1]);

% normals = zeros(480,640,3,numTrain,'single');
% regmask  = false(480,640,numTrain);
% temp = zeros(480,640,3,'single');
load('Gabor11.mat','F');
F = single(F);
% Fhhadnormals = zeros(size(hha,4),38*3,256,256,'single');
Fhha = zeros(num_images,38*3,height,width,'single');
start = 1;
endF = 100;
for i = start:endF
    display(num2str(i));

        hhaIm = hha(:,:,:,i);      
        for k = 1:size(F,3)
          Fhha(i-start+1,k,:,:) = single((conv2(hhaIm(:,:,1),F(:,:,k),'same')));          
          Fhha(i-start+1,k+38,:,:) = single((conv2(hhaIm(:,:,2),F(:,:,k),'same')));          
          Fhha(i-start+1,k+38*2,:,:) = single((conv2(hhaIm(:,:,3),F(:,:,k),'same')));          
        end
         
end

% save('FhhadnormalsTrain_part3Corrected.mat','Fhhadnormals','-v7.3');
fname = sprintf('GaborAugmented_hha_%s.mat',name);
save(fname,'Fhha','-v7.3');

end
