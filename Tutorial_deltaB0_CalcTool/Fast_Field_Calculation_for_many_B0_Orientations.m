% "Fast_Field_Calculation_for_many_B0_Orientations.m"
disp('This is a Tutorial on FASTER delta B0 field calculation:');
%
% Note that we only need to Fourier transform the padded susceptibility distribution JUST ONCE(!)
% in order to calculate the field inhomogeneities in the object repressented by this distribution
% FOR ALL B0_Orientations that we would ever be interested in.
%
% So the first Step is to prepare the susceptibility distribution

%Generate susceptibility distribution of Phantom "Rainer" and many orientations of the B0 field as example
[Chi, ParameterStruct]= make_Phantom_R_Water; 
B_0_Orientations= 0:1:359; %One whole rotation in the coronal plane in degrees. (I hope you have a free week, because the calculation will still need that long.)
B_0 = 2.8936; %The nominal field of INUMAC Trio.

%The actual preparation of the susceptibility distribution for faster calculation
[VOI_k,ParameterStruct]= prep_VOI_distribution(Chi,ParameterStruct); %Chi gets spatially padded to VOISize and then Fourier transformed.
                                                                     %The parameter changes are noted in the ParameterStruct.
                                                                   
%Now we calculate the field for the generated B0 orientations:
% Note that we only Fourier transform the padded(!) susceptibility distribution
% ONCE FOR ALL of the 360 different orientations!!!
% --> We saved the time necessary for 359 3D-Fourier transforms
%     of the padded(!) susceptibility distribution!

for ind_Orientations= 1:size(B_0_Orientations,2)
    %Calculate Field for VOI
    VOISize_deltaB     = Calc_deltaB(VOI_k,ParameterStruct,B_0,B_0_Orientations(ind_Orientations));
    
    %Go back to the size of Chi
    ChiSize_deltaB     = VOI_2_Chi_Size(VOISize_deltaB, ParameterStruct);
    
    %Also show the field map
    FieldMap            = deltaB_2_FM(ChiSize_deltaB,ParameterStruct,Chi);
    
    %Display Results: because we rotated in the coronal plane, we only show the field in this plane.
    figure(1);
    subplot(1,3,1), imagesc(permute(Chi(:,size(Chi,2)/2,:), [3 1 2])),title('Chi')
    subplot(1,3,2), imagesc(permute(ChiSize_deltaB(:,size(ChiSize_deltaB,2)/2,:), [3 1 2])),title(['deltaB for Orientation(#',num2str(ind_Orientations),'of360)= ',num2str(B_0_Orientations(ind_Orientations)),'�.'])
    subplot(1,3,3), imagesc(permute(FieldMap(:,size(FieldMap,2)/2,:), [3 1 2])),title(['Field map for Orientation(#',num2str(ind_Orientations),'of360)= ',num2str(B_0_Orientations(ind_Orientations)),'�.'])
end
    