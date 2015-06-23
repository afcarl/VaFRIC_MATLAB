function Heights = computeHeight_openglrender

H = 480;
W = 640;

fx = 520.9;
fy = 521.0;

u0 = 325.1;
v0 = 249.7;

Heights = zeros(1500,H,W);

poses = load('/home/ankur/workspace/code/kufrap/data/living-room_data/living-room_trajectory_random_poses_SE3_3x4.txt');

T = eye(4);%[-1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];

for i = 1:600
	
       i
    
      depthFileName = sprintf('/home/ankur/workspace/code/kufrap/data/living-room_data/scenedepth_00_%04d.png',i);
      
      depth = imread(depthFileName);
      
      depth = double(depth)/50.0;
      
      depth = flip(depth,2); 
     
      [U V] = meshgrid(1:W,1:H);

      X = depth.*(U - u0)/fx;
      Y = depth.*(V - v0)/fy;
      Z = depth;
      
      cur_pose = [poses(3*i+1:3*i+3,1:4);0 0 0 1];
      
      cur_pose = T' * cur_pose * T;
      
      cur_pose
      
      R = cur_pose(1:3,1:3);
      t = cur_pose(1:3);

      XDash = R(1,1)*X + R(1,2)*Y + R(1,3)*Z + t(1);
      YDash = R(2,1)*X + R(2,2)*Y + R(2,3)*Z + t(2);
      ZDash = R(3,1)*X + R(3,2)*Y + R(3,3)*Z + t(3);
      
      Heights(i,:,:) = -YDash;	

end


end
