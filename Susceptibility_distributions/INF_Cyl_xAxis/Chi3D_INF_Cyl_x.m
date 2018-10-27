function [chi ParameterStruct x y z]= Chi3D_INF_Cyl_x(SizeX, SizeY, SizeZ, FOVx, FOVy, FOVz)
%This Function creates a infinetely long Cylinder along the x-Axis in the
%specified FOV & Matrix Size 


%BEMERKUNG: So funktionert das überhaupt nicht!
%           Es sollte reichen abzuprüfen ob x^2 + y^2 <= r^2 ist und in z
%           Richtung fortzuschreiten!!!


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

%Koordinaten erstellen...
[x, y, z]= meshgrid(-FOVy/2: FOVy/SizeY :FOVy/2 - FOVy/SizeY, -FOVx/2:FOVx/SizeX:FOVx/2 - FOVx/SizeX, -FOVz/2:FOVz/SizeZ:FOVz/2 - FOVz/SizeZ );

% disp(['Meshgrid mit Länge ', num2str(2*Laenge),' und Schrittweite ', num2str(Schrittweite), ' angelegt. D.h. ', num2str(Pixel), ' Pixel.']);


%Konstanten
Gehirn= -9.2e-6; %-(9.2/0.3); %original -9.2e-6;
Knochen= -11.4e-6; %-(11.4/0.3); %original -11.4e-6;
Luft= 0.36e-6; %1; %original 0.36e-6;

%% Bereiche:

ZylinderInhalt= Gehirn;
% Hulle= Knochen;
Hulle= Gehirn;
AussererBereich= Luft;

%% Chi erstellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Suszeptibilitätsverteilung erstellen: Vorgehen %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


%Radius des Zylinders
r= .03; %m also 3cm
%Dicke der Hülle
Dicke= FOVz/SizeZ;

%Mittelpkt der Basis des Zylinders
Zy_y0= 0;
Zy_z0= 0;

%Länge des Zylinders
% L_Zy= 0.12; %m also 12cm
L_Zy= FOVz; %Full FOV --> inf. Cylinder!!!
%Startpkt bzgl der z Koordinate
Stpkt= -FOVz/2; %Full FOV --> inf. Cylinder!!! %-0.07; %m sollte also -7cm bzgl z-Achse sein.

disp('Jetzt wird Chi klein mit Werten vollgepackt...');
%pause

%% 1.) Zylinder mit Hülle erstellen; Rest des Raumes= 0!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Zylinder in X Richtung %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i= 1:size(x,2)
    for j= 1:size(y,1)
        for k= 1:size(z,3)
            if ( (( ((y(j, i, k) - Zy_y0)^2 + (z(j, i, k) - Zy_z0)^2) <= r^2 )) && ((x(j, i, k) >= Stpkt) && (x(j, i, k) <= (Stpkt + L_Zy) )) )
                chi_Zy(j, i, k)= ZylinderInhalt; %chi_Zy(i, j, k)= ZylinderInhalt;
            else
                chi_Zy(j, i, k)= 0; %chi_Zy(i, j, k)= 0; %Luft/3;
            end
        end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Hülle um Zylinder ohne Deckel & Boden %%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i= 1:size(x,2)
%     for j= 1:size(y,1)
%         for k= 1:size(z,3)
%                         
%             %Knochen um den Zylinder
%             if ( ( ( ((x(i, j, k) - Zy_x0)^2 + (y(i,j,k) - Zy_y0)^2) > r^2 ) && ( ((x(i, j, k) - Zy_x0)^2 + (y(i,j,k) - Zy_y0)^2) <= (r+Dicke)^2 ) ) && ((z(i, j, k) > Stpkt-Dicke) && (z(i, j, k) <= (Stpkt + L_Zy)+Dicke)) )
%                 chi_HZy(i, j, k)= Hulle;
%             else
%                 chi_HZy(i, j, k)= 0; %Luft/3;
%             end
%         end
%     end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Deckel & Boden um Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i= 1:size(x,2)
%     for j= 1:size(y,1)
%         for k= 1:size(z,3)
%                         
%             %Knochen um den Zylinder
%             if ( (( ((x(i, j, k) - Zy_x0)^2 + (y(i,j,k) - Zy_y0)^2) <= r^2 )) && ( ( (z(i, j, k) >= Stpkt-Dicke) && (z(i, j, k) <= Stpkt) ) || ( (z(i, j, k) > (Stpkt + L_Zy)) && (z(i, j, k) <= (Stpkt + L_Zy)+Dicke) ) ) )
%                 chi_DBoZy(i, j, k)= Hulle;
%             else
%                 chi_DBoZy(i, j, k)= 0; %Luft/3;
%             end
%         end
%     end
% end


