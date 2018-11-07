function [point_intersection,X_vp_1,Y_vp_1,Z_vp_1] = overall_VPintersection(VP_1, VP_2)
% Given viewport position on tje sphere, this function found point of intersection
%
% Author: s.rossi@ucl.ac.uk
%


%%2 vps x time
X_vp_1 = VP_1(:,1);
Y_vp_1 = VP_1(:,2);
Z_vp_1 = VP_1(:,3);

X_vp_2 = VP_2(:,1);
Y_vp_2 = VP_2(:,2);
Z_vp_2 = VP_2(:,3);

pos=1;
for i = 1:length(X_vp_1)

        
    dist =  acos(dot(repmat([X_vp_1(i),Y_vp_1(i),Z_vp_1(i)],[length(X_vp_2),1]),...
            [X_vp_2(:),Y_vp_2(:),Z_vp_2(:)],2));
         
      
    if ~isempty(find(dist<0.05))

        %c=find(dist==min(dist));
        X_vp_1_new(pos) = X_vp_1(i);
        Y_vp_1_new(pos) = Y_vp_1(i);
        Z_vp_1_new(pos) = Z_vp_1(i);



        pos = pos + 1;

    end
end
    
    if exist('X_vp_1_new')
        X_vp_1 = X_vp_1_new;
        Y_vp_1 = Y_vp_1_new;
        Z_vp_1 = Z_vp_1_new;
        point_intersection = length(X_vp_1);
        clear X_vp_1_new Y_vp_1_new Z_vp_1_new
    else
        X_vp_1 = [];
        Y_vp_1 = [];
        Z_vp_1 = [];
        point_intersection = 0;
        return
    end

end

function [ xyz , phi, theta ] = QuaternionToCartesian(q )
%This function takes in input quaternion values(vector q) and converts
%to cartesian (xyz) and spherical coordinates (phi,theta)
%%% Example:
%%% QuaternionToCartesian([0.03693784403562278,-0.006942703182342886,0.00607127185627635,-0.9992748178914548]);



%1) Evaluate rotation matrix R

R=quat2rotm(q);

%2) Apply a rotation around [1 0 0]

xyz=R*[1 0 0]';         %Cartesian Coord

phi=acos(xyz(3));
theta=atan2(xyz(2),xyz(1));

end

