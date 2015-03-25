function plot_heights_random_images(hAll,width,height,max_imgs)

%hAll should be of the size num, width, height

num = 10;
h_plot = zeros(height*num,width*num);

random_ind = randi(max_imgs,16);

for y = 1:num
    for x = 1:num
        
        ind = random_ind(x,y);
        
        
        
        h_plot(height*(y-1)+1:height*y,width*(x-1)+1:width*x) = squeeze(hAll(ind,:,:));
        
    end
end

figure, imagesc(h_plot);


end
