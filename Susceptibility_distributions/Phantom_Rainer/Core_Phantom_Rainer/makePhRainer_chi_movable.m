function [chi ParameterStruct x_pos y_pos z_pos]= makePhRainer_chi_movable(FOV_x,FOV_y,FOV_z,Size_x,Size_y,Size_z, F_Zyl_gr, F_Zyl_kl, F_DrPr, F_Qu, F_klZylA, F_grBHZyl, Hauptbereich, x0, y0, z0)
% This Function will create "Phantom Rainer" in the specified VOI and the Matrix
% Use as Minimum
% PadFactor= 2; 
% FOV_x = PadFactor* 0.256; %m that means 256mm
% FOV_y = PadFactor* 0.256; 
% FOV_z = PadFactor* 0.256; 
% 
% Size_x = 128;
% Size_y = 256; %128; 
% Size_z = 256; %128;

tic %measure time

Res_x = FOV_x/Size_x;
Res_y = FOV_y/Size_y;
Res_z = FOV_z/Size_z;

%This is an adaption from makePhRainer_moveable: define Centerpoint from
%AlignPhRtoMagnImag.m Function:
Nullpkt_x= x0; %0; % 0.025;
Nullpkt_y= y0; %-0.0025; %0.002;
Nullpkt_z= z0; %0.004; %0.004;

ParameterStruct.Nullpkt_x= Nullpkt_x;
ParameterStruct.Nullpkt_y= Nullpkt_y;
ParameterStruct.Nullpkt_z= Nullpkt_z;

%%

if mod(Size_x, 2) == 0
    [x_pos] = [(-FOV_x/2):(Res_x):(FOV_x/2-Res_x)];
else
    [x_pos] = [(-(FOV_x - Res_x)/2):(Res_x):((FOV_x - Res_x)/2)];
end

if mod(Size_y, 2) == 0
    [y_pos] = [(-FOV_y/2):(Res_y):(FOV_y/2-Res_y)];
else
    [y_pos] = [(-(FOV_y - Res_y)/2):(Res_y):((FOV_y - Res_y)/2)];
end

if mod(Size_z, 2) == 0
    [z_pos] = [(-FOV_z/2):(Res_z):(FOV_z/2-Res_z)];
else
    [z_pos] = [(-(FOV_z - Res_z)/2):(Res_z):((FOV_z - Res_z)/2)];
end

% theta = pi/4;
% y_pos = y_pos * cos(theta) - z_pos * sin(theta);
% z_pos = y_pos * sin(theta) + y_pos * cos(theta);

%% How to fill the Cylinder

%Konstanten
Brain= -9.2e-6; %almost Water
Bone= -11.4e-6;
CuSO4= -8.587e-6; %instead of Ho doped Water...
Ho= -4.707e-6; %-4e-6; % Holmium Solution
Air= 0.36e-6;
PVC= -10.7063e-6; %OLD:-10.734e-6;
PVC2= -10.8456e-6; %OLD:-11.092e-6;
AgarWater= -9.03e-6; %like water. Taken from Bakker Toos Paper MRM 56 (2006) Prep of Solutions with chi = chi(air)
Water_destilled= -9.05e-6; %OLD:-9.333e-6; %-9e-6;

%%% Bereiche und wie sie zu f?llen sind: z.B.: F?llung gro?er Zylinder soll angemessen sein f?r EPI --> F_Cyl_gr~ -6ppm ... -9ppm;
% %GRO?ER Zylinder: 
% F_Zyl_gr= chi_x; %Ho; %-6e-6; % 
% %kleiner Zylinder: 
% F_Zyl_kl= chi_x; %Ho; %-6e-6; % 
% %Dreiecksprisma: destilliertes Wasser
% F_DrPr= Water_destilled; 
% %Quader: destilliertes Wasser
% F_Qu= Water_destilled; 
% %kleine Zylinderabschnitte/abteile abgetrennt durch Seitenw?nde(z-Richtung): Luft
% F_klZylA= Air; 
% %gr??erer Zylinderabschnitt/abteil abgetrennt durch Seitenwand(+/-y-Richtung): Luft sp?ter vielleicht CuSO4
% F_grBHZyl= Air; 
% %Restlicher Innenbereich des Zylinders: destilliertes Wasser
% Hauptbereich= Water_destilled; 
% 
%Restliche W?nde & Boden:
Wand= PVC;
%Deckel des Phantoms:
Deckel= PVC2;
%Tisch auf dem das Phantom steht:
Tisch= PVC;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constants for making the Phantom

% Konstanten

Hight_of_Cylinder= 0.12; %m that means 12cm.

