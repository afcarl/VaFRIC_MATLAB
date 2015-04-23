function verifyopenglrender(which_img)

% This is how Pangolin camera matrix should be initialised for this to
% work...
%     pangolin::OpenGlRenderState s_cam(
% //      ProjectionMatrixRDF_BottomLeft(640,480,520.9,521.0,325.1,249.7,0.1,1000),
%       ProjectionMatrixRDF_BottomLeft(640,480,480.0,480.0,319.5,239.5,0.1,1000),
%       ModelViewLookAt(3,3,3, 0,0,0, AxisNegZ)
%     );

poses = load('/home/ankur/workspace/code/kufrap/data/room_89_simple_data/room_89_simple_trajectory_random_poses_SE3_3x4.txt');

opengldepth = imread(sprintf('/home/ankur/workspace/code/kufrap/data/room_89_simple_data/scenedepth_00_%04d.png',which_img));

opengldepth = double(opengldepth)/50.0;

% opengldepth = flip(opengldepth,2);

W = 640;
H = 480;

u0 = 319.5;
v0 = 239.5;

[U V] = meshgrid(1:W,1:H);

fx =   480.0;
fy =  -480.0;

X  = opengldepth.*(U - u0)/fx;
Y  = opengldepth.*(V - v0)/fy;
Z  = opengldepth;

cur_pose = [poses(3*which_img+1:3*which_img+3,1:4) ; 0 0 0 1]

T = eye(4);%[-1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];

cur_pose = T' * cur_pose * T;

R = cur_pose(1:3,1:3);
t = cur_pose(1:3,4);

Y = R(2,1) * X + R(2,2) * Y + R(2,3) * Z + t(2);

figure, imagesc(Y);

end