clear
waittime= 3;%s
%% Enter general parameters: in all direction the same for now.
%   We start with 64x64x64 and leave FOV= 256mm in all directions.

% For the first test we do it by hand, later we sort out which resolutions
% we liked best and do all in comparison!
SizeFactor= input('Please enter the SizeFactor: [1 --> Res=64x64x64] ');
if(isempty(SizeFactor))
    SizeFactor= 1;
end

BasicSize = 64;

Size_x= SizeFactor * BasicSize;
Size_y= SizeFactor * BasicSize;
Size_z= SizeFactor * BasicSize;

FOV_x= 0.128; %0.256;
FOV_y= 0.128; %0.256;
FOV_z= 0.128; %0.256;


%% make the Sphere for the Simulation
Radius = 0.01; %0.0128;
chi_int= -9.05e-6; %water
chi_ext= 0; %vacuum % 0.36e-6; %air 
Kugel_x0= 0;
Kugel_y0= 0;
Kugel_z0= 0;

[chi ParameterStruct x_pos y_pos z_pos]= makeChi3D_Sphere_mk2(Size_x, Size_y, Size_y,  FOV_x,  FOV_y,  FOV_z, Radius, chi_int, chi_ext, Kugel_x0, Kugel_y0, Kugel_z0);

PadFactor= 1; %2; %3;
if(PadFactor == 1)
    y_Start= 1;
    y_End= ParameterStruct.Size_y;
    x_Start= 1;
    x_End= ParameterStruct.Size_x;
    z_Start= 1;
    z_End= ParameterStruct.Size_z;
else
    if(PadFactor > 1)
        [chi, ParameterStruct, x_pos, y_pos, z_pos] = SpatialPadding(chi, ParameterStruct, PadFactor);
        SizeXtra= (ParameterStruct.Size_x - ParameterStruct.Size_xOLD)/2;
        y_Start= 1 + SizeXtra;
        y_End= ParameterStruct.Size_yOLD + SizeXtra;
        x_Start= 1 + SizeXtra;
        x_End= ParameterStruct.Size_xOLD + SizeXtra;
        z_Start= 1 + SizeXtra;
        z_End= ParameterStruct.Size_zOLD + SizeXtra;
    end
end




%% calculate deltaB0 with Sim
B_0= 2.8936; %T nominal field of INUMAC Trio
Angle= 0; %Try out to rotate later on.

VOISize_deltaB = Calc_deltaB0(chi,ParameterStruct,B_0,Angle);

delta_B0_Sim = VOI_2_Chi_Size(VOISize_deltaB, ParameterStruct);

%% Sample the analytic Solution
analytic_deltaB0_field= Sphere_deltaB_ANALYTICAL(ParameterStruct.Size_x, ParameterStruct.Size_y, ParameterStruct.Size_z, ParameterStruct.FOV_x, ParameterStruct.FOV_y, ParameterStruct.FOV_z, Radius, chi_int, chi_ext,    B_0, Kugel_x0, Kugel_y0, Kugel_z0);

%% Test Rotation of analytic Field and comparison with calculation

%do that later

%% helpful calculations
Diff_3D= analytic_deltaB0_field - delta_B0_Sim;

%disp('problemo?');
center_z_Axis= round(ParameterStruct.Size_z/2) + 1;
XY_Slice_ana = analytic_deltaB0_field(:,:,center_z_Axis);
XY_Slice_sim = delta_B0_Sim(:,:,center_z_Axis);
XY_Slice_Diff= Diff_3D(:,:,center_z_Axis);

center_y_Axis= round(ParameterStruct.Size_y/2) + 1;
XZ_Slice_ana = permute(analytic_deltaB0_field(center_y_Axis,:,:), [3 2 1]);
XZ_Slice_sim = permute(delta_B0_Sim(center_y_Axis,:,:), [3 2 1]);
XZ_Slice_Diff= permute(Diff_3D(center_y_Axis,:,:), [3 2 1]);

center_x_Axis= round(ParameterStruct.Size_x/2) + 1;
YZ_Slice_ana = permute(analytic_deltaB0_field(:,center_x_Axis,:), [1 3 2]);
YZ_Slice_sim = permute(delta_B0_Sim(:,center_x_Axis,:), [1 3 2]);
YZ_Slice_Diff= permute(Diff_3D(:,center_x_Axis,:), [1 3 2]);



Trace_along_x_deltaB0= permute(XY_Slice_sim(center_y_Axis,:), [2 1]); %this means we are at center of z-Axis and y-Axis and take the remaining data --> data along x-Axis.
Trace_along_x_analytic_deltaB0= permute(XY_Slice_ana(center_y_Axis,:), [2 1]);

Trace_along_y_deltaB0= XY_Slice_sim(:,center_x_Axis);
Trace_along_y_analytic_deltaB0= XY_Slice_ana(:,center_x_Axis);

Trace_along_z_deltaB0= permute(YZ_Slice_sim(center_y_Axis,:), [2 1]);
Trace_along_z_analytic_deltaB0= permute(YZ_Slice_ana(center_y_Axis,:), [2 1]);