% Auflagepkt an dem ALLE Inneren Strukturen aufliegen!!!
Stpkt= ParameterStruct.Nullpkt_x + -0.07; %m also -7cm
disp(['Stpkt= ', num2str(Stpkt),'m.']);
% und der Endpkt
Endpkt= Stpkt + Hight_of_Cylinder; %m sollte also ca bei 5cm sein. [Dann kommt noch der Deckel drauf.]
disp(['Endpkt= ', num2str(Endpkt),'m.']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% kleiner Zylinder parallel X ACHSE %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Radius des kleinen Zylinders
r_kl= .013; %m also d=2,6cm
%Dicke der H?lle
Dicke_kl= .008; %m also 0,8cm ==> d_ges= 4,2cm

%Mittelpkt der Basis des kleinen Zylinders
Zy_y0_kl= ParameterStruct.Nullpkt_y + -0.04; %m also bei y=-4cm
Zy_z0_kl= ParameterStruct.Nullpkt_z + -0.05; %m also bei z=-5cm

%Startpkt des INNENVOLUMENS bzgl der x Koordinate
Zy_kl_Stpkt= Stpkt; %m sollte also -7cm bzgl NULLPKTx-Achse sein.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% gro?er Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Radius des gro?en Zylinders
r_gr= 0.021; %m also d= 4,2cm
%Dicke der H?lle
Dicke_gr= 0.008; %m also 0,8cm ==> d_ges= 5,8cm

%Mittelpkt der Basis des Zylinders
Zy_y0_gr= ParameterStruct.Nullpkt_y + 0.02; %m also bei y=2cm
Zy_z0_gr= ParameterStruct.Nullpkt_z + 0.04; %m also bei z=4cm

%Startpkt des INNENVOLUMENS bzgl der x Koordinate
Zy_gr_Stpkt= Stpkt; %m sollte also -7cm bzgl x-Achse sein.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%     Quader      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%kurze Seite (Innenma?!)
Qu_a= 0.02; %m also 2cm
%lange Seite (Innenma?!)
Qu_b= 0.04; %m also 4cm

%Wandst?rke
Qu_WDicke= 0.008; %m also 0.8cm

%Start ECKPUNKT (Innenma?!)
Qu_StEckpkt_y0= ParameterStruct.Nullpkt_y + -0.06; %m also bei y= -6cm
Qu_StEckpkt_z0= ParameterStruct.Nullpkt_z + 0.04; %m also bei z= 4cm

%Startpkt bzgl der x Koordinate
Qu_Stpkt= Stpkt; %m sollte also -7cm bzgl x-Achse sein.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%     Dreiecks Prisma entlang x-Achse     %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%kurze Seite: Ankathete
AK= 0.04; %m also 4cm
%lange Seite: Gegenkathete
GK= 0.03; %m also 3cm

tan_alpha= GK/AK;

%Hypotenuse
HYP= 0.05; %m also 5cm

%Wandst?rke
DrPr_WDicke= 0.008; %m also 0.8cm
DrPr_WDicke_Base= 0.01; %m also 1cm %Extra(17.05.2009) for Baseline of Triangle Prism

%Start ECKPUNKT (Innenma?!)
DrPr_StEckpkt_y0= ParameterStruct.Nullpkt_y + 0; %m also bei y= 0cm
DrPr_StEckpkt_z0= ParameterStruct.Nullpkt_z + -0.02; %m also bei z= -2cm

%Startpkt bzgl der x Koordinate
DrPr_Stpkt= Stpkt; %m sollte also -7cm bzgl x-Achse sein.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% ?u?erer Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r_Haupt= 0.098; %0.099;%m also 9,9cm --> d=19.8cm mit der Dicke der Wandung ergeben sich dann die 21cm passend zum Tisch.
Dicke_Haupt= 0.01; %m also 1,0cm ==> d_ges= 21,8cm

Zy_y0_Haupt= ParameterStruct.Nullpkt_y + 0; %m also bei 0cm bzgl y-Achse
Zy_z0_Haupt= ParameterStruct.Nullpkt_z + 0; %m also bei 0cm bzgl z-Achse 

Zy_Haupt_Stpkt= Stpkt; %m sollte also bei -7cm bzgl x-Achse liegen. (Innenbereich)
%Zukunft: Zy_x0_Haupt= Stpkt;

%%%%%%% W?nde im Hauptzylinder %%%%%%%

%Dicke der Wand
Wand_Dicke= 0.006; %m also 0,6cm

%Wand parallel zur z-Achse: Distanz in Richtung der y-Achse: GROSSE ABTRENNUNG
Distanz_y_NPkt= ParameterStruct.Nullpkt_y + 0.06; %m also 6cm

%W?nde parallel zur y-Achse: Distanz in Richtung der z-Achse (pos. & neg.): KLEINE ABTRENNUNG
Distanz_z_NPkt_pos= ParameterStruct.Nullpkt_z + 0.0785; %0.08; %m also 8cm
Distanz_z_NPkt_neg= ParameterStruct.Nullpkt_z - 0.0785; %0.08; %m also 8cm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Daten f?r den Tisch und Slice Positionierung              %%%%%%
%%%%%%% Bem.: Tisch wird nicht hier erstellt, sondern nach        %%%%%%
%%%%%%%       Rotation von Phantom durch die Fkt AddBasis_n_Air.m %%%%%%
%%%%%%%       Hier werden nur die ben?tigten Parameter gesammelt  %%%%%%
%%%%%%%       und im ParameterStruct abgelegt.                    %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MaxL_xTable= 0.06; %m also 6cm maximale Ausdehnung des Tisches in x-Richtung
% Nullpkt_x= 0; %m F?r die Zukunft wenn alles Vektorbasiert ist und subpixel Shifts & Drehungen m?glich gemacht werden.
r_KopfSpule= 0.275/2; %m also Durchmesser der Kopfspule= 27,5cm & Radius 13,75cm

L_yTable= 0.22; %m also 22cm
L_zTable= 0.22; %m also 22cm

NullpktKopfSpule_x= Stpkt - Dicke_Haupt - MaxL_xTable + r_KopfSpule;
NullpktKopfSpule_y= Zy_y0_Haupt; %Phantom wird bzgl. y&z in Mitte der Kopfspule ausgerichtet, also ist Mitte Kopfspule= Mitte Phantom.
NullpktKopfSpule_z= Zy_z0_Haupt; %Phantom wird bzgl. y&z in Mitte der Kopfspule ausgerichtet



%% Parameter Struct: (to be saved later together with chi)

disp('Writing necessary information into ParameterStruct...');
ParameterStruct.FOV_x= FOV_x;
ParameterStruct.FOV_y= FOV_y;
ParameterStruct.FOV_z= FOV_z;

ParameterStruct.Size_x= Size_x;
ParameterStruct.Size_y= Size_y;
ParameterStruct.Size_z= Size_z;

ParameterStruct.Res_x= Res_x;
ParameterStruct.Res_y= Res_y;
ParameterStruct.Res_z= Res_z;

ParameterStruct.Stpkt= Stpkt;    %Pkt bzgl. der x-Achse welcher den Beginn des Phantoms markiert. (Hier kann man erweitern, um Phantom verschiebbar zu machen, sp?ter auch beliebig rotierbar... --> Alles relativ zu diesen drei Pkt x0 y0 Stpkt!)
ParameterStruct.Zy_z0_Haupt= Zy_z0_Haupt; %zusammen mit allgem. Npkt (x,y,z) notwendig f?r zuk?nftige Version in der alles auch sub Pixel geht auch Rotationen...
ParameterStruct.Zy_y0_Haupt= Zy_y0_Haupt;

% ParameterStruct.Nullpkt_x= 0;
% ParameterStruct.Nullpkt_y= 0;
% ParameterStruct.Nullpkt_z= 0;

ParameterStruct.NullpktKopfSpule_x= NullpktKopfSpule_x;
ParameterStruct.NullpktKopfSpule_y= NullpktKopfSpule_y;
ParameterStruct.NullpktKopfSpule_z= NullpktKopfSpule_z;

%For making the Table:
ParameterStruct.Tisch= Tisch;    %Suszeptibilit?t des Tisch

%Everything that can not be seen in MR-imaging
ParameterStruct.MR_invisible(1)= PVC;
ParameterStruct.MR_invisible(2)= PVC2;
ParameterStruct.MR_invisible(3)= Air;

%Past:
% ParameterStruct.Wand= Wand;      %Suszeptibilit?t der W?nde
% ParameterStruct.Tisch= Tisch;    %Suszeptibilit?t des Tisch
% ParameterStruct.Deckel= Deckel;  %Suszeptibilit?t des Deckels
% ParameterStruct.Aussen= Air;     %Suszeptibilit?t des Au?enbereichs

disp('... done.');
%% Chi erstellen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
disp('XXXXXXXXXXXXXXXXXXXXXXX      Makeing Phantom "RAINER"      XXXXXXXXXXXXXXXXXXXXXXX');
disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Suszeptibilit?tsverteilung erstellen: Vorgehen %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1.)Strukturen erstellen, dergestalt, dass nur Bereiche welche zur
% eigentlichen Struktur geh?ren, z.B. PVC Wand (Deckel, H?lle, whatever)
% mit dem entsprechenden Wert z.B. chi= PVC belegt werden, ansonsten gleich
% NULL!
% 2.) Innere Struktur des Phantoms zuerst erstellen, Variable: "InnereStruktur"
%  2.b) SPEICHER FREI MACHEN wenn fertig mit einer Struktur
%       und nach M?glichkeit nur mit einem Array arbeiten
%       oder Daten auf Festplatte zwischenspeichern!
% 3.) ?u?eren Zylinder erstellen Variable: "chi"
% 4.) chi(InnereStruktur ~= 0) = 0; Also Platz machen f?r die Innere Struktur.
% 5.) chi= chi + InnereStruktur; --> Platz schaffen f?r Innere Struktur.
%    --> Es bleiben Beriche mit Wert NULL!
%   und zur Kontrolle ploten. (Kann sp?ter entfernt werden.)
% 6.) EXTERNALITY: An allen Stellen wo chi ~=0 ist den Wert Luft einf?gen (& den Tisch hinzuf?gen!).



