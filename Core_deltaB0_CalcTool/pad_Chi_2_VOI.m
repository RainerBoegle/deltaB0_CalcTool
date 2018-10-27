function [VOI, ParameterStruct] = pad_Chi_2_VOI(Chi, ParameterStruct, ISOPadFactor)
% This function pads the volume of the susceptibility distribution Chi
% ISOMETRICALLY by a factor determined by ISOPadFactor.
%
%   1.) ISOPadFactor is checked: needs to be scalar and greater 1.
%   2.) The ParameterStruct is changed.
%   3.) The extra size for padding is determined.
%   4.) The susceptibility distribution is padded by the determined size with the susceptibility value (in ppm) of AIR NOT VACUUM(!).
%
%INPUT:
%       Chi             -- The susceptibility distribution repressenting the object which is imaged.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%       ParameterStruct -- A Structure containing all parameters regarding the susceptibility distribution 
%
%                          The ORIGINAL ParameterStruct input into "pad_Chi_2_VOI.m"
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
%       VOI             -- The spatially padded susceptibility distribution in image Space.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%       ParameterStruct -- The updated Structure.
%
%                          The FINAL ParameterStruct output by "pad_Chi_2_VOI.m"
%                          will contain the following ADDITIONAL parameters:
%                              ParameterStruct.(FINAL)
%                                              Size_x_VOI
%                                              Size_y_VOI
%                                              Size_z_VOI
%                                              FOV_x_VOI
%                                              FOV_y_VOI
%                                              FOV_z_VOI
%
%Example Call:
%               [VOI_k, ParameterStruct, VOI] = pad_Chi_2_VOI(Chi,ParameterStruct,ISOPadFactor);
%               [VOI_k, ParameterStruct, VOI] = pad_Chi_2_VOI(Chi,ParameterStruct,      3     ); %ISOPadFactor = 3 is an empirical value working properly for B_0 ~ 3T, change if need be.
%
%Author: Rainer B�gle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.04.07 
%Comment2010.04.01: isinteger does not work as it should, take that out and hope that the user is not stupid. :(
%Comment2010.04.07: test if function "isscalar" is present, might be a problem for older Matlab Versions.

%% 1.)
%%%%%% ISOPadFactor %%%%%%%%%
if(exist('isscalar')) %patch for oder Matlab Versions
    if(~isscalar(ISOPadFactor)) %not a scalar!!!
        error('pad_Chi_2_VOI:ISOPadFactor', 'ISOPadFactor is NOT a SCALAR!!! What are you thinking?!');
    end
else
    %if(~isinteger(ISOPadFactor) || isa(ISOPadFactor, 'double'))
    %    error('pad_Chi_2_VOI:ISOPadFactor', 'ISOPadFactor is NOT an INTEGER!!! This is seriously uncool! (There might be room for improvement of the code though...)');
    %else
        if(ISOPadFactor < 1) %Make sure ISOPadFactor is not smaller than ONE!
            if(ISOPadFactor <= 0) %Make sure it is not negative
                disp(['ISOPadFactor is negative! --> using abs value: ', num2str(abs(ISOPadFactor)), '.']);
                disp(' ');
                ISOPadFactor = abs(ISOPadFactor); %Make sure it is not negative.
            end
            if(ISOPadFactor > 0 && ISOPadFactor < 1)
                disp('This function can not be used to "shrink" the susceptibility distribution, use "VOI_2_Chi_Size.m" with appropriate ParameterStruct instead.');
                disp(' ');
                return;
            end
        end
        if(ISOPadFactor == 1)
            disp('Warning NO EXTRA PADDING of susceptibility distribution might cause corrupted field calculation, due to foldback artifact.');
            disp(' ');
            pause(0.1); %give user some time to recognize this.
            %x
            ParameterStruct.Size_x_VOI = ParameterStruct.Size_x_Chi * ISOPadFactor;
            disp(['ORG Size_x_Chi= ', num2str(ParameterStruct.Size_x_Chi), '.']);
            disp(['NEW Size_x_VOI= ', num2str(ParameterStruct.Size_x_VOI), '.']);
            
            ParameterStruct.FOV_x_VOI  = ParameterStruct.FOV_x_Chi * ISOPadFactor;
            disp(['ORG FOV_x_Chi= ', num2str(ParameterStruct.FOV_x_Chi), '.']);
            disp(['NEW FOV_x_VOI= ', num2str(ParameterStruct.FOV_x_VOI), '.']);
            disp( 'xxxxxxxxxxxxxxx ISOPadFactor == 1 xxxxxxxxxxxxxxx');

            %y
            ParameterStruct.Size_y_VOI = ParameterStruct.Size_y_Chi * ISOPadFactor;
            disp(['ORG Size_y_Chi= ', num2str(ParameterStruct.Size_y_Chi), '.']);
            disp(['NEW Size_y_VOI= ', num2str(ParameterStruct.Size_y_VOI), '.']);
            
            ParameterStruct.FOV_y_VOI  = ParameterStruct.FOV_y_Chi * ISOPadFactor;
            disp(['ORG FOV_y_Chi= ', num2str(ParameterStruct.FOV_y_Chi), '.']);
            disp(['NEW FOV_y_VOI= ', num2str(ParameterStruct.FOV_y_VOI), '.']);
            disp( 'xxxxxxxxxxxxxxx ISOPadFactor == 1 xxxxxxxxxxxxxxx');

            %z
            ParameterStruct.Size_z_VOI = ParameterStruct.Size_z_Chi * ISOPadFactor;
            disp(['ORG Size_z_Chi= ', num2str(ParameterStruct.Size_z_Chi), '.']);
            disp(['NEW Size_z_VOI= ', num2str(ParameterStruct.Size_z_VOI), '.']);

            ParameterStruct.FOV_z_VOI  = ParameterStruct.FOV_z_Chi * ISOPadFactor;
            disp(['ORG FOV_z_Chi= ', num2str(ParameterStruct.FOV_z_Chi), '.']);
            disp(['NEW FOV_z_VOI= ', num2str(ParameterStruct.FOV_z_VOI), '.']);
            disp( 'xxxxxxxxxxxxxxx ISOPadFactor == 1 xxxxxxxxxxxxxxx');

            disp('   ');
            VOI = Chi;
            return;
        end
    %end
