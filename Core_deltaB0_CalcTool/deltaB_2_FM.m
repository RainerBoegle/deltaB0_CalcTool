function FieldMap = deltaB_2_FM(ChiSize_deltaB,ParameterStruct,Chi) %WIP: ShimValues & BackgroundField should be included! 
% This function masks the field at all points which would not be visible for MR to approximate the distribution of a field map.
% WIP Notes:
%     Additionally to the IDEALIZED CALCULATION of the field done by the
%     function "Calc_deltaB", which ASSUMES A PERFECTLY HOMOGENEOUS B0 FIELD
%     we HAVE TO INCLUDE THE INHOMOGENEITIES OF THE SCANNER AND THE SHIM FIELDS!
%     
%     For this reason we also need the position and orientation of the Object.
%     Then we just have to take the measured background field and transform
%     it according to the position and orientation of the object and add it
%     to the results of "Calc_deltaB".
% WIP_END
%
% Structure of the function until now:
%   1.) Copy Tensor ChiSize_deltaB to FieldMap Tensor. 
%       WIP: Add transformed background fields and shim fields
%   2.) Go through the MR_invisible Table in the ParameterStruct and
%   3.) Use comparison with Values of Chi to select Voxels to set to zero in FieldMap Tensor.
%
%INPUT:
%       ChiSize_deltaB  -- The field inhomogeneity in the position and extend of the susceptibility distribution Chi repressenting the object which is imaged.
%                             (The Format is always (y,x,z). Maybe this needs to be rethought in the future.)
%       ParameterStruct -- A Structure containing all parameters regarding the susceptibility distribution 
%
%                          The ORIGINAL ParameterStruct input into "Calc_deltaB.m"
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
%                                              MR_invisible (IS THE REALLY IMPROTANT INFORMATION HERE!!!)
%OUTPUT:
%       FieldMap       -- The field inhomogeneity where all those Voxels are set to zero which are in positions,
%                         where Chi has a suscept value which is equal to a substance which is MR invisible.
%                            (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%Example Call:
%               FieldMap = deltaB_2_FM(ChiSize_deltaB,ParameterStruct,Chi)
%
%Author: Rainer B�gle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.04.06 (Minor Debugging)

%% 1.)
FieldMap = ChiSize_deltaB;

%WIP:
% Lets say we input the field measured in a sphere as a measure of the BACKGROUND FIELD 
% then we have to apply the inverse rotation of the B0 field to obtain the right field
% which we have to add to the calculated field for correction. 
% (Because the object really moved while the BACKGROUND field and B0 stays fixed,
%  -it is only due to motion correction that the BACKGROUND & B0 field apparently moved!)
% The code should look something like this:
%
%       BackgroundField_alpha_degrees= - B_0_Orientation * 2*pi /360; %Angle in degrees for rotation; OPPOSITE to the B0 orientation.
%       SphereFieldMap_rotated = imrotate(SphereFieldMap,BackgroundField_alpha_degrees,'bilinear','crop');
%       FieldMap= ChiSize_deltaB + SphereFieldMap_rotated; %This is the corrected field, including the Background field.
% Remark:
%        Dynamic Shimming can be included in the same way if the Shim values used for dyn. correction have been stored and the appropriate field can be calculated.
%
%WIP_END

%% 2.) & 3.)
for ind_MR_invisible= 1:size(ParameterStruct.MR_invisible, 2)
    FieldMap((Chi == ParameterStruct.MR_invisible(ind_MR_invisible))) = 0;   %removing everything that is MR invisible.
end
