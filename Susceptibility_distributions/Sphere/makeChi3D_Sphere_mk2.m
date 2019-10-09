function [chi ParameterStruct x_pos y_pos z_pos]= makeChi3D_Sphere_mk2(SizeX, SizeY, SizeZ, FOVx, FOVy, FOVz, r, chi_int, chi_ext, Kugel_x0, Kugel_y0, Kugel_z0)
%This Function creates a infinetely long Cylinder along the x-Axis in the
%specified FOV & Matrix Size 
% Example:  128x128x128 256mmx256mmx256mm ==> 2mmRes (0.256mx0.256mx0.256m)
%           Sphere of 0.01m = 10mm Radius at (0,0,0)
%           chi_int= water= 9.05ppm= 9.05e-6
%           chi_extern= air= 0.36ppm= 3.6e-7
%           
% [chi ParameterStruct x_pos y_pos z_pos]= makeChi3D_Sphere_mk2(SizeX, SizeY, SizeZ,  FOVx,  FOVy,  FOVz,    r, chi_int, chi_ext, Kugel_x0, Kugel_y0, Kugel_z0);
% [chi ParameterStruct x_pos y_pos z_pos]= makeChi3D_Sphere_mk2(  128,   128,   128, 0.256, 0.256, 0.256, 0.01, 9.05e-6,  3.6e-7,        0,        0,        0);

% clear
%% Koordinaten erstellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Pixel, FOV in x,y & z Richtung, wie in realistischer Messung. %%%%%%%%%%%%%
%%%%%%%%% Damit Koordinaten erstellen und die Suszeptibilitätsverteilung. %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% F_xy= 16; 
% F_z= 16;

%Anzahl der Pixel:
% SizeX = F_xy * 8; %256; %64; %128;
% SizeY = F_xy * 8; %256; %64; %128;
% SizeZ = F_z * 8; %128; %512; %128;
%FOV in x,y & z-Richtung
% FOVx = 0.3; %0.25;%m
% FOVy = 0.3; %0.25;%m
% FOVz = 0.3; %0.25;%m

Resolution_mm = [FOVy/SizeY; FOVx/SizeX; FOVz/SizeZ].*1000;
%Koordinaten erstellen...
[x, y, z]= meshgrid(-FOVy/2: FOVy/SizeY :FOVy/2 - FOVy/SizeY, -FOVx/2:FOVx/SizeX:FOVx/2 - FOVx/SizeX, -FOVz/2:FOVz/SizeZ:FOVz/2 - FOVz/SizeZ );

% disp(['Meshgrid mit Länge ', num2str(2*Laenge),' und Schrittweite ', num2str(Schrittweite), ' angelegt. D.h. ', num2str(Pixel), ' Pixel.']);


% %Konstanten
% Gehirn= -9.2e-6; %-(9.2/0.3); %original -9.2e-6;
% Knochen= -11.4e-6; %-(11.4/0.3); %original -11.4e-6;
% Luft= 0.36e-6; %1; %original 0.36e-6;


%% Chi erstellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Suszeptibilitätsverteilung erstellen: Vorgehen %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


%Radius des Zylinders <-- NOW DEPENDING ON INPUT.
% r= .03; %m also 3cm
%Dicke der Hülle

%Mittelpkt der Basis des Zylinders
% Kugel_x0= 0;
% Kugel_y0= 0;
% Kugel_z0= 0;

disp('---------------------------------------------------------------------');
disp('Making Sphere...');
tic
disp(' ');
%pause

%% 1.) Kugel erstellen; Rest des Raumes= 0!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Zylinder in X Richtung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chi= zeros(SizeY, SizeX, SizeZ);
disp('.');
chi( ((x-Kugel_x0).^2 + (y-Kugel_y0).^2 + (z-Kugel_z0).^2) <= r^2 ) = chi_int;
disp('..');

%% 2.) Luft um Kugel hinzufügen: Pixel == 0 --> Pixel=Luft;

chi( chi == 0 ) = chi_ext;
disp('...');
t=toc;
disp(['DONE! (Time needed: ' ,num2str(t), 's.)']);
disp('---------------------------------------------------------------------');
%% 3.) ParameterStruct erstellen.
% ParameterStruct.FOV_x= FOVx;
% ParameterStruct.FOV_y= FOVy;
% ParameterStruct.FOV_z= FOVz;
% 
% ParameterStruct.Size_x= SizeX;
% ParameterStruct.Size_y= SizeY;
% ParameterStruct.Size_z= SizeZ;
% 
% ParameterStruct.Res_x= FOVx/SizeX;
% ParameterStruct.Res_y= FOVy/SizeY;
% ParameterStruct.Res_z= FOVz/SizeZ;
%
% ParameterStruct.MR_invisible(1)= chi_ext;     %Suszeptibilität des Außenbereichs
ParameterStruct = prep_ParameterStruct(chi, Resolution_mm);