%% 1.) Strukturen erstellen: erst kleiner Zylinder, dann gro?er Zylinder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% kleiner Zylinder parallel X ACHSE %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Making small cylinder...');
%pause


for i= 1:Size_x
    for j= 1:Size_y
        for k= 1:Size_z
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% H?lle um Zylinder ohne Deckel & Boden %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
            %PVC um den Zylinder 
            if ( ( ( ((y_pos(j) - Zy_y0_kl)^2 + (z_pos(k) - Zy_z0_kl)^2) > (r_kl)^2 ) && ( ((y_pos(j) - Zy_y0_kl)^2 + (z_pos(k) - Zy_z0_kl)^2) <= (r_kl+Dicke_kl)^2 ) ) && ((x_pos(i) >= Zy_kl_Stpkt) && (x_pos(i) <= (Endpkt))) )
                chi_Zy_kl(j, i, k)= Wand; %Knochen;
            else
                chi_Zy_kl(j, i, k)= 0; 
            end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   Innerer Bereich des Zylinders   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %Innenbereich Zylinder der gef?llt wird.
            if ( (( ((y_pos(j) - Zy_y0_kl)^2 + (z_pos(k) - Zy_z0_kl)^2) <= r_kl^2 )) && ((x_pos(i) >= Zy_kl_Stpkt) && (x_pos(i) <= (Endpkt) )) )
                if(chi_Zy_kl(j, i, k) ~= Wand)
                    chi_Zy_kl(j, i, k)= chi_Zy_kl(j, i, k) + F_Zyl_kl; %AgarWater;
                end
                
