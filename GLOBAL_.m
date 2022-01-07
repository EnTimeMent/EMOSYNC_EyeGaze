% Global variables

% Participants 1, 2, 3 are Clock Wise
global Parameters;
global NPDFBINS; NPDFBINS = 77; % nb pts for pdf calculations
global FirstColumnFilter; FirstColumnFilter = 1e-05;
global ViconFrequency; ViconFrequency = 100;
global ViconDuration ViconDurationms;
ViconDuration = 30; ViconDurationms = ViconDuration * ViconFrequency;
% K3* = [0,L,R; R,0,L; L,R,0]
% Origins of local coordinates [mm]
% All Coordinates of Vicon files are in [mm]
global TRIANGLEVERTICES BISSECTRICES; 
% HEIGHT = 1800
TRIANGLEVERTICES = [569,-488,1800;-633,330,1800;614,876,1800];
BISSECTRICES = [-0.4530, 0.8915; 0.9957, -0.0923; -0.5610, -0.8278];

global NTRIAD NGROUPMEASURE NINDMEASURE; % Nb Measure for each Triad
NTRIAD = 13; NGROUPMEASURE = 15; NINDMEASURE = 18; 
global MaxAlpha; MaxAlpha = pi/6; % Experiment Dependent

global MARKERSNAMES NMARKERS MARKERSCOLINDEX;
MARKERSNAMES = {'R_head'; 'L_head'; 'R_shoulder'; ...
                'R_elbow'; 'R_wrist'; 'L_wrist';'Hand';...
                'RUPA'; 'RARM'};
NMARKERS = length(MARKERSNAMES);
global NCOORD; NCOORD = 3;
z = 1 : NCOORD; Z = zeros(NMARKERS,NCOORD);
for k = 1 : NMARKERS, Z(k,:) = (k-1)*NCOORD+1 : NCOORD*k; end

MARKERSCOLINDEX = struct('R_head',Z(1,:),'L_head',Z(2,:),...
    'R_shoulder',Z(3,:),'R_elbow',Z(4,:),...
    'R_wrist', Z(5,:),'L_wrist',Z(6,:),...
    'Hand', Z(7,:), 'RUPA', Z(8,:),'RARM', Z(9,:));

% R_shoulder1,R_shoulder2,R_shoulder3
% R_elbow1,R_elbow2,R_elbow3
% R_wrist1,R_wrist2,R_wrist3, L_wrist1,L_wrist2,L_wrist3
% R_head1,R_head2,R_head3, L_head1,L_head2,L_head3
% Hand1,Hand2,Hand3
% RARM1,RARM2,RARM3, RUPA1,RUPA2,RUPA3

global EMOTIONS; EMOTIONS = 1:3;
global EPOSITIVE ENEUTRAL ENEGATIVE;
EPOSITIVE = 1; ENEUTRAL = 0; ENEGATIVE = -1;
global EMOTHRESHOLDS; EMOTHRESHOLDS = [-0.5; 0.5];


global NTRIADS; NTRIADS  = 13;
global GROUPSIZE; GROUPSIZE = 3;

global ABSINDIVIDUAL; 
ABSINDIVIDUAL = reshape((1 : NTRIADS * GROUPSIZE),GROUPSIZE,NTRIADS)';
% The GROUP trials contains 15 trials. All 3 participants are present and doing the task.
% There are 2 orders to counterbalance them and test whether there is an effect of order of emotion induction.
global ORDER;
ORDER(1).TRIAD = [1, 3, 5, 7, 9, 11, 13];% ORDER 1 : triad 1, 3, 5, 7, 9, 11, 13
ORDER(1).INDIVIDUALPOS = [3, 4, 8, 14, 15, 16]; % Positive emotion inductions: 3, 4, 8, 14, 15, 16
ORDER(1).INDIVIDUALNEU = [1, 5, 9, 10, 11, 18]; % Neutral inductions:          1, 5, 9, 10, 11, 18
ORDER(1).INDIVIDUALNEG = [2, 6, 7, 12, 13, 17]; % Negative emotion inductions: 2, 6, 7, 12, 13, 17
ORDER(1).GROUPPOS = [3, 4, 5, 11, 14]; % Positive emotion inductions: 3, 4, 5, 11, 14
ORDER(1).GROUPNEU = [2, 7, 8, 10, 15]; % Neutral inductions:          2, 7, 8, 10, 15
ORDER(1).GROUPNEG = [1, 6, 9, 12, 13]; % Negative emotion inductions: 1, 6, 9, 12, 13
% ORDER 1 : triad 1, 3, 5, 7, 9, 11, 13
% INDIVIDUAL Trials
% Positive emotion inductions: 3, 4, 8, 14, 15, 16
% Neutral inductions: 1, 5, 9, 10, 11, 18
% Negative emotion inductions: 2, 6, 7, 12, 13, 17
% GROUP trials
% Positive emotion inductions: 3, 4, 5, 11, 14
% Neutral inductions: 2, 7, 8, 10, 15
% Negative emotion inductions: 1, 6, 9, 12, 13

ORDER(2).TRIAD = [2, 4, 6, 8, 10, 12]; % ORDER 2 : triad 2, 4, 6, 8, 10, 12
ORDER(2).INDIVIDUALPOS = [3, 4, 5, 11, 12, 13]; % Positive emotion inductions: 3, 4, 5, 11, 12, 13
ORDER(2).INDIVIDUALNEU = [2, 7, 9, 10, 14, 18]; % Neutral inductions:          2, 7, 9, 10, 14, 18
ORDER(2).INDIVIDUALNEG = [1, 6, 8, 15, 16, 17]; % Negative emotion inductions: 1, 6, 8, 15, 16, 17
ORDER(2).GROUPPOS = [2, 7, 10, 12, 13]; % Positive emotion inductions: 2, 7, 10, 12, 13
ORDER(2).GROUPNEU = [5, 6, 8, 9, 15];   % Neutral inductions:          5, 6, 8, 9, 15
ORDER(2).GROUPNEG = [1, 3, 4, 11, 14];  % Negative emotion inductions: 1, 3, 4, 11, 14
% The INDIVIDUAL trials contains 18 trials. Each individual trial has the data of 1 participant. 
% The recording was done one after another, the first participant, then 
% the second, then the third and all over again. To illustrate: 
% the participant 1 performed the individual trials: 1, 4, 7, 10, 13, 16
% the participant 2 performed the individual trials: 2, 5, 8, 11, 14, 17
% the participant 3 performed the individual trials: 3, 6, 9, 12, 15, 18

% ORDER 2 : triad 2, 4, 6, 8, 10, 12.
% INDIVIDUAL Trials
% Positive emotion inductions: 3, 4, 5, 11, 12, 13
% Neutral inductions: 2, 7, 9, 10, 14, 18
% Negative emotion inductions: 1, 6, 8, 15, 16, 17
% GROUP trials
% Positive emotion inductions: 2, 7, 10, 12, 13
% Neutral inductions: 5, 6, 8, 9, 15
% Negative emotion inductions: 1, 3, 4, 11, 14

global YHeader; 
YHeader = {'Triad','Order','NoGroupTrial','NoIndividualTrial',...
           'RELindex','Person','Emotion'};
global ITRIAD; ITRIAD = 1;
global IORDER; IORDER = 2;
global IGROUP; IGROUP = 3;
global IINDIV; IINDIV = 4;
global IREL; IREL = 5;
global IPERSON; IPERSON = 6;
global IEMOTION; IEMOTION = 7;
% DATA.YHeader = {'Triad','Order','NoGroupTrial',...
%                 'NoIndividualTrial','RELindex','Person','Emotion'}

            
       