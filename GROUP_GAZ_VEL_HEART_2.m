% GAZE + VELOCITY + HEART data in ONE

%clear all, close all
GLOBAL_;

Parameters.Visu = true; false; 
Parameters.nofig = 0;

% % 1. Load Gaze/Hand Velocity Data
% DD = load('GAZE_HANDVELOCITY0.csv');
% COLGAZE = struct('GAZE12',1,'GAZE13',2,'GAZE21',3,'GAZE23',4,'GAZE31',5,'GAZE32',6);
% TRIAD_GV = DD(:,1); TRIAL_GV = DD(:,2); COND_GV = DD(:,3); EMO_GV = DD(:,4);
% GAZ = DD(:,5:10); VEL = DD(:,11:13);  clear DD
% NN = length(TRIAD_GV);
% 
% D = load('WIN_ORDER_VH0.csv'); %,'WIN_ORDER_VH','-ascii')
% WIN_G0 = D(:,1:3); oV0 = D(:,4); oH0 = D(:,5);  clear D

% GAZE - Metric of GazeDiscrimination - V - VELOCITY, H - HEART
% GAZEVELOCDISCRIM = t_MetricGaze(TRIAD_GV,TRIAL_GV,EMO_GV,WIN_G0);
GAZEVELOCDISCRIM.medianV_H = zeros(NTRIAD,3);
GAZEVELOCDISCRIM.medianV_M = zeros(NTRIAD,3);
GAZEVELOCDISCRIM.medianV_W = zeros(NTRIAD,3);
GAZEVELOCDISCRIM.Vpvalues = zeros(NTRIAD,4);
GAZEVELOCDISCRIM.medianH_H = zeros(NTRIAD,3);
GAZEVELOCDISCRIM.medianH_M = zeros(NTRIAD,3);
GAZEVELOCDISCRIM.medianH_W = zeros(NTRIAD,3);
GAZEVELOCDISCRIM.Hpvalues = zeros(NTRIAD,4);

% VELOCITY
VTTS_H = zeros(NTRIAD,NGROUPMEASURE); % Time To Sync global High
VTTS_M = zeros(NTRIAD,NGROUPMEASURE); % Time To Sync global Medium
VTTS_W = zeros(NTRIAD,NGROUPMEASURE); % Time To Sync global Weak
VTIS_H = zeros(NTRIAD,NGROUPMEASURE); % Time In Sync global High
VTIS_M = zeros(NTRIAD,NGROUPMEASURE); % Time In Sync global Medium
VTIS_W = zeros(NTRIAD,NGROUPMEASURE); % Time In Sync global Weak
VOPAmedian = zeros(NTRIAD,NGROUPMEASURE); % median values of order parameter
VOPAstd = zeros(NTRIAD,NGROUPMEASURE); % standard deviations of order parameter
VSYNC = zeros(NTRIAD,3);

% HEART
HTTS_H = zeros(NTRIAD,NGROUPMEASURE); % Time To Sync global High
HTTS_M = zeros(NTRIAD,NGROUPMEASURE); % Time To Sync global Medium
HTTS_W = zeros(NTRIAD,NGROUPMEASURE); % Time To Sync global Weak
HTIS_H = zeros(NTRIAD,NGROUPMEASURE); % Time In Sync global High
HTIS_M = zeros(NTRIAD,NGROUPMEASURE); % Time In Sync global Medium
HTIS_W = zeros(NTRIAD,NGROUPMEASURE); % Time In Sync global Weak
HOPAmedian = zeros(NTRIAD,NGROUPMEASURE); % median values of order parameter
HOPAstd = zeros(NTRIAD,NGROUPMEASURE); % standard deviations of order parameter
HSYNC = zeros(NTRIAD,3);

% UNIVERSAL Time
UT =  ViconFrequency * linspace(0,ViconDuration,ViconDuration * ViconFrequency)';
DT = UT(2) - UT(1);
% SIGNIFICANT Time Duration in Sync (10%) of overall duration (30s)
NMinSecInSync = 3;

