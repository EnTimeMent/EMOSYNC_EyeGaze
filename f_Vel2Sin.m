function [T1,filtV,filtV0,sinV,phaseV] = f_Vel2Sin(V,UT)

% Find the sin oscillation of velocity V after filtering V and bringing
% its inflexion points to 0
% use findpeaks function
% The phase calculation is done on sin oscillation

GLOBAL_;
T1 = UT; [T,~] = size(V);

% Filtering_and_Cutting
filtV = V ;  % filtered data
filtV0 = V;  % filtV brought arround 0
DT = UT(2) - UT(1); % miliseconds
FREQ = ViconFrequency; % FREQ = round(1 / DT); %FREQ = 57;
CUTOFFFREQ = 1; %the maximum frequency of players in group is 6.45 rad/s <-> 1.03Hz
[b,a] = butter(2, 2 * CUTOFFFREQ / FREQ, 'low'); %filter

filtV = filtfilt(b,a,V); %FiltPos = filtfilt(b,a,InterpPos');
% Bring filtV arround 0
% Find inflexion points into filtV
% Find linear interpolation of this points LIn
% filtV0 = filtV - XL;
xx2 = gradient(gradient(filtV));
mx2 = max(abs(xx2)); IIL = abs(xx2) < 0.01 * mx2;
Xl = [filtV(1);filtV(IIL);filtV(end)];
Tl = [UT(1);UT(IIL);UT(end)];
[Tl,IATl] = unique(Tl);
Xl = Xl(IATl);
XL = interp1(Tl,Xl,UT,'linear');
z = any(isnan(XL));
filtV0 = filtV - XL;

m0 = max(abs(filtV0));
minph = 0.03 * m0;
minpd = 20;

% Find peaks max and peaks min in filtV0
[pmax, tmax] = findpeaks( filtV0,UT, 'MinPeakHeight', minph, 'MinPeakDistance', minpd);
% [pmin, lmin] = findpeaks(-filtV0,UT, 'MinPeakHeight', 0.1, 'MinPeakDistance', 0.6);

% Put pmax to 1 and intercaler pmin = -1 in the middle of 2 pmax
tmin = 0.5 * (tmax(1 : end-1) + tmax(2 : end));
pmax1 = ones(size(pmax)); pmin1 = -ones(size(tmin));
peak = [pmax1;pmin1]; tpeak = [tmax;tmin];
[tpeak,itpeak] = sort(tpeak);
peak = peak(itpeak);

% Fit sin between -1/+1 peaks
[~,sinV] = f_Pic2Sin(tpeak,peak,UT);

% Calculate the phase of sinV
phaseV = co_hilbproto(sinV);
[phaseV,~,~] = co_fbtrT(phaseV);  %in [0,2*pi[

% Parameters.Visu = false; true;
% if Parameters.Visu
%     Parameters.nofig = 1; %Parameters.nofig + 1;
%     figure(Parameters.nofig), clf
%     ICOL = 1 : T;
%     subplot(411)
%     plot(UT,filtV,'-k',Tl,Xl,'or',UT,XL,'-b')
%     legend('filtV','Inflexions','Interpol')
%     title('Velocity Processing'), grid on
%     subplot(412)
%     plot(UT,filtV0,'-k',tmax,pmax,'*b')
%     title('filtV0: bring V around 0 and find peaks'),
%     subplot(413)
%     plot(UT,sinV,'-k',tpeak,peak,'*b')%,UT,phaseV,'-r')
%     title('sin like oscillations of filtV0'),
%     subplot(414)
%     plot(UT,phaseV,'-r')
%     title('Phases of sinV'), xlabel('Time')
%     'wait'
% end