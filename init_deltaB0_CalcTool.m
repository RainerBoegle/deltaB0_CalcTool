function [] = init_deltaB0_CalcTool()
% initialize the tool by setting the path
basePath = fileparts(mfilename('fullpath'));
disp('init deltaB0_CalcTool...');
disp(['    basePath:',basePath]);
addpath(basePath);

disp(['    basePath',filesep,'Core_deltaB0_CalcTool:']);
addpath([basePath,filesep,'Core_deltaB0_CalcTool']);

disp(['    basePath',filesep,'Susceptibility_distributions:']);
addpath([basePath,filesep,'Susceptibility_distributions']);
disp(['    basePath',filesep,'Susceptibility_distributions',filesep,'INF_Cyl_xAxis:']);
addpath([basePath,filesep,'Susceptibility_distributions',filesep,'INF_Cyl_xAxis']);
disp(['    basePath',filesep,'Susceptibility_distributions',filesep,'Phantom_Rainer:']);
addpath([basePath,filesep,'Susceptibility_distributions',filesep,'Phantom_Rainer']);
disp(['    basePath',filesep,'Susceptibility_distributions',filesep,'Sphere:']);
addpath([basePath,filesep,'Susceptibility_distributions',filesep,'Sphere']);
disp(['    basePath',filesep,'Susceptibility_distributions',filesep,'Sphere',filesep,'Analytical_Solution:']);
addpath([basePath,filesep,'Susceptibility_distributions',filesep,'Sphere',filesep,'Analytical_Solution']);

disp(['    basePath',filesep,'Tutorial_deltaB0_CalcTool:']);
addpath([basePath,filesep,'Tutorial_deltaB0_CalcTool']);

%% basic check
if(~exist('Calc_deltaB.m','file')||~exist('prep_ParameterStruct.m','file'))
    error('Could not find "Calc_deltaB.m", path must be wrong, please check path.');
else
    disp('Found "Calc_deltaB.m" and "prep_ParameterStruct.m", will assume that all tools are available.');
end

end