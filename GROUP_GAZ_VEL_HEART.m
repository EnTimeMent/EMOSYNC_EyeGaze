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
% % 2. Load Heart Data
% D = load('Heart_Oscil.csv','-ascii');
% % [n,d] = size(D); ind = 1 : 100; t = D(ind,1); p = D(ind,2);
% TP = D(:,1:2); % Time and Peaks
% TRIAD_H = D(:,3); CONDITION_H = D(:,4); TRIAL_H = D(:,5);
% PART_H =  D(:,6); clear D
% Tabs =  ViconFrequency * linspace(0,ViconDuration,ViconDuration * ViconFrequency)';
N = length(Tabs);

for triad = 1 : NTRIAD
    for trial = 1 : NGROUPMEASURE
        % triad = 2; trial = 2;
        condition = 1; % GROUP CONDITION
        
        % Cut this triad/trial in GAZ_VEL GROUP data
        It1 = and(TRIAD_GV == triad, TRIAL_GV == trial); % 585000
        EMOt = EMO_GV(It1);
        GAZt = GAZ(It1,:); % G0t = G0(It,:); GAZt1 = GAZt; G0t1 = G0t;
        % COLGAZE = struct('GAZE12',1,'GAZE13',2,'GAZE21',3,'GAZE23',4,'GAZE31',5,'GAZE32',6);
        VELt = VEL(It1,:); %VELt1 = VELt;
        
        % Calculate the gaze received by each player
        G0t = zeros(N,3);
        % ! Beware. the more low values the more i gazes j
        icolg = [COLGAZE.GAZE21,COLGAZE.GAZE31]; G0t(:,1) = mean(GAZt(:,icolg),2);
        icolg = [COLGAZE.GAZE12,COLGAZE.GAZE32]; G0t(:,2) = mean(GAZt(:,icolg),2);
        icolg = [COLGAZE.GAZE13,COLGAZE.GAZE23]; G0t(:,3) = mean(GAZt(:,icolg),2);
                
        % Calculate sin oscillation and phases of VELOCITY
        [~,filtV1,filtV01,sinV1,phaseV1] = f_Vel2Sin(VELt(:,1),Tabs);
        [~,filtV2,filtV02,sinV2,phaseV2] = f_Vel2Sin(VELt(:,2),Tabs);
        [~,filtV3,filtV03,sinV3,phaseV3] = f_Vel2Sin(VELt(:,3),Tabs);
        
        phaseV = [phaseV1,phaseV2,phaseV3]';
        [opmtV, ~, ~] = orderParameter(phaseV); opmtV = opmtV';
        
