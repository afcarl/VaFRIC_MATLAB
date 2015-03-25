function noisy_depth = add_barronmalik_kinect_noise(clean_depth)

clean_disparity = 1./clean_depth;

g_shift_x = 0.5 * randn(size(clean_depth));
g_shift_y = 0.5 * randn(size(clean_depth));

width = size(clean_depth,2);
height = size(clean_depth,1);

x = repmat([1:width],height,1);
y = repmat([1:height]',1,width);

x_plus_gx = x + g_shift_x;
y_plus_gy = y + g_shift_y;

bilinear_depth = 1./interp2(clean_disparity,x_plus_gx,y_plus_gy);

noisy_depth = 35130./ floor( 35130./bilinear_depth + (1.0/6.0)*randn([height width]) + 0.5);

end