for triad = 1 : NTRIAD
    
    % Define sync levels quartiles of 25% per triad
    Itriad = TRIAD_GV == triad;
    
    [vsync,hsync] = t_DefineSyncLevels(oV0(Itriad),oH0(Itriad),0.25);
    
    VSYNC(triad,:) = vsync;
    HSYNC(triad,:) = hsync;
    
    %global SYNCTHRESHOLD SYNCLEVELS STHRESH;
    VSYNCTHRESHOLD = struct('nosync',[0,vsync(1)],'weaksync',[vsync(1),vsync(2)],...
        'mediumsync',[vsync(2),vsync(3)],'highsync',[vsync(3),1]);
    HSYNCTHRESHOLD = struct('nosync',[0,hsync(1)],'weaksync',[hsync(1),hsync(2)],...
        'mediumsync',[hsync(2),hsync(3)],'highsync',[hsync(3),1]);    
    
    for trial = 1 : NGROUPMEASURE
        
        Igt = and(Itriad, TRIAL_GV == trial); % gt = sum(Igt);        
        % emot_gt = EMO_GV(Igt); ue = unique(emot_gt);
        oV_gt = oV0(Igt); oH_gt = oH0(Igt);
        disp([triad,trial])
        
        % DIMGgt = f_DistSyncGSyncGminusOne(Pgt);%,ind_delay);
        
        % VELOCITY characteristics
        VOPAmedian(triad,trial) = median(oV_gt);
        VOPAstd(triad,trial) = std(oV_gt);        
        synclevel = VSYNCTHRESHOLD.weaksync;
        VTTS_W(triad,trial) = f_TimeToSync(oV_gt,synclevel,UT,NMinSecInSync);
        VTIS_W(triad,trial) = f_TimeInSync(oV_gt,DT,synclevel,NMinSecInSync);        
        synclevel = VSYNCTHRESHOLD.mediumsync;
        VTTS_M(triad,trial) = f_TimeToSync(oV_gt,synclevel,UT,NMinSecInSync);
        VTIS_M(triad,trial) = f_TimeInSync(oV_gt,DT,synclevel,NMinSecInSync);        
        synclevel = VSYNCTHRESHOLD.highsync;
        VTTS_H(triad,trial) = f_TimeToSync(oV_gt,synclevel,UT,NMinSecInSync);
        VTIS_H(triad,trial) = f_TimeInSync(oV_gt,DT,synclevel,NMinSecInSync);
        
        % HEART characteristics
        HOPAmedian(triad,trial) = median(oH_gt);
        HOPAstd(triad,trial) = std(oH_gt);        
        synclevel = HSYNCTHRESHOLD.weaksync;
        HTTS_W(triad,trial) = f_TimeToSync(oH_gt,synclevel,UT,NMinSecInSync);
        HTIS_W(triad,trial) = f_TimeInSync(oH_gt,DT,synclevel,NMinSecInSync);        
        synclevel = HSYNCTHRESHOLD.mediumsync;
        HTTS_M(triad,trial) = f_TimeToSync(oH_gt,synclevel,UT,NMinSecInSync);
        HTIS_M(triad,trial) = f_TimeInSync(oH_gt,DT,synclevel,NMinSecInSync);        
        synclevel = HSYNCTHRESHOLD.highsync;
        HTTS_H(triad,trial) = f_TimeToSync(oH_gt,synclevel,UT,NMinSecInSync);
        HTIS_H(triad,trial) = f_TimeInSync(oH_gt,DT,synclevel,NMinSecInSync);
        
        if Parameters.Visu            
            utt = UT / ViconFrequency; z0 = zeros(1,length(oV_gt));           
            figure(3), clf
            subplot(211)
            thr1 = vsync(1)+z0; thr2 = vsync(2) +z0; thr3 = vsync(3) +z0;
            plot(utt,oV_gt,'-k',utt,thr1,'-b',utt,thr2,'-g',utt,thr3,'-r','LineWidth',1)
            ylabel('Order Parameter'), xlabel('Time [s]')
            legend('Velocity Order Parameter','Weak Sync','Medium Sync','High Sync','Delay')
            
            tts_h = VTTS_H(triad,trial); tts_m = VTTS_M(triad,trial);
            tts_w = VTTS_W(triad,trial); tis_h = VTIS_H(triad,trial);
            tis_m = VTIS_M(triad,trial); tis_w = VTIS_W(triad,trial);
            
            title(['OrderParameter, Triad / Trial: ', num2str([triad,trial])])%,, T2S_glob / TIS: ', num2str([tts_global,tis])])
            ttt = {['TTS_H: ', sprintf('%.3f  ', tts_h)],['TTS_M: ', sprintf('%.3f  ', tts_m)],...
                ['TTS_W: ', sprintf('%.3f  ', tts_w)],['TIS_H: ', sprintf('%.3f  ', tis_h)],...
                ['TIS_M: ', sprintf('%.3f  ', tis_m)],['TIS_W: ', sprintf('%.3f  ', tis_w)]};
            text(-4, 0.5, ttt, 'FontSize', 10, 'Color', 'k'); grid on
            
            subplot(212)
            thr1 = hsync(1)+z0; thr2 = hsync(2)+z0; thr3 = hsync(3)+z0;
            plot(utt,oH_gt,'-k',utt,thr1,'-b',utt,thr2,'-g',utt,thr3,'-r','LineWidth',1)
            ylabel('Order Parameter'), xlabel('Time [s]')
            legend('Heart Order Parameter','Weak Sync','Medium Sync','High Sync','Delay')
            
            tts_h = HTTS_H(triad,trial); tts_m = HTTS_M(triad,trial);
            tts_w = HTTS_W(triad,trial); tis_h = HTIS_H(triad,trial);
            tis_m = HTIS_M(triad,trial); tis_w = HTIS_W(triad,trial);
            
            % title(['triad / Trial: ', num2str([triad,trial])])%,, T2S_glob / TIS: ', num2str([tts_global,tis])])
            ttt = {['TTS_H: ', sprintf('%.3f  ', tts_h)],['TTS_M: ', sprintf('%.3f  ', tts_m)],...
                ['TTS_W: ', sprintf('%.3f  ', tts_w)],['TIS_H: ', sprintf('%.3f  ', tis_h)],...
                ['TIS_M: ', sprintf('%.3f  ', tis_m)],['TIS_W: ', sprintf('%.3f  ', tis_w)]};
            text(-4, 0.5, ttt, 'FontSize', 10, 'Color', 'k'); grid on            
        end
        'wait'
    end
    
    % ANOVAS
    close all
    
    % Compare WINNER gaze of this triad for E+, E0, E-
    emot_t = GAZEVELOCDISCRIM.EMOT(triad,:);
    d_t = GAZEVELOCDISCRIM.METRIC;
    pgaze = anova1(d_t,emot_t);
        
    % Compare the oV of E+, E0, E- and WinGaze also  
    vtis_W = VTIS_W(triad,:); vtis_M = VTIS_M(triad,:); vtis_H = VTIS_H(triad,:);
    pvel_W = anova1(vtis_W,emot_t); pvel_M = anova1(vtis_M,emot_t); pvel_H = anova1(vtis_H,emot_t);   
    GAZEVELOCDISCRIM.Vpvalues(triad,:) = [pgaze,pvel_W,pvel_M,pvel_H];
    
    % Compare the oV of E+, E0, E- and WinGaze also
    htis_W = HTIS_W(triad,:); htis_M = HTIS_M(triad,:); htis_H = HTIS_H(triad,:);
    pheart_W = anova1(htis_W,emot_t); pheart_M = anova1(htis_M,emot_t); pheart_H = anova1(htis_H,emot_t);   
    GAZEVELOCDISCRIM.Hpvalues(triad,:) = [pgaze,pheart_W,pheart_M,pheart_H];
    
    % BOX PLOTS = NTRIADS
    s_boxplot; % !! add p-values into boxplots
    
    for k = 1 : 3        
        GAZEVELOCDISCRIM.medianV_H(triad,k) = median(vtis_H(emot_t == k));
        GAZEVELOCDISCRIM.medianV_M(triad,k) = median(vtis_M(emot_t == k));
        GAZEVELOCDISCRIM.medianV_W(triad,k) = median(vtis_W(emot_t == k));        
        GAZEVELOCDISCRIM.medianH_H(triad,k) = median(htis_H(emot_t == k));
        GAZEVELOCDISCRIM.medianH_M(triad,k) = median(htis_M(emot_t == k));
        GAZEVELOCDISCRIM.medianH_W(triad,k) = median(htis_W(emot_t == k));
    end    
    'aa'
