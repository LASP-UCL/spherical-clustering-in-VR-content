function [az_s, el_s] = iobliquegnomonic(x_m,y_m, el_o, az_o, K, limitrange)

% Inverse oblique gnomonic projection: from point (x_m, y_m) on plane 
% tangent to the sphere at (el_o, az_o) to point (az_s, el_s) on the sphere
% surface. The center of the plane is at distance K from the sphere center.
% 'limitrange' = 0 or 1, clips azimuth range to [-pi pi].

% francesca.desimone@epfl.ch
%        F.De.Simone@cwi.nl
%

rho = sqrt(x_m^2 + y_m^2);
mu = atan(rho); % in radians: [-pi/2, pi/2]

az_s = az_o + atan2( x_m*sin(mu),...
    (K*(rho*cos(el_o)*cos(mu) - y_m*sin(el_o)*sin(mu))) );
if isnan(az_s)
    error(['azs NaN for xm=' num2str(x_m) 'ym=' num2str(y_m)])
end
if limitrange
    % clip az range to [-pi pi]
    if az_s>pi || az_s<-pi
        az_s = wrapToPi(az_s);
    end
    if az_s>pi || az_s<-pi
        error('az_s out of range')
    end
end
% THIS MIGHT BE WRONG WHEN K>1!
el_s = asin( (cos(mu)*sin(el_o)) + (y_m*sin(mu)*cos(el_o)/(K*rho)) );
if (y_m*sin(mu)*cos(el_o))==0 && (cos(mu)*sin(el_o))~=0
   el_s = asin( (cos(mu)*sin(el_o)));
end
if (y_m*sin(mu)*cos(el_o))==0 && (cos(mu)*sin(el_o))==0
    el_s = 0;
end
if isnan(el_s)
    disp(['els NaN for xm=' num2str(x_m) 'ym=' num2str(y_m)])
    if isnan(y_m*sin(mu)*cos(el_o)/(K*rho)) && y_m*sin(mu)*cos(el_o)==0
        el_s = 0;
    end
end
if el_s >pi/2 || el_s < -pi/2 
   error('el_s is out of range!')
end
