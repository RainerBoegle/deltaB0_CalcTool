function ChiSize_deltaB = VOI_2_Chi_Size(VOISize_deltaB, ParameterStruct)
% This function changes the size of the Tensor back to the original size of the susceptibility distribution repressenting the images objetct.
% Or put another way: going form "VOISize" to "ChiSize", by "cutting out" the inner part of the VOI volume.
% 
%   1.) The ExtraSize added by the "pad_Chi_2_VOI" function is determined.
%   2.) The Start Value for the CutOut is this Value from 1.) plus 1.
%   3.) From there on we only need to go "Size_xyz_Chi - 1" further
%       to get to the end of the CutOut Volume and we are done.
%
%INPUT:
%       VOISize_deltaB  -- The field inhomogeneity calculated for the spatially padded (VOISize) susceptibility distribution Chi repressenting the object which is imaged.
%                             (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
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
%                                              MR_invisible (only needed for use in "deltaB_2_FM.m",
%                                                            it might be most convenient to produce
%                                                            this with the susceptibility distribution Chi.)
%OUTPUT:
%       ChiSize_deltaB           -- The field inhomogeneity cut out of from VOISize_deltaB to be equivalent to the field inside the susceptibility distribution Chi, which is thus in "ChiSize"==spatial position&extend Chi had at the very beginning.
%                                      (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%Example Call:
%               ChiSize_deltaB = VOI_2_Chi_Size(VOISize_deltaB, ParameterStruct)
%
%Author: Rainer Bögle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.02.13

%% 1.)
SizeXtra_x= (ParameterStruct.Size_x_VOI - ParameterStruct.Size_x_Chi)/2;

SizeXtra_y= (ParameterStruct.Size_y_VOI - ParameterStruct.Size_y_Chi)/2;

SizeXtra_z= (ParameterStruct.Size_z_VOI - ParameterStruct.Size_z_Chi)/2;

%% 2.)
CutOutStart_x= SizeXtra_x+1;
CutOutStart_y= SizeXtra_y+1;
CutOutStart_z= SizeXtra_z+1;

CutOutEnd_x  = SizeXtra_x + ParameterStruct.Size_x_Chi;
CutOutEnd_y  = SizeXtra_y + ParameterStruct.Size_y_Chi;
CutOutEnd_z  = SizeXtra_z + ParameterStruct.Size_z_Chi;

%% 3.)
ChiSize_deltaB= VOISize_deltaB(CutOutStart_y:CutOutEnd_y,CutOutStart_x:CutOutEnd_x,CutOutStart_z:CutOutEnd_z);