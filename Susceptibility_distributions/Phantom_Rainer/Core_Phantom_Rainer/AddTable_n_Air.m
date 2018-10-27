function VOI = AddTable_n_Air(VOI, ParameterStruct, Table, Air, x_pos, y_pos, z_pos)
% This Fkt takes the Array VOI, checks if the Variables 'Table' & 'Air'
% are TRUE (== '1') or FALSE (== '0') and adds the Susceptibility Values
% of the Table of the Phantom and/or Air into the Array.
% Example: VOI = AddTable_n_Air(VOI, ParameterStruct, Basis, Air, x_pos, y_pos, z_pos)
%
% Adding the Table and put Air all around:
%          chi_b= AddTable_n_Air(chi, ParameterStruct, 1, 1, x_pos, y_pos, z_pos)
% RB 20081030

tic
%%Konstanten
chi_Air= 0.36e-6;
%%
disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
disp('""""""""""""""""""""""    Adding Table & Air to "RAINER"    """"""""""""""""""""""');
disp('""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""');
if (Table == 1)
    %%%% Needs FOV & Resolution to be able to construct the Basis:
    %%%% ParameterStruct!!!
    VOI= MakeTable(VOI, ParameterStruct, x_pos, y_pos, z_pos);
    if (Air == 1)
        disp('Add TABLE & AIR.');
        VOI( VOI == 0 )= chi_Air; 
    else
        if (Air == 0)
            disp('Add only TABLE.');
        end
    end
else
    if (Table == 0)
        if (Air == 1)
            disp('Add only AIR.');
            VOI( VOI == 0 )= chi_Air;
        else
            if (Air == 0)
                disp('Add only NOTHING? ...');
                disp('...');
                disp('WAIT A MINUTE...');
                pause(2.5)
                disp('You do not want to add anything?');
                pause(1.5)
                disp('Why do you even call me then?!!!');
                pause(1.1)
                disp('Do you even know what time it is?!');
                pause(1)
                disp('I could be doing cooler stuff right now. *+#~ you!');
                pause(2)
            end
        end
    end
end

toc;
end
