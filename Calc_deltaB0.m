function VOISize_deltaB = Calc_deltaB0(Chi,ParameterStruct,B_0,B_0_Orientation)
% !!!DON'T USE THIS FUNCTION IF YOU WANT TO CALCULATE FIELD MAPS FOR LOTS OF B_0_ORIENTATIONS!!!
%                                 !!! IT WILL BE SLOW !!!
%                                 !!!    BELIEVE ME   !!!
%                                 !!! IT WILL BE SLOW !!!
% 
% To be faster see Tutorial:
%                           "Fast_Field_Calculation_for_many_B0_Orientations"
%              --> ./Tutorial_deltaB0_CalcTool/Fast_Field_Calculation_for_many_B0_Orientations.m
%
% For more information see help of CORE functions:
%                                                 "prep_VOI_distribution" --> ./Core_deltaB0_CalcTool/prep_VOI_distribution.m 
%                                                 "Calc_deltaB"           --> ./Core_deltaB0_CalcTool/Calc_deltaB.m
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
%                                                            this with the
%                                                            susceptibility distribution Chi.)
%       B_0             -- The nominal B0 field strength of the Scanner in TESLA (e.g. 2.8936 for INUMAC Trio)
%       B_0_Orientation -- Orientation of the field to the Object as determined from the data from the motion tracking system/sequence and the starting position of the object repressented through the susceptibilty distribution
%                          (right now only coronal rotations are considered.)
%OUTPUT:
%       VOISize_deltaB           -- The field inhomogeneity from the padded susceptibility distribution, which is thus in "VOISize"==Size VOI has as a result of spatial padding of Chi.
%                                      (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%Example Call:
%               VOISize_deltaB = Calc_deltaB0(Chi,ParameterStruct,B_0,   B_0_Orientation);
%               VOISize_deltaB = Calc_deltaB0(Chi,ParameterStruct,2.8936,B_0_Orientation)
%               (The SPATIAL Format of all arrays is always (y,x,z). Maybe this needs to be rethought in the future.)
%
%               FOR MORE INFORMATION SEE HELP OF FUNCTIONS:
%                                                          "prep_VOI_distribution"
%                                                          "Calc_deltaB"
%Author: Rainer B�gle (Rainer.Boegle@googlemail.com)
%Last Change: 2010.02.13

[VOI_k,ParameterStruct] = prep_VOI_distribution(Chi,ParameterStruct);

VOISize_deltaB = Calc_deltaB(VOI_k,ParameterStruct,B_0,B_0_Orientation);