end

% SAVE things
M = GAZEVELOCDISCRIM.EMOT;
namef = 'EMOTTriadTrial.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.METRIC;
namef = 'GazeMetric.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.medianV_H; % GAZEVELOCDISCRIM.medianV_H(triad,k) = median(vtis_H(g_t == k));
namef = 'MediansTISVEL_H.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.medianV_M; % (triad,k) = median(vtis_M(g_t == k));
namef = 'MediansTISVEL_M.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.medianV_W; % (triad,k) = median(vtis_W(g_t == k));
namef = 'MediansTISVEL_W.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.medianH_H;
namef = 'MediansTISHEART_H.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.medianH_M; 
namef = 'MediansTISHEART_H.csv'; save(namef,'M','-ascii');
M = GAZEVELOCDISCRIM.medianH_W; 
namef = 'MediansTISHEART_H.csv'; save(namef,'M','-ascii');

namef = 'VOPAmedian.csv'; save(namef,'VOPAmedian','-ascii');
namef = 'VOPAstd.csv'; save(namef,'VOPAstd','-ascii');
namef = 'VTTS_W.csv'; save(namef,'VTTS_W','-ascii');
namef = 'VTIS_W.csv'; save(namef,'VTIS_W','-ascii');
namef = 'VTTS_M.csv'; save(namef,'VTTS_M','-ascii');
namef = 'VTIS_M.csv'; save(namef,'VTIS_M','-ascii');
namef = 'VTTS_H.csv'; save(namef,'VTTS_H','-ascii');
namef = 'VTIS_H.csv'; save(namef,'VTIS_H','-ascii');
    VSYNC(triad,:) = vsync;
    HSYNC(triad,:) = hsync;

