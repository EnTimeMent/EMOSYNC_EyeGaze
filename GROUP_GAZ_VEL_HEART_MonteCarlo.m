% GAZE + VELOCITY + HEART data in ONE

% clear all, close all
GLOBAL_;

Parameters.Visu = true; false;  
Parameters.nofig = 0;

% % 1. Load Gaze/Hand Velocity Data
% DD = load('GAZE_HANDVELOCITY.csv');
% COLGAZE = struct('GAZE12',1,'GAZE13',2,'GAZE21',3,'GAZE23',4,'GAZE31',5,'GAZE32',6);
% TRIAD_GV = DD(:,1); TRIAL_GV = DD(:,2); EMO_GV = DD(:,4);
% GAZ = DD(:,5:10); %disp(GAZ(1,:))
% VEL = DD(:,11:13); clear DD %disp(VEL(1,:))
% 
% NN = length(TRIAD_GV); 
% WIN_ORDER_VH = zeros(NN,5); % 3 cols gaze, 1 col order V, 1 col Order H
FAKEOPMTV = zeros(NN,1);
% % 2. Load Heart Data
% D = load('Heart_Oscil.csv','-ascii');
% % [n,d] = size(D); ind = 1 : 100; t = D(ind,1); p = D(ind,2);
% TP = D(:,1:2); % Time and Peaks
% TRIAD_H = D(:,3); CONDITION_H = D(:,4); TRIAL_H = D(:,5);
% PART_H =  D(:,6); clear D
Tabs =  ViconFrequency * linspace(0,ViconDuration,ViconDuration * ViconFrequency)';
N = length(Tabs);

FAKETRIALS = zeros(15,3); IK = 1:3;
for k = 1 : 15
    IK = IK+1; IK(IK>15) = IK(IK>15)-15;
    FAKETRIALS(k,:) = IK;
end

disp(FAKETRIALS)

for triad = 1 : NTRIAD
    for trial = 1 : NGROUPMEASURE
        
        faketrial = FAKETRIALS(trial,:);       
        It1 = and(TRIAD_GV == triad, TRIAL_GV == trial); % 585000
        
        % Create faketrial group
        VELt = zeros(N,3);
        for kk = 1 : 3
            trialkk = faketrial(kk);
            Itkk = and(TRIAD_GV == triad, TRIAL_GV == trialkk);
            VELt(:,kk) = VEL(Itkk,kk);
        end
        
        % Calculate sin oscillation and phases of VELOCITY
        [~,filtV1,filtV01,sinV1,phaseV1] = f_Vel2Sin(VELt(:,1),Tabs);
        [~,filtV2,filtV02,sinV2,phaseV2] = f_Vel2Sin(VELt(:,2),Tabs);
        [~,filtV3,filtV03,sinV3,phaseV3] = f_Vel2Sin(VELt(:,3),Tabs);
        
        phaseV = [phaseV1,phaseV2,phaseV3]';
        [opmtV, ~, ~] = orderParameter(phaseV); opmtV = opmtV';
        
        % SAVE opmtV
        FAKEOPMTV(It1) = opmtV;
    end
end

save('FAKEOPMTV.csv','FAKEOPMTV','-ascii')

