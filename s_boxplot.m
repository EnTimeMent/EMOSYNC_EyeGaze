% s_boxplots for GROUP_GAZ_VEL_HEAET_2.m
% clear all, close all
% EMOT = load('EMOTTriadTrial.csv');
% GAZE = load('GazeMetric.csv');
%
% VTIS_W = load('VTIS_W.csv');
% VTIS_M = load('VTIS_M.csv');
% VTIS_H = load('VTIS_H.csv');
%
% HTIS_W = load('HTIS_W.csv');
% HTIS_M = load('HTIS_M.csv');
% HTIS_H = load('HTIS_H.csv');
%
% [TRD,TRL] = size(EMOT);
%
% for triad = 1 : TRD
%     emot_t = EMOT(triad,:);
semot = char(TRL,3); cemot = cell(TRL,1);
for k = 1 : TRL
    if emot_t(k) == 1, cemot{k} = 'E-'; end
    if emot_t(k) == 2, cemot{k} = 'E0'; end
    if emot_t(k) == 3, cemot{k} = 'E+'; end
end
semot = char(cemot);

figure(triad), clf
subplot(2,3,1)
x = VTIS_W(triad,:); boxplot(x,semot)
title(['Triad: ',num2str(triad),', VELOCITY Weak Level']), ylabel('TIS OPMT') % xlabel('Emot'),
subplot(2,3,2)
x = VTIS_M(triad,:); boxplot(x,semot)
title(['Triad: ',num2str(triad),', VELOCITY Medium Level']), ylabel('TIS OPMT') %xlabel('Emot'),
subplot(2,3,3)
x = VTIS_H(triad,:); boxplot(x,semot)
title(['Triad: ',num2str(triad),', VELOCITY High Level']), ylabel('TIS OPMT')%  xlabel('Emot'),

subplot(2,3,4)
x = HTIS_W(triad,:); boxplot(x,semot)
title(['Triad: ',num2str(triad),', HEART Weak Level']), xlabel('Emot'), ylabel('TIS OPMT'), xlabel('Emot'),
subplot(2,3,5)
x = HTIS_M(triad,:); boxplot(x,semot)
title(['Triad: ',num2str(triad),', HEART Medium Level']), ylabel('TIS OPMT'), xlabel('Emot'),
subplot(2,3,6)
x = HTIS_H(triad,:); boxplot(x,semot)
title(['Triad: ',num2str(triad),', HEART High Level']), ylabel('TIS OPMT'), xlabel('Emot'),

% end