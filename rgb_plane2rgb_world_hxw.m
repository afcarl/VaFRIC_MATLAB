function points3d = rgb_plane2rgb_world_hxw(imgDepth)
  %camera_params;

  [H, W] = size(imgDepth);
  
  points3d = zeros(H,W,3);

  %    float2 fl              = make_float2(520.9f,521.0f)/scale;
  %  float2 pp              = make_float2(325.1f,249.7f)/scale;

  fx_rgb = 520.9 * W/640;
  fy_rgb = 521.0 * H/480;
  
  cx_rgb = 325.1 * W/640;
  cy_rgb = 249.7 * H/480;
  
  % Make the original consistent with the camera location:
  [xx, yy] = meshgrid(1:W, 1:H);

  x3 = (xx - cx_rgb) .* imgDepth / fx_rgb;
  y3 = (yy - cy_rgb) .* imgDepth / fy_rgb;
  z3 = imgDepth;
  
  points3d(:,:,1) = x3;
  points3d(:,:,2) = y3;
  points3d(:,:,3) = z3;
	
  %points3d = [x3(:) -y3(:) z3(:)];
end
