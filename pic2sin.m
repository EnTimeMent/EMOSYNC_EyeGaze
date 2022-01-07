% pic2sin : 

clear all, close all

D = load('Heart_Oscil.csv','-ascii');

GLOBAL_;
[n,d] = size(D)

ind = 1 : 100;
t = D(ind,1); p = D(ind,2);

TRIAD = D(:,3);
CONDITION = D(:,4);
TRIAL = D(:,5);
PART =  D(:,6);

triad = 2;
condition = 1;
trial = 2;

Itriad = TRIAD == triad;
Icond = CONDITION == condition;
Itrial = TRIAL == trial;

Igroup = and(and(Itriad,Icond),Itrial);

P1 = and(Igroup,PART == 1);
P2 = and(Igroup,PART == 2);
P3 = and(Igroup,PART == 3);

tp1 = D(P1,1:2); tp1(:,1) = round(ViconFrequency * tp1(:,1));
tp2 = D(P2,1:2); tp2(:,1) = round(ViconFrequency * tp2(:,1));
tp3 = D(P3,1:2); tp3(:,1) = round(ViconFrequency * tp3(:,1));

m1 = max(tp1(:,1)); m2 = max(tp2(:,1)); m3 = max(tp3(:,1));
tmax = max([m1,m2,m3]); % useless
tabs =  ViconFrequency * linspace(0,ViconDuration,ViconDuration * ViconFrequency)';

[T1,P1] = f_Pic2Sin(tp1(:,1),tp1(:,2),tabs);
[T2,P2] = f_Pic2Sin(tp2(:,1),tp2(:,2),tabs);
[T3,P3] = f_Pic2Sin(tp3(:,1),tp3(:,2),tabs);

% figure(2)
% plot(tp1(:,1),tp1(:,2),':ok',T,P,'-r')
iax = 1:100;
figure(1), hold on
tp = tp1; plot(tp(:,1),tp(:,2),':ok',T1,P1,'-k')
tp = tp2; plot(tp(:,1),tp(:,2),':ob',T2,P2,'-b')
tp = tp3; plot(tp(:,1),tp(:,2),':or',T3,P3,'-r')
axis([0,3000, -1.01, 1.01])
hold off
'wait'