function [point_intersections] = overall_intersection_quat(Users_cluster,UsersTraj_quat,i_frames)
%%%This function evaluates the overall intersection in a cluster given the
n_users = length(Users_cluster);
%Viewport information for Video in Xavier. and al database

vp_w = 36;  % 2160
vp_h = 20;   % 1200

R_matrix = quat2rotm([UsersTraj_quat(Users_cluster(1),i_frames,1) UsersTraj_quat(Users_cluster(1),i_frames,2) UsersTraj_quat(Users_cluster(1),i_frames,3) UsersTraj_quat(Users_cluster(1),i_frames,4)]);
[X_vp_1, Y_vp_1, Z_vp_1]= Proj2Sphere(R_matrix,vp_w,vp_h);

point_intersections = 0;


for i_user_2 = 2:n_users
    
    R_matrix = quat2rotm([UsersTraj_quat(Users_cluster(i_user_2),i_frames,1) UsersTraj_quat(Users_cluster(i_user_2),i_frames,2) UsersTraj_quat(Users_cluster(i_user_2),i_frames,3) UsersTraj_quat(Users_cluster(i_user_2),i_frames,4)]);
    [X_vp_2, Y_vp_2, Z_vp_2]= Proj2Sphere(R_matrix,vp_w,vp_h);
   
    
    VP_1 = [X_vp_1(:), Y_vp_1(:), Z_vp_1(:)];
    VP_2 = [X_vp_2(:), Y_vp_2(:), Z_vp_2(:)];
    
    %tot_point = (length(VP_1)*3+length(VP_2)*3);
    
    [point_intersections, X_vp_1, Y_vp_1, Z_vp_1] = overall_VPintersection(VP_1,VP_2);
    
    
end

if n_users < 2
    point_intersections = 1;
else
    point_intersections = point_intersections/(vp_h*vp_w);
end



end

