function VOI= MakeTable(VOI, ParameterStruct, x_pos, y_pos, z_pos)

%% Konstanten

MaxL_xTable= 0.06; %m also 6cm maximale Ausdehnung des Tisches in x-Richtung
% Nullpkt_x= 0; %m F?r die Zukunft wenn alles Vektorbasiert ist und subpixel Shifts & Drehungen m?glich gemacht werden.
r_KopfSpule= 0.275/2; %m also Durchmesser der Kopfspule= 27,5cm & Radius 13,75cm

L_yTable= 0.22; %m also 22cm
L_zTable= 0.22; %m also 22cm

NullpktKopfSpule_x= ParameterStruct.Stpkt - MaxL_xTable + r_KopfSpule;
NullpktKopfSpule_y= ParameterStruct.Zy_y0_Haupt; %Phantom wird bzgl. y&z in Mitte der Kopfspule ausgerichtet, also ist Mitte Kopfspule= Mitte Phantom.
NullpktKopfSpule_z= ParameterStruct.Zy_z0_Haupt; %Phantom wird bzgl. y&z in Mitte der Kopfspule ausgerichtet

%% Get the Startpoint of the Phantom and attach the table to it:

for i=1:ParameterStruct.Size_x
    for j=1:ParameterStruct.Size_y
        for k=1:ParameterStruct.Size_z
           %Tisch hat Abrundung in x-y Ebene und ist im Bereich der x-Achse: von StartPkt bis zum tiefsten Pkt des Tisches (-6cm)
           %Des Weiteren ist die Abmessung des Tisches in der y-z Ebene (oberer Teil) 220mmx220mm --> 0.22mx0.22m 
            if ( (x_pos(i) < ParameterStruct.Stpkt) && (x_pos(i) >= ParameterStruct.Stpkt - MaxL_xTable) ) %Abmessung ENTLANG x-Achse
%                 if ( ((x_pos(i) - ParameterStruct.Nullpkt_x)^2 + (z_pos(k) - ParameterStruct.Nullpkt_z)^2) <= (r_KopfSpule)^2 ) %Kr?mmung der Fl?che ?ber Radius der Kopfspule bzgl. Nullpkt
                if ( ((x_pos(i) - NullpktKopfSpule_x)^2 + (y_pos(j) - NullpktKopfSpule_y)^2) <= (r_KopfSpule)^2 ) %Kr?mmung der Fl?che ?ber Radius der Kopfspule bzgl. Nullpkt
                    if ( ((y_pos(j) >= (ParameterStruct.Nullpkt_y - L_yTable/2)) && (y_pos(j) <= (ParameterStruct.Nullpkt_y + L_yTable/2))) && ((z_pos(k) >= (ParameterStruct.Nullpkt_z - L_zTable/2)) && (z_pos(k) <= (ParameterStruct.Nullpkt_z + L_zTable/2))) ) %Abmessung in y-z Ebene
%                         if () %Wertabfrage um nicht Teile des Phantoms zu ?berschreiben...
                       VOI(j, i, k) = ParameterStruct.Tisch;
                    end
                end
%             else
%                 VOI(j, i, k) = VOI(j, i, k);
            end
        end
    end
end

%%
% disp('Suszeptibilit?tsverteilung mit TISCH als Graph ausgegeben');
% % %pause
% xslice = [ParameterStruct.Nullpkt_x, NullpktKopfSpule_x]; %m also beim Ursprung
% yslice = [ParameterStruct.Nullpkt_y, NullpktKopfSpule_y]; %m beim Nullpkt des Phantoms
% zslice = [ParameterStruct.Nullpkt_z, NullpktKopfSpule_z]; %m beim Nullpkt des Phantoms

% PlotTitle= 'Tisch hinzugef?gt.';

% ShowResults(VOI, x_pos, y_pos, z_pos, xslice, yslice, zslice, PlotTitle);

disp('Nullpkt Kopfspule liegt bzgl unseres Koordinatensystems bei:');
disp(['(x,y,z)= (', num2str(NullpktKopfSpule_x),',', num2str(NullpktKopfSpule_y),',', num2str(NullpktKopfSpule_z),').']);
end