% HEART characteristics
namef = 'HOPAmedian.csv'; save(namef,'HOPAmedian','-ascii');
namef = 'HOPAstd.csv'; save(namef,'HOPAstd','-ascii');
namef = 'HTTS_W.csv'; save(namef,'HTTS_W','-ascii');
namef = 'HTIS_W.csv'; save(namef,'HTIS_W','-ascii');
namef = 'HTTS_M.csv'; save(namef,'HTTS_M','-ascii');
namef = 'HTIS_M.csv'; save(namef,'HTIS_M','-ascii');
namef = 'HTTS_H.csv'; save(namef,'HTTS_H','-ascii');
namef = 'HTIS_H.csv'; save(namef,'HTIS_H','-ascii');
HSYNC(triad,:) = hsync;


GAZEVELOCDISCRIM
close all
figure(1)
subplot(311)
plot(GAZEVELOCDISCRIM.medianV_W,'LineWidth',1)
title('TimeInSync Weak Sync'), xlabel('Triad'), ylabel('Median TIS')
legend('E-','E0','E+')
subplot(312)
plot(GAZEVELOCDISCRIM.medianV_M,'LineWidth',1)
title('TimeInSync Median Sync'), xlabel('Triad'), ylabel('Median TIS')
legend('E-','E0','E+')
subplot(313)
plot(GAZEVELOCDISCRIM.medianV_H,'LineWidth',1)
title('TimeInSync High Sync'), xlabel('Triad'), ylabel('Median TIS')
legend('E-','E0','E+')
