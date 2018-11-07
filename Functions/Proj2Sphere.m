function [X_vp, Y_vp, Z_vp] = Proj2Sphere(R_matrix,vp_w,vp_h)

%the idea is to project in (az = 0; el = 0) and then rotate the viewport
el_o = 0;
az_o = 0;
R = 1;
if nargin< 3
vp_w = 2160; % one pixel 
vp_h = 1200;
end

% Resolution and size of viewport plane in (x_m,y_m) space. The scale is 
% the same as in (x,y,z) space.
% The x_max and y_mam params define the field of view attended by your 
% viewport (the sphere radius is 1).
% The x_step and y_step define the resolution of your viewport (linked to 
% the resolution of your viewport image).
x_max = 1; 
y_max = 0.55;
x_step = 2*x_max/(vp_w-1); % centroid of each pixel
y_step = 2*y_max/(vp_h-1); 

% Motion plane
[x_m,y_m] = meshgrid(-x_max:x_step:x_max,-y_max:y_step:y_max);
az_s = zeros(size(x_m));
el_s = zeros(size(x_m));
s_az_s = az_s;
s_el_s = el_s;

%% Projection on the sphere

    for r=1:size(x_m,1)
        for col=1:size(x_m,2)

            [az_s(r,col), el_s(r,col)] = iobliquegnomonic(x_m(r,col), y_m(r,col), ...
                el_o, az_o, R, 1);

        end

        % initialize sorted values
        s_az_s(r,:) = az_s(r,:);
        s_el_s(r,:) = el_s(r,:);
        % rearrange az_s and el_s if projection cross north or south pole
        if max(az_s(r,:))==pi || min(az_s(r,:))==-pi 
            if ~isequal(sort(az_s(r,:)), az_s(r,:))
                [s_az_s(r,:), az_ind] = sort(az_s(r,:));
                s_el_s(r,:) = el_s(r,az_ind);
            end
        end

    end

% from polar to cartesian coordinates
theta_vp = s_az_s;
theta_vp(theta_vp<0) = 2*pi + theta_vp(theta_vp<0);
phi_vp = s_el_s;
phi_vp(phi_vp>=0) = pi/2 - phi_vp(phi_vp>=0);
phi_vp(phi_vp<0) = pi/2 - phi_vp(phi_vp<0);
xs_vp = R.*sin(phi_vp).*cos(theta_vp);
ys_vp = R.*sin(phi_vp).*sin(theta_vp);
zs_vp = R.*cos(phi_vp);


X_vp = R_matrix(1,1) * xs_vp + R_matrix(1,2) * ys_vp + R_matrix(1,3)*zs_vp;
Y_vp = R_matrix(2,1) * xs_vp + R_matrix(2,2) * ys_vp + R_matrix(2,3)*zs_vp;
Z_vp = R_matrix(3,1) * xs_vp + R_matrix(3,2) * ys_vp + R_matrix(3,3)*zs_vp;

end