%             else
%                 chi_Zy_kl(j, i, k)= 0; 
            end




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Boden des Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        
%             %PVC um den Zylinder
%             if ( (( ((y_pos(j) - Zy_y0_kl)^2 + (z_pos(k) - Zy_z0_kl)^2) <= (r_kl + Dicke_kl)^2 )) && ( ( (x_pos(i) >= Zy_kl_Stpkt-Dicke_kl) && (x_pos(i) <= Zy_kl_Stpkt) ) ) )
%                 chi_DBoZy_kl(j, i, k)= PVC; %Knochen;
%             else
%                 chi_DBoZy_kl(j, i, k)= 0; 
%             end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Deckel des Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        
%             %PVC um den Zylinder
%             if ( (( ((y_pos(j) - Zy_y0_kl)^2 + (z_pos(k) - Zy_z0_kl)^2) <= (r_kl + Dicke_kl)^2 )) && ( ( (x_pos(i) >= (Endpkt)) && (x_pos(i) <= (Endpkt)+Dicke_kl) ) ) )
%                 chi_DBoZy_kl(j, i, k)= PVC2; 
% %             else
% %                 chi_DBoZy_kl(j, i, k)= 0; 
%             end

        end
    end
end

% % brauche Gesamtsumme damit die Werte richtig zusammengef?gt werden!
% chi_kl= chi_HZy_kl + chi_Zy_kl; %+ chi_DBoZy_kl 

InnereStruktur= chi_Zy_kl;
disp('Small Cylinder is finished.');
%% Speicher frei machen:
disp('Free some memory...');
clear chi_Zy_kl

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% gro?er Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('Making big Cylinder...');
%pause