%% Diff of Traces!
ABSdiffTrace_along_x= abs(Trace_along_x_analytic_deltaB0 - Trace_along_x_deltaB0);
ABSdiffTrace_along_y= abs(Trace_along_y_analytic_deltaB0 - Trace_along_y_deltaB0);
ABSdiffTrace_along_z= abs(Trace_along_z_analytic_deltaB0 - Trace_along_z_deltaB0);
%% Do the plots
%% Slices:
%1.) XY Plot: center of z-Axis; ANA, SIM, DIFF
figure(1);
subplot(1,3,1), imagesc(XY_Slice_ana(y_Start:y_End,y_Start:y_End)),title('XY: analytic')
subplot(1,3,2), imagesc(XY_Slice_sim(y_Start:y_End,y_Start:y_End)),title('XY: simulation')
subplot(1,3,3), imagesc(XY_Slice_Diff(y_Start:y_End,y_Start:y_End), [-100 100]),title('XY: diff= sim - ana'),colorbar,colormap(jet)
pause(waittime)

%2.) XZ Plot: center of y-Axis; ANA, SIM, DIFF
figure(2);
subplot(1,3,1), imagesc(XZ_Slice_ana(z_Start:z_End,x_Start:x_End)),title('XZ: analytic')
subplot(1,3,2), imagesc(XZ_Slice_sim(z_Start:z_End,x_Start:x_End)),title('XZ: simulation')
subplot(1,3,3), imagesc(XZ_Slice_Diff(z_Start:z_End,x_Start:x_End), [-100 100]),title('XZ: diff= sim - ana'),colorbar,colormap(jet)
pause(waittime)

%3.) YZ Plot: center of x-Axis; ANA, SIM, DIFF
figure(3);
subplot(1,3,1), imagesc(YZ_Slice_ana(z_Start:z_End,y_Start:y_End)),title('YZ: analytic')
subplot(1,3,2), imagesc(YZ_Slice_sim(z_Start:z_End,y_Start:y_End)),title('YZ: simulation')
subplot(1,3,3), imagesc(YZ_Slice_Diff(z_Start:z_End,y_Start:y_End), [-100 100]),title('YZ: diff= ana - sim'),colorbar,colormap(jet)
pause(waittime)

%% Traces:
%1.) along x-Axis
figure(4);  plot(x_pos(x_Start:x_End), Trace_along_x_analytic_deltaB0(x_Start:x_End)), ylim([-100 500]),title('Trace along the x-Axis: analytic Solution VS. simulation deltaB0'),hold on
            plot(x_pos(x_Start:x_End), Trace_along_x_deltaB0(x_Start:x_End), 'xr'), hold on
            plot(x_pos(x_Start:x_End), ABSdiffTrace_along_x(x_Start:x_End), ':g'), hold off
pause(waittime)

%2.) along y-Axis
figure(5);  plot(y_pos(y_Start:y_End), Trace_along_y_analytic_deltaB0(y_Start:y_End)), ylim([-100 500]),title('Trace along the y-Axis: analytic Solution VS. simulation deltaB0'),hold on
            plot(y_pos(y_Start:y_End), Trace_along_y_deltaB0(y_Start:y_End), 'xr'), hold on
            plot(y_pos(y_Start:y_End), ABSdiffTrace_along_y(y_Start:y_End), ':g'), hold off
pause(waittime)

%3.) along z-Axis
figure(6);  plot(z_pos(z_Start:z_End), Trace_along_z_analytic_deltaB0(z_Start:z_End)), ylim([-800 200]),title('Trace along the z-Axis: analytic Solution VS. simulation deltaB0'),hold on
            plot(z_pos(z_Start:z_End), Trace_along_z_deltaB0(z_Start:z_End), 'xr'), hold on
            plot(z_pos(z_Start:z_End), ABSdiffTrace_along_z(z_Start:z_End), ':g'), hold off
pause(waittime)

%% Error plot for several resolutions along one favourite axis in %FOV.
SuscepBoundary_x= center_x_Axis + Radius/ParameterStruct.Res_x;
SuscepBoundary_y= center_y_Axis + Radius/ParameterStruct.Res_y;
SuscepBoundary_z= center_z_Axis + Radius/ParameterStruct.Res_z;

percent_suscept_boundary_x= ((x_pos(SuscepBoundary_x:x_End)-Radius)./(FOV_x)).*100;
percent_suscept_boundary_y= ((y_pos(SuscepBoundary_y:y_End)-Radius)./(FOV_y)).*100;
percent_suscept_boundary_z= ((z_pos(SuscepBoundary_z:z_End)-Radius)./(FOV_z)).*100;

Computational_Error_x= (ABSdiffTrace_along_x(SuscepBoundary_x:x_End)./abs(Trace_along_x_analytic_deltaB0(SuscepBoundary_x:x_End))).*100;
Computational_Error_y= (ABSdiffTrace_along_y(SuscepBoundary_y:y_End)./abs(Trace_along_y_analytic_deltaB0(SuscepBoundary_y:y_End))).*100;
Computational_Error_z= (ABSdiffTrace_along_z(SuscepBoundary_z:z_End)./abs(Trace_along_z_analytic_deltaB0(SuscepBoundary_z:z_End))).*100;

% well do that in a loop if possible!
figure(7); plot(percent_suscept_boundary_x, Computational_Error_x, '-.xr'),title('Computational Error in percent: Trace along x from susceptibility boundary to end of original FOV')
pause(waittime)
figure(8); plot(percent_suscept_boundary_y, Computational_Error_y, '-.xr'),title('Computational Error in percent: Trace along y from susceptibility boundary to end of original FOV')
pause(waittime)
figure(9); plot(percent_suscept_boundary_z, Computational_Error_z, '-.xr'),title('Computational Error in percent: Trace along z from susceptibility boundary to end of original FOV')
pause(waittime)