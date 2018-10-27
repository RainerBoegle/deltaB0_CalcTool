function VOISize_deltaB = Calc_deltaB(VOI_k,ParameterStruct,B_0,B_0_Orientation)
% This function calculates the field inhomogeneities in "VOISize" for
% the given B_0 orientation and strength.
%   1.) The B_0_Orientation is checked and brought in a suitable format for the calculation.
%       (Right now this is just the conversion from degrees to rad. 
%        In the future this code has to change when real 3D orientations are implemented. Euler???)
%   2.) The k-space scaling factor repressenting the dipole response of the system (in k-space)
%       is calculated using the information about the B_0_Orientation.
%   3.) The k-space scaling factor is circshifted for proper multiplication with the Fourier transformed susceptibility distribution
%       after Lorentz SPHERE correction! 
%           (The original/input susceptibility distribution has not been shifted by the "prep_VOI_distribution" function and
%            the resulting deltaB0_k field in k-space will not be shifted also, because this is not necessary and more importantly,
%            it SAVES A LITTLE BIT OF COMPUTATION TIME!)
%   4.) Calculation of deltaB in k-space.
%   5.) Inverse Fourier transform of VOISize_deltaB_k to obtain VOISize_deltaB
%           BUT KEEP IN MIND THAT WE NEED TO TAKE THE REAL PART OF THIS TO
%           OBTAIN THE B0 FIELD INHOMOGENEITIES. 
%   6.) TAKE REAL PART OF TO BE FINAL RESULT! (return value/array: VOISize_deltaB)
%
%INPUT:
%       VOI_k           -- The Fourier transformation of the spatially padded (VOISize) susceptibility distribution Chi repressenting the object which is imaged.
%                             (The Format is always (y,x,z). Maybe this needs to be rethought in the future.) 
%       B_0             -- The nominal B0 field strength of the Scanner in TESLA (e.g. 2.8936 for INUMAC Trio)
%       B_0_Orientation -- Orientation of the field to the Object as determined from the data from the motion tracking system/sequence and the starting position of the object repressented through the susceptibilty distribution
%                          (right now only coronal rotations are considered.)
%                          GIVEN IN DEGREES, THEN CONVERTED INTO RADIANS!
%       ParameterStruct -- A Structure containing all parameters regarding the susceptibility distribution 
%
%                          The ORIGINAL ParameterStruct input into "prep_VOI_distribution.m"
%                          should contain the following parameters:
%                              ParameterStruct.(ORG)
%                                              Size_x_Chi
%                                              Size_y_Chi
%                                              Size_z_Chi
%                                              FOV_x_Chi
%                                              FOV_y_Chi
%                                              FOV_z_Chi
%                                              Res_x  <-- the same for Chi and the padded VOI
%                                              Res_y  <-- the same for Chi and the padded VOI
%                                              Res_z  <-- the same for Chi and the padded VOI
%                                              Size_x_VOI
%                                              Size_y_VOI
%                                              Size_z_VOI
%                                              FOV_x_VOI
%                                              FOV_y_VOI
%                                              FOV_z_VOI
%                                              FOV_k_x_VOI
%                                              FOV_k_y_VOI
%                                              FOV_k_z_VOI
%                                              Res_k_x_VOI
%                                              Res_k_y_VOI
%                                              Res_k_z_VOI
% 
%                                              MR_invisible (only needed for use in "deltaB_2_FM.m",
%                                                            it might be most convenient to produce
%                                                            this with the susceptibility distribution Chi.)
%OUTPUT:
%       VOISize_deltaB           -- The field inhomogeneity from the padded susceptibility distribution, which is thus in "VOISize"==Size VOI has as a result of spatial padding of Chi.
%                                      (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%Example Call:
%               VOISize_deltaB = Calc_deltaB(VOI_k,ParameterStruct,B_0,   B_0_Orientation);
%               VOISize_deltaB = Calc_deltaB(VOI_k,ParameterStruct,2.8936,    30         );
%
%Author: Rainer B�gle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.04.05

%% 0.) Constants

gamma = 42575575; % Hydrogen gyromagnetic ratio in Hz/Tesla.


%% 1.) B0 Orientation
% WIP: Check Convention from Scanner/motion tracking and bring into suitable form for calculation.
alpha_radians= B_0_Orientation .* 2.*pi ./360;

%% 2.)
%k-space grid
if mod(ParameterStruct.Size_x_VOI, 2) == 0
    [kx_pos] = [(-ParameterStruct.FOV_k_x_VOI/2):(ParameterStruct.Res_k_x):(ParameterStruct.FOV_k_x_VOI/2-ParameterStruct.Res_k_x)];
