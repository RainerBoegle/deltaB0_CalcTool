function ParameterStruct = prep_ParameterStruct(Chi, Resolution_mm)
% This function prepares the original parameter structure using the 3D Array which repressents the susceptibility distribution 'Chi' 
% and a 1x3 Vector 'Resolution_mm' giving the resolution (dimentions of the voxels) in mm.
% WIP Notes:
%           MR_invisible should be set variably here.
%           Right now we only use the susceptibility Values of Air and Bone
%           as a default for non MR visible substances.
% WIP_END
%
%Input:
%       Chi             -- The susceptibility distribution repressenting the object which is imaged.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%Output:
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
%                                                            this with the
%
%                                                            susceptibility distribution Chi.)
%   Example Call:
%                   ParameterStruct = prep_ParameterStruct(Chi, Resolution_mm);
%                   ParameterStruct = prep_ParameterStruct(Chi, [1 1 1]);  %Chi was determined from T1 with 1x1x1 mm resolution
%
%Author: Rainer B�gle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.04.01

ParameterStruct.Res_x = Resolution_mm(2)./1000;
ParameterStruct.Res_y = Resolution_mm(2)./1000;
ParameterStruct.Res_z = Resolution_mm(2)./1000;

ParameterStruct.Size_x_Chi = size(Chi, 2);
ParameterStruct.Size_y_Chi = size(Chi, 1);
ParameterStruct.Size_z_Chi = size(Chi, 3);

ParameterStruct.FOV_x_Chi = ParameterStruct.Size_x_Chi .* ParameterStruct.Res_x;
ParameterStruct.FOV_y_Chi = ParameterStruct.Size_y_Chi .* ParameterStruct.Res_y;
ParameterStruct.FOV_z_Chi = ParameterStruct.Size_z_Chi .* ParameterStruct.Res_z;

%WIP: MR_invisible
Air= 0.36e-6;
Bone= -11.4e-6;

ParameterStruct.MR_invisible(1) = Air;
ParameterStruct.MR_invisible(2) = Bone;

