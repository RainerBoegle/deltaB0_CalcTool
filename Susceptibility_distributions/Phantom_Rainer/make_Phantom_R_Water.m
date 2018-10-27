function [chi ParameterStruct x_pos y_pos z_pos reply_Table]= make_Phantom_R_Water(varargin)
% This function assembles the susceptibility distribution of the Phantom with the inner parts being filled with water
% and addes the Table & Air to it, just as in a normal Scan.
% Remark:
%           Rotation of the Phantom is also possible.
% Example:
%           [chi ParameterStruct x_pos y_pos z_pos]= FullPhantom(Angle);
%           [chi ParameterStruct x_pos y_pos z_pos]= FullPhantom(0);

%% Werte fuer Bereiche eingeben:
% disp('Please enter the individual Susceptibility Values [im ppm].');
% F_Zyl_gr = input('The GREAT Cylinder(inside main Cylinder): [Def:-6*]');
% if isempty(F_Zyl_gr)
%     F_Zyl_gr= -9.05;
% end
F_Zyl_gr= -9.05;
F_Zyl_gr= F_Zyl_gr*10^-6;  %Ho new, 
disp(['**** F_Zyl_gr = ', num2str(F_Zyl_gr*10^6),'ppm ****']);

% F_Zyl_kl = input('The SMALL Cylinder(inside main Cylinder): [Def:-6*]');
% if isempty(F_Zyl_kl)
%     F_Zyl_kl= -9.05;
% end
F_Zyl_kl= -9.05;
F_Zyl_kl= F_Zyl_kl*10^-6; %Ho new,
disp(['**** F_Zyl_kl = ', num2str(F_Zyl_kl*10^6),'ppm ****']);

% F_DrPr = input('The TRIANGLE Prism(inside main Cylinder): [Def:-8*]');
% if isempty(F_DrPr)
%     F_DrPr= -9.05;
% end
F_DrPr= -9.05;
F_DrPr= F_DrPr*10^-6; %Ho new2
disp(['**** F_DrPr = ', num2str(F_DrPr*10^6),'ppm ****']);

% F_Qu = input('The QUBOID(inside main Cylinder): [Def:-7*]');
% if isempty(F_Qu)
%     F_Qu= -9.05;
% end
F_Qu= -9.05;
F_Qu= F_Qu*10^-6; %Ho new2,
disp(['**** F_Qu = ', num2str(F_Qu*10^6),'ppm ****']);

% F_klZylA = input('The SMALL CUTOUT COMPARTMENTS(of main Cylinder): [Def:+0.36=AIR]');
% if isempty(F_klZylA)
%     F_klZylA= +0.36;
%     disp('**** F_klZylA = AIR ****');
% end
F_klZylA= +0.36;
F_klZylA= F_klZylA*10^-6; %AIR,
disp(['**** F_klZylA = ', num2str(F_klZylA*10^6),'ppm ****']);

% F_grBHZyl = input('The GREAT CUTOUT COMPARTMENT(of main Cylinder): [Def:+0.36=AIR]');
% if isempty(F_grBHZyl)
%     F_grBHZyl= +0.36;
%     disp('**** F_grBHZyl = AIR ****');
% end
F_grBHZyl= +0.36;
F_grBHZyl= F_grBHZyl*10^-6; %AIR,
disp(['**** F_grBHZyl = ', num2str(F_grBHZyl*10^6),'ppm ****']);

% Hauptbereich = input('The MAIN COMPARTMENT(inside main Cylinder): [Def:-9.05=WATER]');
% if isempty(Hauptbereich)
%     Hauptbereich= -9.05;
%     disp('**** Hauptbereich = (destil.)WATER ****');
% end
Hauptbereich= -9.05;
Hauptbereich= Hauptbereich*10^-6; %Water
disp(['**** Hauptbereich = ', num2str(Hauptbereich*10^6),'ppm ****']);


%%

if(nargin==0)
    Angle= 0;
    disp('!');
end

%%
% disp(' ');
% disp(['### Nullpkt_x= ', num2str(x0),'m ###']);
% disp(['### Nullpkt_y= ', num2str(y0),'m ###']);
% disp(['### Nullpkt_z= ', num2str(z0),'m ###']);
%deactivated, not necessary.
x0= 0;
y0= 0;
z0= 0;

FOV_x = 0.256; 
FOV_y = 0.256; 
FOV_z = 0.256; 
    
Size_x = 256; %SizeFactor * 128; %384; %256; % 
Size_y = 256; %SizeFactor * 128; %384; %256; %
Size_z = 256; %SizeFactor * 128; %384; %256; %

% Res = 1x1x1mm Matrix 256x256x256 gives good results, see R.Boegle 2009 Diploma Thesis 2008/2009

[chi ParameterStruct x_pos y_pos z_pos]= makePhRainer_chi_movable(FOV_x,FOV_y,FOV_z,Size_x,Size_y,Size_z, F_Zyl_gr, F_Zyl_kl, F_DrPr, F_Qu, F_klZylA, F_grBHZyl, Hauptbereich, x0, y0, z0);

if (Angle ~= 0)
    disp(['++++++++++++++++++++++    Rotating Phantom "RAINER" ', num2str(Angle),'Deg around x-Axis   ++++++++++++++++++++++']);
    chi= Rotate_x(chi, Angle, 'nearest', 'crop'); %'nearest','bilinear','bicubic',
else
    disp(['++++++++++++++++++++++    No rotation needed!   ++++++++++++++++++++++']);
end


reply_Table= input('Do you want to include the Table in the calculations? Y/N [Y]: ', 's');
if(isempty(reply_Table))
    reply_Table= 'Y';
end

if(strcmp(reply_Table, 'Y') || strcmp(reply_Table, 'y'))
    Table= 1; %true
else
    if(strcmp(reply_Table, 'N') || strcmp(reply_Table, 'n'))
        Table= 0; %false
        disp('Okay, then we do it without the Table.');
    end
end

Air= 1;   %true
chi= AddTable_n_Air(chi, ParameterStruct, Table, Air, x_pos, y_pos, z_pos);

end