else
    [kx_pos] = [(-(ParameterStruct.FOV_k_x_VOI - ParameterStruct.Res_k_x)/2):(ParameterStruct.Res_k_x):((ParameterStruct.FOV_k_x_VOI - ParameterStruct.Res_k_x)/2)];
end

if mod(ParameterStruct.Size_y_VOI, 2) == 0
    [ky_pos] = [(-ParameterStruct.FOV_k_y_VOI/2):(ParameterStruct.Res_k_y):(ParameterStruct.FOV_k_y_VOI/2-ParameterStruct.Res_k_y)];
else
    [ky_pos] = [(-(ParameterStruct.FOV_k_y_VOI - ParameterStruct.Res_k_y)/2):(ParameterStruct.Res_k_y):((ParameterStruct.FOV_k_y_VOI - ParameterStruct.Res_k_y)/2)];
end

if mod(ParameterStruct.Size_z_VOI, 2) == 0
    [kz_pos] = [(-ParameterStruct.FOV_k_z_VOI/2):(ParameterStruct.Res_k_z):(ParameterStruct.FOV_k_z_VOI/2-ParameterStruct.Res_k_z)];
else
    [kz_pos] = [(-(ParameterStruct.FOV_k_z_VOI - ParameterStructRes_k_z)/2):(ParameterStruct.Res_k_z):((ParameterStruct.FOV_k_z_VOI - ParameterStruct.Res_k_z)/2)];
end

%Lorentz corrected k-space scaling factor; -the Lorentz corrected dipole response in k-space!
%(!This has to be changed in the future to match the convention of the motion tracking system!)
LC_m_ScalingFactor= zeros(ParameterStruct.Size_y_VOI, ParameterStruct.Size_x_VOI, ParameterStruct.Size_z_VOI);
for k= 1:ParameterStruct.Size_z_VOI
    for j= 1:ParameterStruct.Size_y_VOI
    k2_z= (kz_pos(k).*cos(alpha_radians) + ky_pos(j).*sin(alpha_radians)).^2; %k'_z squared
        k_y_z_squared= k2_z + (ky_pos(j).*cos(alpha_radians) - kz_pos(k).*sin(alpha_radians)).^2; %Need Norm of k squared (first step) k'^2_z + k'^2_y
        for i= 1:ParameterStruct.Size_x_VOI
            k_norm_squared= k_y_z_squared + kx_pos(i).^2; %Norm of k squared (second and last step) k'^2_x= k^2_x because this is a rotation about the x-axis. (Check with convention of Tracking System.
            if ( ( k_norm_squared ~= 0 ) ) % ( (kx_pos(i).^2 + ky_pos(j).^2 + kz_pos(k).^2) ~= 0) ) %
                LC_m_ScalingFactor(j, i, k)= 1/3 - (k2_z ./ (k_norm_squared));
            else
                disp([num2str(k_norm_squared)]);
                if ( ( k_norm_squared == 0 ) ) % ( (kx_pos(i).^2 + ky_pos(j).^2 + kz_pos(k).^2) == 0)
                    LC_m_ScalingFactor(j, i, k)= 1/3; %ScalingFactor == 0! It should be tested again if the whole function can be set to another value. For example LC_m_ScalingFactor(k=0) = 0 works if Chi is padded enough, because this k=0 point of the scaling factor specifies the field in a Lorentz sphere at boundary and this can be zero. Thus, the whole factor(the whole function at this point) can be zero. -It seems to me.
                end
            end
        end
    end
end

%% 3.)
%circshift for proper multiplication
LC_m_ScalingFactor= circshift(LC_m_ScalingFactor, [-floor(ParameterStruct.Size_y_VOI/2), -floor(ParameterStruct.Size_x_VOI/2), -floor(ParameterStruct.Size_z_VOI/2)]); %Origin to left upper corner!  (Because Matlab (or FFT) wants (1,1,1) there!!!)

%% 4.)
%Calc deltaB in k-Space
VOISize_deltaB_k = gamma .* B_0 .* (LC_m_ScalingFactor) .* VOI_k; %deltaB in k-Space!!!

%% 5.)
% iFFT
VOISize_deltaB = ifft(VOISize_deltaB_k, [], 1);
VOISize_deltaB = ifft(VOISize_deltaB,   [], 2);
VOISize_deltaB = ifft(VOISize_deltaB,   [], 3);

%% 6.)
VOISize_deltaB = real(VOISize_deltaB);