%         % COMPARE DIRECT OPMT on VEL
%         [directopmtV, ~, ~] = orderParameter(VELt'); directopmtV = directopmtV';
%         if true
%             plot([opmtV,directopmtV]), legend('true opmt','direct opmt')
%         end        
        
        % Cut this triad/trial in Heart data for condition == 1 GROUP data
        Icond = CONDITION_H == condition;
        Itriad = TRIAD_H == triad; Itrial = TRIAL_H == trial;
        It2 = and(and(Itriad,Icond),Itrial);
        
        tp1 = TP(and(It2,PART_H == 1),1:2); tp1(:,1) = round(ViconFrequency * tp1(:,1));
        tp2 = TP(and(It2,PART_H == 2),1:2); tp2(:,1) = round(ViconFrequency * tp2(:,1));
        tp3 = TP(and(It2,PART_H == 3),1:2); tp3(:,1) = round(ViconFrequency * tp3(:,1));
        
        [~,sinH1,phaseH1] = f_Heart2Sin(tp1(:,1),tp1(:,2),Tabs);
        [~,sinH2,phaseH2] = f_Heart2Sin(tp2(:,1),tp2(:,2),Tabs);
        [~,sinH3,phaseH3] = f_Heart2Sin(tp3(:,1),tp3(:,2),Tabs);
        
        phaseH = [phaseH1,phaseH2,phaseH3]';
        [opmtH, ~, ~] = orderParameter(phaseH); opmtH = opmtH';
        
        % SAVE opmtV, opmtH
        WIN_ORDER_VH(It1,:) = [G0t,opmtV,opmtH];
        
        if Parameters.Visu
            nofig  = Parameters.nofig;
            % Plot all of this
            % 1. Gaze - 2 variants mutual couples, winner
            % 'GAZE12',1,'GAZE13',2,'GAZE21',3,'GAZE23',4,'GAZE31',5,'GAZE32',6);
            IROWS = 1 : N;
            %             nofig = nofig + 1; figure(nofig), clf
            %             ax = Tabs(IROWS);
            %             subplot(3,2,1)
            %             ig = [COLGAZE.GAZE12,COLGAZE.GAZE21]; GAZig = GAZt(IROWS,ig);
            %             plot(ax,GAZig), legend('Gaze12','Gaze21'), title('Mutual Gaze 1, 2')
            %             subplot(3,2,3)
            %             ig = [COLGAZE.GAZE13,COLGAZE.GAZE31]; GAZig = GAZt(IROWS,ig);
            %             plot(ax,GAZig), legend('Gaze13','Gaze31'), title('Mutual Gaze 1, 3')
            %             subplot(3,2,5)
            %             ig = [COLGAZE.GAZE23,COLGAZE.GAZE32]; GAZig = GAZt(IROWS,ig);
            %             plot(ax,GAZig), legend('Gaze23','Gaze32'), title('Mutual Gaze 2, 3')
            %
            %             subplot(3,2,2)
            %             plot(ax,G0t(IROWS,1)), title('P1 is gazed')
            %             subplot(3,2,4)
            %             plot(ax,G0t(IROWS,2)), title('P2 is gazed')
            %             subplot(3,2,6)
            %             plot(ax,G0t(IROWS,3)), title('P3 is gazed')
            
            % 2. Velocity - filtV1,filtV01,sinV1,phaseV1
            nofig = nofig + 1; figure(nofig), clf
            ax = Tabs(IROWS);
            subplot(2,2,1)
            M = [filtV1,filtV2,filtV3]; M = M(IROWS,:);
            plot(ax,M), legend('Vel 1','Vel 2','Vel 3'), title('Hand Velocities')
            subplot(2,2,2)
            M = [filtV01,filtV02,filtV03];  M = M(IROWS,:);
            plot(ax,M), legend('Vel0 1','Vel0 2','Vel0 3'), title('Hand Velocities Oscillations')
            subplot(2,2,3)
            M = [sinV1,sinV2,sinV3];  M = M(IROWS,:);
            plot(ax,M), legend('Vel 1','Vel 2','Vel 3'), title('Hand Velocities Sinusoidal Oscillations')
            subplot(2,2,4)
            M = [phaseV1,phaseV2,phaseV3];  M = M(IROWS,:);
            plot(ax,M), legend('Phase V 1','Phase V 2','Phase V 3'), title('Hand Velocities Phases')
                        
            % 3. Heart - peaks sinH1,phaseH1            
            nofig = nofig + 1; figure(nofig), clf,
            ax = Tabs(IROWS);  hold on
            subplot(211)
            tp = tp1; plot(tp(:,1),tp(:,2),':ok',ax,sinH1(IROWS),'-k')
            tp = tp2; plot(tp(:,1),tp(:,2),':ob',ax,sinH2(IROWS),'-b')
            tp = tp3; plot(tp(:,1),tp(:,2),':or',ax,sinH3(IROWS),'-r')
            axis([0,max(ax), -1.01, 1.01])
            legend('Sin H1','Sin H2','Sin H3'), title('Sinusoidal Heart Beats')
            hold off
            subplot(212)
            M = [phaseH1,phaseH2,phaseH3]; M = M(IROWS,:);
            plot(ax,M)
            legend('Phase H1','Phase H2','Phase H3'), title('Phases Heart Beats')
            
            % 4. opmtV, opmtH
            nofig = nofig + 1; figure(nofig), clf
            plot(Tabs,opmtV,'-r',Tabs,opmtH,'-b')
            legend('Velocity Order Parameter','Heart Order Parameter')
            
            
            'wait'
        end
    end
end

% save('WIN_ORDER_VH.csv','WIN_ORDER_VH','-ascii')

% % Phase 1
% SCENARIO.NAME = 'GAZE_VEL_HAND'; nameS = [SCENARIO.NAME,'.mat'];
% [G,GAZ1,G1,VEL1] = f_GazVelReg(COLGAZE,TRD_GV,TRL,EMO_GV,GAZ,VEL);
% save(nameS,'G','GAZ1','G1','VEL1');
