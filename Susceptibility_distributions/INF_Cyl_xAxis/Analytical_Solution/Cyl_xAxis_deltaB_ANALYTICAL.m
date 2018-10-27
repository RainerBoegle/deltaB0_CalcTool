function analytic_b0_field= Cyl_xAxis_deltaB_ANALYTICAL(Size_x, Size_y, Size_z, FOV_x, FOV_y, FOV_z, Radius, chi_int, chi_ext, B_0, y0, z0)
%analytic Solution for Sphere in Magnetic Field B_0
%analytic_b0_field= Cylinder_deltaB(Size_x, Size_y, Size_z, FOV_x, FOV_y, FOV_z, Radius, chi_int, chi_ext, B_0, y0, z0)
%
%analytic_b0_field(y,x,z) like always when using Matlab!
%
%B_0= 2.8936; %nominal field of INUMAC Trio
%Example:
% analytic_b0_field= Cyl_xAxis_deltaB_ANALYTICAL(Size_x, Size_y, Size_z, FOV_x, FOV_y, FOV_z, Radius, chi_int, chi_ext,    B_0, y0, z0);
% analytic_b0_field= Cyl_xAxis_deltaB_ANALYTICAL(   128,    128,    128, 0.256, 0.256, 0.256,   0.03, -9.2e-6,       0, 2.8936,  0,  0);
gamma = 42575575; % proton gyromagnetic ratio in Hz/T

disp('#####################################################################');
disp('Preparing analytical Solution of deltaB Field');
disp(['for a infinite Cylinder along the x-Axis of Radius ', num2str(Radius), 'm in a B Field of ', num2str(B_0), 'T(=' ,num2str(gamma*B_0), 'Hz) at (y0,z0)= (' ,num2str(y0),',' ,num2str(z0),').']);
disp(['with Susceptibilities of chi_intern= ', num2str(chi_int*10^6), 'ppm and chi_extern= ', num2str(chi_ext*10^6), 'ppm.']);
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
        SQ_of_y_sq_plus_z_sq= temp^2;
        for x = 1:Size_x
%             x_pos_squared = x_pos(x)^2;
            z_sq_minus_y_sq= z_pos_squared - y_pos_squared;
%             if ( abs(x_pos(x)) <= Percent * fovx/2 )
                if ( temp <= r_squared ) %inside of Cylinder: 1/6 .* ((3 .* chi_extern) - chi_intern) .* B_0;
                    analytic_b0_field(y, x, z)= 1/6 .* ((3 .* chi_ext) - chi_int);
                else %outside of Cylinder
                    analytic_b0_field(y, x, z)= 1/2 .* ( (chi_int .* r_squared .* ((z_sq_minus_y_sq)./(SQ_of_y_sq_plus_z_sq))) + (( 1 - r_squared .* ((z_sq_minus_y_sq)./(SQ_of_y_sq_plus_z_sq)) ) .* chi_ext) );
                end
%             else %outside of Cylinder
%                 analytic_b0_field(x, y, z)= 1/2 .* ( chi_intern .* r_squared .* ((z_sq_minus_y_sq)./(SQ_of_y_sq_plus_z_sq)) + ( 1 - r_squared .* ((z_sq_minus_y_sq)./(SQ_of_y_sq_plus_z_sq)) ) .* chi_extern);
%             end
        end
    end
end

analytic_b0_field = gamma * B_0 * analytic_b0_field;

disp('...');
t=toc;
disp(['DONE! (Time needed: ' ,num2str(t), 's.)']);
disp('#####################################################################');