%% THIS IS A KLUDGE: PLEASE FIX IT!
clear x y z

if mod(ParameterStruct.Size_x_Chi, 2) == 0
    [x_pos] = [(-ParameterStruct.FOV_x_Chi/2):(ParameterStruct.Res_x):(ParameterStruct.FOV_x_Chi/2-ParameterStruct.Res_x)];
else
    [x_pos] = [(-(ParameterStruct.FOV_x_Chi - ParameterStruct.Res_x)/2):(ParameterStruct.Res_x):((ParameterStruct.FOV_x_Chi - ParameterStruct.Res_x)/2)];
end

if mod(ParameterStruct.Size_y_Chi, 2) == 0
    [y_pos] = [(-ParameterStruct.FOV_y_Chi/2):(ParameterStruct.Res_y):(ParameterStruct.FOV_y_Chi/2-ParameterStruct.Res_y)];
else
    [y_pos] = [(-(ParameterStruct.FOV_y_Chi - ParameterStruct.Res_y)/2):(ParameterStruct.Res_y):((ParameterStruct.FOV_y_Chi - ParameterStruct.Res_y)/2)];
end

if mod(ParameterStruct.Size_z_Chi, 2) == 0
    [z_pos] = [(-ParameterStruct.FOV_z_Chi/2):(ParameterStruct.Res_z):(ParameterStruct.FOV_z_Chi/2-ParameterStruct.Res_z)];
else
    [z_pos] = [(-(ParameterStruct.FOV_z_Chi - ParameterStruct.Res_z)/2):(ParameterStruct.Res_z):((ParameterStruct.FOV_z_Chi - ParameterStruct.Res_z)/2)];
end


% %% Suszeptibilitätsverteilung ploten
% disp('...und als Graph ausgegeben');
% % %pause
% xslice = 0;
% yslice = 0;
% zslice = 0; %m also bei -4cm und beim Ursprung
% % figure;
% % slice(x, y, z, chi, xslice, yslice, zslice),title('Suszep.verteilung Zylinder mit Hülle um Ursprung')


%% ALT: Speicherort und Datei plut neue Testfkt erstellen falls notwendig!
%% chi speichern
%%%%%%% Alles was man später zum arbeiten braucht wird übergeben:
%%%%%%% Chi, Koordinaten, FOV, Pixel in FOV= Size

% disp('Chi incl. Koordinaten, FOV & Anz.Pixel wird in bin File "Suszep files\Sus3D_128_Kugel_Ursprung_mk2.mat" gespeicher:');
% save('Suszeptibilitäten\Suszep files\Sus3D_128_Kugel_Ursprung_mk2.mat', 'chi', 'x', 'y', 'z', 'FOVx', 'SizeX', 'FOVy', 'SizeY', 'FOVz', 'SizeZ')


%% Test ob alles okay ist:

% CHI_TESTER('Sus3D_128_Zylinder_Ursprung_mk2.mat');


% 
% 
% % %chi speichern
% save('Suszeptibilitäten\Suszep files\Sus3D_128_Zylinder_Ursprung_mk2.mat', 'chi', 'x', 'y', 'z')
% % 
% % 
% % 
% disp('...und als Graph ausgegeben');
% % %pause
% xslice = Zy_x0;
% yslice = Zy_y0;
% zslice = [-0.4, 0];
% figure;
% % subplot(1, 3, 1)
% % slice(x, y, z, chi, xslice, yslice, zslice),title('Suszep.verteilung (zSlice = -0.44)')
% % zslice = 0;
% % subplot(1, 3, 2)
% % slice(x, y, z, chi, xslice, yslice, zslice),title('Suszep.verteilung (zSlice = 0)')
% % zslice = 0.8;
% % subplot(1, 3, 3)
% % slice(x, y, z, chi, xslice, yslice, zslice),title('Suszep.verteilung (zSlice = 0.44)')
% 
% slice(x, y, z, chi, xslice, yslice, zslice),title('Suszep.verteilung Zylinder mit Hülle')
end