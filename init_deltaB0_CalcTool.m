function [] = init_deltaB0_CalcTool()
% initialize the tool by setting the path
basePath = fileparts(mfilename('fullpath'));
addpath(basePath);
addpath([basePath,filesep,'Core_deltaB0_CalcTool']);
end