for i= 1:Size_x
    for j= 1:Size_y
        for k= 1:Size_z
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% H?lle um Zylinder ohne Deckel & Boden %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %Wand um den Zylinder
            if ( ( ( ((y_pos(j) - Zy_y0_gr)^2 + (z_pos(k) - Zy_z0_gr)^2) > (r_gr)^2 ) && ( ((y_pos(j) - Zy_y0_gr)^2 + (z_pos(k) - Zy_z0_gr)^2) <= (r_gr+Dicke_gr)^2 ) ) && ((x_pos(i) >= Zy_gr_Stpkt) && (x_pos(i) <= (Endpkt))) )
                chi_Zy_gr(j, i, k)= Wand;
            else
                chi_Zy_gr(j, i, k)= 0; 
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%   Innerer Bereich des Zylinders   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %Innerer Bereich des Zylinder: wird gef?llt
            if ( (( ((y_pos(j) - Zy_y0_gr)^2 + (z_pos(k) - Zy_z0_gr)^2) <= r_gr^2 )) && ((x_pos(i) >= Zy_gr_Stpkt) && (x_pos(i) <= (Endpkt) )) )
                if( chi_Zy_gr(j, i, k) ~= Wand )
                    chi_Zy_gr(j, i, k)= chi_Zy_gr(j, i, k) + F_Zyl_gr; %AgarWater;
                end
%             else
%                 chi_Zy_gr(j, i, k)= 0; 
            end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Boden des Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         
%             %Knochen um den Zylinder
%             if ( (( ((y_pos(j) - Zy_y0_gr)^2 + (z_pos(k) - Zy_z0_gr)^2) <= (r_gr+Dicke_gr)^2 )) &&  ( (x_pos(i) >= Zy_gr_Stpkt-Dicke_gr) && (x_pos(i) <= Zy_gr_Stpkt) )  ) 
%                 chi_DBoZy_gr(j, i, k)= PVC;
%             else
%                 chi_DBoZy_gr(j, i, k)= 0; %ALT: Luft/6; %insgesamt werden es 6 Summen sein...
%             end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% Deckel des Zylinder %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         
%             %Knochen um den Zylinder
%             if ( (( ((y_pos(j) - Zy_y0_gr)^2 + (z_pos(k) - Zy_z0_gr)^2) <= (r_gr+Dicke_gr)^2 )) && ( ( (x_pos(i) >= (Endpkt)) && (x_pos(i) <= (Endpkt)+Dicke_gr) ) ) )
%                 chi_DBoZy_gr(j, i, k)= PVC2;
% %             else
% %                 chi_DBoZy_gr(j, i, k)= 0; %ALT: Luft/6; %insgesamt werden es 6 Summen sein...
%             end
        end
    end
end

% % Gesamtsumme bilden um richtige Werte zu erhalten!
% chi_gr= chi_HZy_gr + chi_Zy_gr; %+ chi_DBoZy_gr 
InnereStruktur= InnereStruktur + chi_Zy_gr;
disp('Big Cylinder is finished.');
%% Speicher frei machen:
disp('Free some more Memory...');
clear chi_Zy_gr

%% Quader
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%     Quader entlang x-Achse     %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Making Cuboid...');
%pause


chi_Qu= zeros(Size_y, Size_x, Size_z);
for i= 1:Size_x
    for j= 1:Size_y
        for k= 1:Size_z

            %AgarWater Quader
            if ( ((x_pos(i) >= Qu_Stpkt) && (x_pos(i) <= Endpkt)) ) %Innerhalb des Quaders bzgl. x-Achse
                if ( ((y_pos(j) >= Qu_StEckpkt_y0) && (y_pos(j) <= Qu_StEckpkt_y0 + Qu_b)) ) %Innerhalb des Quaders bzgl. y-Achse
                    if ( ((z_pos(k) <= Qu_StEckpkt_z0) && (z_pos(k) >= Qu_StEckpkt_z0 + Qu_a)) ) %Innerhalb des Quaders bzgl. z-Achse
                        if( chi_Qu(j, i, k) ~= Wand )
                            chi_Qu(j, i, k)= F_Qu;
                        end
                    end
                end
            end
            
          %%%H?lle um Quader%%%