end

disp(['ISOPadFactor is ', num2str(ISOPadFactor), '.']);
disp(' ');

%% 2.)
%x
ParameterStruct.Size_x_VOI = ParameterStruct.Size_x_Chi * ISOPadFactor;
disp(['ORG Size_x_Chi= ', num2str(ParameterStruct.Size_x_Chi), '.']);
disp(['NEW Size_x_VOI= ', num2str(ParameterStruct.Size_x_VOI), '.']);

ParameterStruct.FOV_x_VOI  = ParameterStruct.FOV_x_Chi * ISOPadFactor;
disp(['ORG FOV_x_Chi= ', num2str(ParameterStruct.FOV_x_Chi), '.']);
disp(['NEW FOV_x_VOI= ', num2str(ParameterStruct.FOV_x_VOI), '.']);

%y
ParameterStruct.Size_y_VOI = ParameterStruct.Size_y_Chi * ISOPadFactor;
disp(['ORG Size_y_Chi= ', num2str(ParameterStruct.Size_y_Chi), '.']);
disp(['NEW Size_y_VOI= ', num2str(ParameterStruct.Size_y_VOI), '.']);

ParameterStruct.FOV_y_VOI  = ParameterStruct.FOV_y_Chi * ISOPadFactor;
disp(['ORG FOV_y_Chi= ', num2str(ParameterStruct.FOV_y_Chi), '.']);
disp(['NEW FOV_y_VOI= ', num2str(ParameterStruct.FOV_y_VOI), '.']);

%z
ParameterStruct.Size_z_VOI = ParameterStruct.Size_z_Chi * ISOPadFactor;
disp(['ORG Size_z_Chi= ', num2str(ParameterStruct.Size_z_Chi), '.']);
disp(['NEW Size_z_VOI= ', num2str(ParameterStruct.Size_z_VOI), '.']);

ParameterStruct.FOV_z_VOI  = ParameterStruct.FOV_z_Chi * ISOPadFactor;
disp(['ORG FOV_z_Chi= ', num2str(ParameterStruct.FOV_z_Chi), '.']);
disp(['NEW FOV_z_VOI= ', num2str(ParameterStruct.FOV_z_VOI), '.']);

disp('   ');

%% 3.)
%Extra Size in EACH DIRECTION --> Factor 1/2 !!!        
SizeXtra_x= (ParameterStruct.Size_x_VOI - ParameterStruct.Size_x_Chi)/2; %for 128 to 256 we have to add 64 in each Direction == 128.
disp(['Extra Size in X DIRECTION is ', num2str(SizeXtra_x), ' Voxels.']);

SizeXtra_y= (ParameterStruct.Size_y_VOI - ParameterStruct.Size_y_Chi)/2; %for 128 to 256 we have to add 64 in each Direction == 128.
disp(['Extra Size in Y DIRECTION is ', num2str(SizeXtra_x), ' Voxels.']);

SizeXtra_z= (ParameterStruct.Size_z_VOI - ParameterStruct.Size_z_Chi)/2; %for 128 to 256 we have to add 64 in each Direction == 128.
disp(['Extra Size in Z DIRECTION is ', num2str(SizeXtra_z), ' Voxels.']);

%% 4.)
%spatial padding of Chi to VOI:
%Constant for padding, here AIR NOT VACUUM!
chi_Air= 0.36e-6;

VOI = padarray(Chi, [SizeXtra_y SizeXtra_x SizeXtra_z], chi_Air);