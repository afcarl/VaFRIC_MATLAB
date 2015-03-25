function plot_normal_random_images(hAll,width,height,max_imgs)

%hAll should be of the size num, width, height

num = 10;
h_plot = zeros(height*num,width*num,3);

random_ind = randi(max_imgs,16);

for y = 1:num
    for x = 1:num
        
        ind = random_ind(x,y);
        
        img = zeros(height,width,3);
        
        img(:,:,1) = hAll(ind,1,:,:);
        img(:,:,2) = hAll(ind,2,:,:);
        img(:,:,3) = hAll(ind,3,:,:);
        
%         img = (1+img)/2;
        
        h_plot(height*(y-1)+1:height*y,width*(x-1)+1:width*x,:) = img;
        
    end
end

figure, imagesc(h_plot);

end
