function [VOI_k, ParameterStruct, VOI] = prep_VOI_distribution(Chi,ParameterStruct,varargin)
% This function prepares the susceptibility distribution for further
% calculation of the B0 field inhomogeneities.
%   1.) The susceptibility distribution is spatially padded and the changed
%       parameters written into the ParameterStruct.
%   2.) The padded distribution is Fourier transformed
%   3.) The changed parameters written into the ParameterStruct.
%
%Input:
%       Chi             -- The susceptibility distribution repressenting the object which is imaged.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
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
% 
%                                              MR_invisible (only needed for use in "deltaB_2_FM.m",
%                                                            it might be most convenient to produce
%                                                            this with the susceptibility distribution Chi.)
%Output:
%       VOI_k           -- The spatially padded susceptibility distribution in k-Space.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%       ParameterStruct -- The updated Structure.
%       VOI             -- The spatially padded susceptibility distribution in image Space.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%                          The FINAL ParameterStruct output by "prep_VOI_distribution"
%                          will contain the following ADDITIONAL parameters:
%                              ParameterStruct.(FINAL)
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
%Example Call:
%               [VOI_k, ParameterStruct, VOI] = prep_VOI_distribution(Chi,ParameterStruct);
%
%
%Author: Rainer Boegle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.04.06 
%Comment2010.04.06: out of memory problem, need to be able to override ISOPadFactor, eg=1,1.5,2; varargin used for that.

%% 1.)
% isometric spatial padding Factor
% Check if ISOPadFactor == 3 has to be overwritten: (1st "varargin Variable": check by use of narging and isscalar)
if(nargin == 2) %no Override for ISOPadFactor specified: use empirical "safty-factor" for 3T, i.e. ISOPadFactor = 3;
    ISOPadFactor = 3; %Empirical value working properly for B_0 ~ 3T, change if need be.
else
    if(nargin == 3) %It should only be one ADDITIONAL Variable == Override for ISOPadFactor.
        if(varargin{1} >= 1) %ISOPadFactor should be reasonable (WARNING: this might still produce errors! Display Value here, try to catch error (if present) later.)
            ISOPadFactor = varargin{1};
            disp(['ISOPadFactor was overwritten: NewValue= ', num2str(ISOPadFactor),'.']);
        end
    end
end
    


% spatial padding of susceptibility distribution.
[VOI, ParameterStruct] = pad_Chi_2_VOI(Chi, ParameterStruct, ISOPadFactor); 
disp('Susceptibility distribution padded.')
%% 2.)
% 3D FFT
VOI_k = fft(VOI,   [], 1);
VOI_k = fft(VOI_k, [], 2);
VOI_k = fft(VOI_k, [], 3);
disp('VOI_k ready, updating ParameterStruct');
%% 3.)
% update of parameter map
ParameterStruct.Res_k_x= 1/ParameterStruct.FOV_x_VOI;
ParameterStruct.Res_k_y= 1/ParameterStruct.FOV_y_VOI;
ParameterStruct.Res_k_z= 1/ParameterStruct.FOV_z_VOI;

ParameterStruct.FOV_k_x_VOI= 1/ParameterStruct.Res_x;   
ParameterStruct.FOV_k_y_VOI= 1/ParameterStruct.Res_y;   
ParameterStruct.FOV_k_z_VOI= 1/ParameterStruct.Res_z;   






