function analytic_b0_field= Sphere_deltaB_ANALYTICAL(Size_x, Size_y, Size_z, FOV_x, FOV_y, FOV_z, Radius, chi_int, chi_ext, B_0, x0, y0, z0)
%analytic Solution for Sphere in Magnetic Field B_0
%analytic_b0_field= Sphere_deltaB(Size_x, Size_y, Size_z, FOV_x, FOV_y, FOV_z, B_0)
%
%analytic_b0_field(y,x,z) like always when using Matlab!
%
%B_0= 2.8936; %nominal field of INUMAC Trio
%Example:
% analytic_b0_field= Sphere_deltaB_ANALYTICAL(Size_x, Size_y, Size_z, FOV_x, FOV_y, FOV_z, Radius, chi_int, chi_ext,    B_0, x0, y0, z0);
% analytic_b0_field= Sphere_deltaB_ANALYTICAL(128,       128,    128, 0.256, 0.256, 0.256,   0.03, -9.2e-6,       0, 2.8936,  0,  0,  0);
gamma = 42575575; % proton gyromagnetic ratio in Hz/T

disp('#####################################################################');
disp('Preparing analytical Solution of deltaB Field');
disp(['for a Sphere of Radius ', num2str(Radius), 'm in a B Field of ', num2str(B_0), 'T(=' ,num2str(gamma*B_0), 'Hz) at (x0,y0,z0)= (' ,num2str(x0),',' ,num2str(y0),',' ,num2str(z0),').']);
tic
disp(' ');
%pause

Res_x = FOV_x/Size_x;
Res_y = FOV_y/Size_y;
Res_z = FOV_z/Size_z;

%%

if mod(Size_x, 2) == 0
    [x_pos] = [(-FOV_x/2):(Res_x):(FOV_x/2-Res_x)];
else
    [x_pos] = [(-(FOV_x - Res_x)/2):(Res_x):((FOV_x - Res_x)/2)];
end

if mod(Size_y, 2) == 0
    [y_pos] = [(-FOV_y/2):(Res_y):(FOV_y/2-Res_y)];
else
    [y_pos] = [(-(FOV_y - Res_y)/2):(Res_y):((FOV_y - Res_y)/2)];
end

if mod(Size_z, 2) == 0
    [z_pos] = [(-FOV_z/2):(Res_z):(FOV_z/2-Res_z)];
else
    [z_pos] = [(-(FOV_z - Res_z)/2):(Res_z):((FOV_z - Res_z)/2)];
end

%%
r_squared= Radius^2;


analytic_b0_field = zeros(Size_y, Size_x, Size_z);
for z = 1:Size_z
    z_pos_squared = (z_pos(z)-z0)^2;
    for y = 1:Size_y
        y_pos_squared = (y_pos(y)-y0)^2;
        temp = y_pos_squared + z_pos_squared;
        for x = 1:Size_x
            x_pos_squared = (x_pos(x)-x0)^2;
            temp_ = temp + x_pos_squared;
            if (temp_ <= r_squared)
                analytic_b0_field(y, x, z) = 1/3 * chi_ext * B_0;
            else
                if (temp_ ~= 0)
                    analytic_b0_field(y, x, z) = 1/3 * (chi_int - chi_ext)* B_0 * Radius^3 * ...
                        (2*z_pos_squared-x_pos_squared-y_pos_squared) / ...
                        temp_^2.5 + chi_ext * B_0;
                end
            end
        end
    end
end

analytic_b0_field = gamma * analytic_b0_field;

disp('...');
t=toc;
disp(['DONE! (Time needed: ' ,num2str(t), 's.)']);
disp('#####################################################################');