%             %PVC Wand in Bereich der z-y Ebene (Deckel) PVC2= durchsichtiges PVC.
%             if ( ((x_pos(i) >= Endpkt ) && (x_pos(i) <= Endpkt + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. x-Achse
%                 if ( ((y_pos(j) >= Qu_StEckpkt_y0 - Qu_WDicke) && (y_pos(j) <= Qu_StEckpkt_y0 + Qu_b + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. y-Achse
%                     if ( ((z_pos(k) >= Qu_StEckpkt_z0 - Qu_WDicke) && (z_pos(k) <= Qu_StEckpkt_z0 + Qu_a + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. z-Achse
%                         chi_Qu(j, i, k)= PVC2;
%                     end
%                 end
%             end
%             %PVC Wand in Bereich der z-y Ebene (Boden) PVC undurchsichtiges PVC
%             if ( ((x_pos(i) >= Qu_Stpkt - Qu_WDicke) && (x_pos(i) <= Qu_Stpkt)) ) %Bereich der H?lle um den Quader bzgl. x-Achse
%                 if ( ((y_pos(j) >= Qu_StEckpkt_y0 - Qu_WDicke) && (y_pos(j) <= Qu_StEckpkt_y0 + Qu_b + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. y-Achse
%                     if ( ((z_pos(k) >= Qu_StEckpkt_z0 - Qu_WDicke) && (z_pos(k) <= Qu_StEckpkt_z0 + Qu_a + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. z-Achse
%                         chi_Qu(j, i, k)= PVC;
%                     end
%                 end
%             end
            %PVC Wand in Bereich der x-y Ebene (lange Seitenw?nde [Qu_b])
            if ( ((x_pos(i) >= Qu_Stpkt) && (x_pos(i) <= Endpkt)) ) %Bereich der H?lle um den Quader bzgl. x-Achse
                if ( ((y_pos(j) > Qu_StEckpkt_y0 - Qu_WDicke) && (y_pos(j) < Qu_StEckpkt_y0 + Qu_b + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. y-Achse
                    if ( ((z_pos(k) < Qu_StEckpkt_z0 + Qu_WDicke) && (z_pos(k) >= Qu_StEckpkt_z0)) || ((z_pos(k) <= Qu_StEckpkt_z0 - Qu_a) && (z_pos(k) > Qu_StEckpkt_z0 - Qu_a - Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. z-Achse
                        if(chi_Qu(j, i, k) ~= F_Qu)
                            chi_Qu(j, i, k)= Wand;
                        end
                    end
                end
            end
            %PVC Wand in Bereich der x-z Ebene (kurze Seitenw?nde [Qu_a])
            if ( ((x_pos(i) >= Qu_Stpkt) && (x_pos(i) <= Endpkt)) ) %Bereich der H?lle um den Quader bzgl. x-Achse
                if ( ((y_pos(j) > Qu_StEckpkt_y0 - Qu_WDicke) && (y_pos(j) < Qu_StEckpkt_y0)) || ((y_pos(j) >= Qu_StEckpkt_y0 + Qu_b) && (y_pos(j) < Qu_StEckpkt_y0 + Qu_b + Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. y-Achse
                    if ( ((z_pos(k) < Qu_StEckpkt_z0 + Qu_WDicke) && (z_pos(k) > Qu_StEckpkt_z0 - Qu_a - Qu_WDicke)) ) %Bereich der H?lle um den Quader bzgl. z-Achse
                        if(chi_Qu(j, i, k) ~= F_Qu)
                            chi_Qu(j, i, k)= Wand;
                        end
                    end
                end
            end


        end
    end
end

InnereStruktur= InnereStruktur + chi_Qu;
disp('Cuboid  is finished.');
%% Speicher frei machen:
disp('Free some more Memory...');
clear chi_Qu


%% Dreiecks Prisma

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%     Dreiecks Prisma entlang x-Achse     %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Making triangular prism...');
%pause

chi_DrPr= zeros(Size_y, Size_x, Size_z);
for i= 1:Size_x
    for j= 1:Size_y
        for k= 1:Size_z

            %PVC Wand Dreiecksprisma (VOLLPRISMA, sp?ter inneres Prisma abziehen.)
            if ( ((x_pos(i) >= DrPr_Stpkt) && (x_pos(i) <= Endpkt)) ) %Innerhalb des Dreiecksprismas bzgl. x-Achse
                if ( ((y_pos(j) > DrPr_StEckpkt_y0 - DrPr_WDicke) && (y_pos(j) <= DrPr_StEckpkt_y0 + AK + 1*DrPr_WDicke)) ) %Innerhalb des Dreiecksprismas bzgl. y-Achse
                    if ( ((z_pos(k) <= DrPr_StEckpkt_z0 + DrPr_WDicke_Base)) && (z_pos(k) > (DrPr_StEckpkt_z0 - (GK + DrPr_WDicke - tan_alpha*(y_pos(j) - DrPr_StEckpkt_y0)))) ) %Innerhalb des Dreiecksprismas bzgl. z-Achse
                        chi_DrPr(j, i, k)= Wand;
                    end
                end
            end
            %AgarWater Dreiecksprisma innen
            if ( ((x_pos(i) >= DrPr_Stpkt) && (x_pos(i) <= Endpkt)) ) %Innerhalb des Dreiecksprismas bzgl. x-Achse
                if ( ((y_pos(j) >= DrPr_StEckpkt_y0) && (y_pos(j) <= DrPr_StEckpkt_y0 + AK)) ) %Innerhalb des Dreiecksprismas bzgl. y-Achse
                    if ( ((z_pos(k) <= DrPr_StEckpkt_z0)) && (z_pos(k) > (DrPr_StEckpkt_z0 - (GK - tan_alpha*(y_pos(j) - DrPr_StEckpkt_y0)))) ) %Innerhalb des Dreiecksprismas bzgl. z-Achse
                        chi_DrPr(j, i, k)= chi_DrPr(j,i,k) - Wand + F_DrPr;
                    end
                end
            end
            

        end
    end
end

disp('Triangular prism is finished.');

%% InnereStruktur erstellen und zum Test ploten, -kann sp?ter entfernt werden.
disp('Inner structure is complete.');
InnereStruktur= InnereStruktur + chi_DrPr;
%% Speicher frei machen:
disp('freeing memory...');
clear chi_DrPr
%%
% disp('InnereStruktur als Graph ausgegeben');
% % % %pause
% xslice = [0, (Qu_Stpkt + Hight_of_Cylinder + Qu_WDicke - 5*Res_x)]; %m also beim Ursprung
% yslice = Zy_y0_gr; %m beim kleinen Zylinder
% zslice = Zy_z0_gr + 0.005; %m also beim gro?en Zylinder
% figure(1);
% % subplot(1, 2, 1)
% slice(x_pos, y_pos, z_pos, InnereStruktur, xslice, yslice, zslice),title('Suszep.verteilung InnereStruktur.'),colorbar
% 
% xslice = [0, (Qu_Stpkt + Hight_of_Cylinder + Qu_WDicke - 3*Res_x)]; %m also beim Ursprung
% yslice = Zy_y0_kl; %m beim kleinen Zylinder
% zslice = Zy_z0_kl; %m also beim gro?en Zylinder
% figure(2);
% % subplot(1, 2, 2)
% slice(x_pos, y_pos, z_pos, InnereStruktur, xslice, yslice, zslice),title('Suszep.verteilung InnereStruktur.'),colorbar

%%
% %% Maske f?r Innere Struktur
% 
% disp('Maske wird erstellt.');
% 
% Maske= zeros(Size_y,Size_x,Size_z);
% 
% Maske(InnereStruktur ~= 0)= 1;


%% ?u?erer Zylinder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% ?u?erer Zylinder/HAUPTZYLINDER %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Making MAIN Cylinder...');
%pause

for i= 1:Size_x
    for j= 1:Size_y
        for k= 1:Size_z
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% H?lle um HAUPTZYLINDER ohne Deckel & Boden %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %PVC um den Zylinder
            if ( ( ( ((y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2) >= (r_Haupt)^2 ) && ( ((y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2) <= (r_Haupt+Dicke_Haupt)^2 ) ) && ((x_pos(i) >= Zy_Haupt_Stpkt) && (x_pos(i) <= (Endpkt))) )
                chi(j, i, k)= Wand;
            else
                chi(j, i, k)= 0; 
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%   Innerer Bereich des HAUPTZYLINDER   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %AgarWater Zylinder
            if ( (( ((y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2) < r_Haupt^2 )) && ((x_pos(i) >= Zy_Haupt_Stpkt) && (x_pos(i) <= (Endpkt) )) )
                chi(j, i, k)= chi(j, i, k) + Hauptbereich;
%             else
%                 chi_Zy_gr(j, i, k)= 0; 
            end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Boden des HAUPTZYLINDER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
            %BODEN: PVC um den Zylinder
            if ( (( ((y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2) <= (r_Haupt+Dicke_Haupt)^2 )) &&  ( (x_pos(i) > Zy_Haupt_Stpkt-Dicke_Haupt) && (x_pos(i) < Zy_Haupt_Stpkt) )  ) 
                chi(j, i, k)= chi(j, i, k) + Wand;
%             else
%                 chi_DBoZy_gr(j, i, k)= 0;
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Deckel des HAUPTZYLINDER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
            %DECKEL: PVC um den Zylinder
            if ( (( ((y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2) <= (r_Haupt+Dicke_Haupt)^2 )) && ( ( (x_pos(i) > (Endpkt)) && (x_pos(i) <= (Endpkt)+Dicke_Haupt) ) ) )
                chi(j, i, k)= chi(j, i, k) + Deckel;
%             else
%                 chi_DBoZy_gr(j, i, k)= 0; 
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Zwischenw?nde im HAUPTZYLINDER %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %gro?er Zylinderabschnitt parallel z-Achse
            %Wand parallel zur z-Achse
            if ( (y_pos(j) >= Distanz_y_NPkt) && (y_pos(j) <= Distanz_y_NPkt + Wand_Dicke) && ((chi(j, i, k) ~= PVC) && (chi(j, i, k) ~= 0) && (chi(j, i, k) ~= PVC2)) )
                chi(j, i, k)= Wand;
            end
            %%% Bereich f?llen
            if ( ( (y_pos(j) > Distanz_y_NPkt + Wand_Dicke) && ( ( (y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2 ) <= r_Haupt^2 ) ) && ((chi(j, i, k) ~= PVC) && (chi(j, i, k) ~= 0) && (chi(j, i, k) ~= PVC2)) )
                chi(j, i, k)= F_grBHZyl;
            end
            
            %2 kleine Zylinderabschnitte
            %W?nde parallel zur y-Achse: POS!!!!!!!!!
            if ( (z_pos(k) >= Distanz_z_NPkt_pos) && (z_pos(k) <= Distanz_z_NPkt_pos + Wand_Dicke) && ((chi(j, i, k) ~= PVC) && (chi(j, i, k) ~= 0) && (chi(j, i, k) ~= PVC2)) )
                chi(j, i, k)= Wand;
            end
            %%% Bereich f?llen
            if ( ( (z_pos(k) > Distanz_z_NPkt_pos + Wand_Dicke) && ( ( (y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2 ) <= r_Haupt^2 ) ) && ((chi(j, i, k) ~= PVC) && (chi(j, i, k) ~= 0) && (chi(j, i, k) ~= PVC2)) )
                chi(j, i, k)= F_klZylA;
            end
            
            %W?nde parallel zur y-Achse: NEG!!!!!!!!!
            if ( (z_pos(k) <= Distanz_z_NPkt_neg) && (z_pos(k) >= Distanz_z_NPkt_neg - Wand_Dicke) && ((chi(j, i, k) ~= PVC) && (chi(j, i, k) ~= 0) && (chi(j, i, k) ~= PVC2)) )
                chi(j, i, k)= Wand;
            end
            %%% Bereich f?llen
            if ( ( (z_pos(k) < Distanz_z_NPkt_neg - Wand_Dicke) && ( ( (y_pos(j) - Zy_y0_Haupt)^2 + (z_pos(k) - Zy_z0_Haupt)^2 ) <= r_Haupt^2 ) ) && ((chi(j, i, k) ~= PVC) && (chi(j, i, k) ~= 0) && (chi(j, i, k) ~= PVC2)) )
                chi(j, i, k)= F_klZylA;
            end


            
        end
    end
end

disp('MAIN Cylinder is finished.');
%% Raum frei machen f?r innere Struktur und InnereStruktur einf?gen
disp('Inserting inner structure...');
% chi(Maske == 1) = 0;
chi(InnereStruktur ~= 0) = 0;

chi= chi + InnereStruktur;
disp('MAIN Cylinder with inner structure is finished.');
%% Speicher frei machen:
disp('freeing memory...');
clear InnereStruktur
%%
% disp('Suszeptibilit?tsverteilung als Graph ausgegeben');
% % %pause

% xslice = [ParameterStruct.Nullpkt_x, (-11*ParameterStruct.Res_x)]; %m also beim Ursprung
% yslice = ParameterStruct.Nullpkt_y; %m beim Nullpkt des Phantoms
% zslice = ParameterStruct.Nullpkt_z; %m beim Nullpkt des Phantoms
% 

% PlotTitle= 'Suszeptibilit?tsverteilung Phantom "Rainer".';

% ShowResults(chi, x_pos, y_pos, z_pos, xslice, yslice, zslice, PlotTitle);

%%
% % figure(3);
% % % subplot(1, 2, 1)
% % slice(x_pos, y_pos, z_pos, chi, xslice, yslice, zslice),title(PlotTitle),colorbar
% 
% xslice = [0, (Qu_Stpkt + Hight_of_Cylinder + Qu_WDicke - 3*Res_x)]; %m also beim Ursprung
% yslice = Zy_y0_kl; %m beim kleinen Zylinder
% zslice = Zy_z0_kl; %m also beim gro?en Zylinder
% 
% PlotTitle= 'Suszeptibilit?tsverteilung Phantom "Rainer".';
% 
% ShowResults(chi, x_pos, y_pos, z_pos, xslice, yslice, zslice, PlotTitle);
% 
% % figure(4);
% % % subplot(1, 2, 2)
% % slice(x_pos, y_pos, z_pos, chi, xslice, yslice, zslice),title('Suszeptibilit?tsverteilung Phantom "Rainer".'),colorbar
% 
% 
% 
% % end
disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
disp('XXXXXXXXXXXXXXXX      Phantom "RAINER" COMPLETLY ASSEMBLED!!!     XXXXXXXXXXXXXXXX');
disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
disp(' ');
timeneeded= toc;
disp(['Time to construct Phantom "Rainer" ', num2str(timeneeded), 's.']);