%chi= chi_HZy + chi_DBoZy + chi_Zy;

%% 2.)Chi_1st erstellen und zum Test ploten, -kann später entfernt werden.
disp('Chi_1st wird erstellt');
chi_1st= chi_Zy; %chi_HZy + chi_DBoZy + chi_Zy;

% disp('chi_1st als Graph ausgegeben');
% % %pause
% xslice = [Zy_x0_gr, 0, Zy_x0_kl]; %Ebene durch die Mittelpkte der Zylinder
% yslice = 0;
% zslice = 0; %m also beim Ursprung
% figure;
% subplot(1, 2, 1)
% slice(x, y, z, chi_1st, xslice, yslice, zslice),title(['Suszep.verteilung chi_1st (zSlice = ', num2str(zslice),')'])
% zslice = -0.04; %m also -4cm
% subplot(1, 2, 2)
% slice(x, y, z, chi_1st, xslice, yslice, zslice),title(['Suszep.verteilung chi_1st (zSlice = ', num2str(zslice),')'])


%% 3.)MASKE erstellen und zum Test ploten, -kann später entfernt werden.

disp('MASKE wird erstellt');
% for i= 1:size(x,2)
%     for j= 1:size(y,1)
%         for k= 1:size(z,3)
%             if ( chi_1st(i,j,k) ~= 0 )
%                 MASKE(i,j,k)= 0;
%             else
%                 MASKE(i,j,k)= 1;
%             end
%         end
%     end
% end
MASKE= zeros(size(chi_1st));
MASKE(chi_1st == 0)= 1;


% disp('MASKE als Graph ausgegeben');
% % pause
% xslice = [Zy_x0_gr, Zy_x0_kl];
% yslice = [Zy_y0_gr, Zy_y0_kl];
% zslice = 0;
% figure;
% subplot(1, 2, 1)
% slice(x, y, z, MASKE, xslice, yslice, zslice),title(['MASKE aus Suszep.verteilung (zSlice = ', num2str(zslice),')'])
% zslice = -0.04; %m also bei -4cm
% subplot(1, 2, 2)
% slice(x, y, z, MASKE, xslice, yslice, zslice),title(['MASKE aus Suszep.verteilung (zSlice = ', num2str(zslice),')'])

%% 4.)Gesamtsuszep.verteilung erstellen: chi= chi_1st + (MASKE.*Luft)

disp('Gesamtsuszep.verteilung wird erstellt...');
chi= chi_1st + (MASKE .* AussererBereich);


%% chi speichern
%%%%%%% Alles was man später zum arbeiten braucht wird übergeben:
%%%%%%% Chi, Koordinaten, FOV, Pixel in FOV= Size

disp('Chi incl. Koordinaten, FOV & Anz.Pixel wird in bin File "Suszep files\Sus3D_128_Zylinder_Ursprung_mk2.mat" gespeicher:');
% save('Suszeptibilitäten\Suszep files\Sus3D_128_Zylinder_Ursprung_mk2.mat', 'chi', 'x', 'y', 'z', 'FOVx', 'SizeX', 'FOVy', 'SizeY', 'FOVz', 'SizeZ')

ParameterStruct.Aussen= Luft;     %Suszeptibilität des Außenbereichs
ParameterStruct.Deckel= Luft;  %Suszeptibilität des Deckels
ParameterStruct.Tisch= Luft;    %Suszeptibilität des Tisch
ParameterStruct.Wand= Luft;      %Suszeptibilität der Wände
ParameterStruct.FOV_x= FOVx;
ParameterStruct.FOV_y= FOVy;
ParameterStruct.FOV_z= FOVz;
ParameterStruct.Size_x= SizeX;
ParameterStruct.Size_y= SizeY;
ParameterStruct.Size_z= SizeZ;
ParameterStruct.Res_x= FOVx/SizeX;
ParameterStruct.Res_y= FOVy/SizeY;
ParameterStruct.Res_z= FOVz/SizeZ;

%%%%%%% Alles was man später zum arbeiten braucht wird übergeben:
%%%%%%% Chi, Koordinaten, FOV, Pixel in FOV= Size
%% Suszeptibilitätsverteilung ploten
disp('...und als Graph ausgegeben');
% %pause
xslice = 0;
yslice = Zy_y0;
zslice = Zy_z0; %m also bei -4cm und beim Ursprung
% figure;
% slice(x, y, z, chi, xslice, yslice, zslice),title('Suszep.verteilung Zylinder mit Hülle um Ursprung')



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