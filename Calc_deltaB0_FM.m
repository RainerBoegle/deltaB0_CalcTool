function FieldMap = Calc_deltaB0_FM(Chi,ParameterStruct,B_0,B_0_Orientation)
% !!!DON'T USE THIS FUNCTION IF YOU WANT TO CALCULATE FIELD MAPS FOR LOTS OF B_0_ORIENTATIONS!!!
%                                 !!! IT WILL BE SLOW !!!
%                                 !!!    BELIEVE ME   !!!
%                                 !!! IT WILL BE SLOW !!!
% 
% To be faster see Tutorial: "Fast_Field_Calculation_for_many_B0_Orientations.m"
% for more information see help of CORE functions:
%                                                 "prep_VOI_distribution" --> ./Core_deltaB0_CalcTool/prep_VOI_distribution.m 
%                                                 "Calc_deltaB"           --> ./Core_deltaB0_CalcTool/Calc_deltaB.m
%                                                 "deltaB_2_FM"           --> ./Core_deltaB0_CalcTool/deltaB_2_FM.m
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
%                                                            this with the
%                                                            susceptibility distribution Chi.)
%       B_0             -- The nominal B0 field strength of the Scanner in TESLA (e.g. 2.8936 for INUMAC Trio)
%       B_0_Orientation -- Orientation of the field to the Object as determined from the data from the motion tracking system/sequence and the starting position of the object repressented through the susceptibilty distribution
%                          (right now only coronal rotations are considered.)
%OUTPUT:
%       FieldMap       -- The field inhomogeneity where all those Voxels are set to zero which are in positions,
%                         where Chi has a suscept value which is equal to a substance which is MR invisible.
%                            (The SPATIAL Format of all arrays is always
%                            (y,x,z). Maybe this needs to be rethought in the future.)
%
%Example Call:
%               VOISize_deltaB = Calc_deltaB0(Chi,ParameterStruct,B_0,   B_0_Orientation);
%               VOISize_deltaB = Calc_deltaB0(Chi,ParameterStruct,2.8936,B_0_Orientation)
%               (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%Author: Rainer B�gle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.02.13

VOISize_deltaB = Calc_deltaB0(Chi,ParameterStruct,B_0,B_0_Orientation);

ChiSize_deltaB = VOI_2_Chi_Size(VOISize_deltaB, ParameterStruct);

FieldMap = deltaB_2_FM(ChiSize_deltaB,ParameterStruct,Chi);