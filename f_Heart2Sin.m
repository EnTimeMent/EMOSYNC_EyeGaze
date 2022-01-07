function [T1,sinH,phaseH] = f_Heart2Sin(t,p,UT)

% Find the sin oscillation of velocity V after filtering V and bringing
% its inflexion points to 0 (this is part 1 of f_CHRONOS_2 data)
% use findpeaks function
% The phase calculation is done on sin oscillation

GLOBAL_;
T1 = UT;


% Fit sin between -1/+1 peaks
[~,sinH] = f_Pic2Sin(t,p,UT);

% Calculate the phase of sinV
phaseH = co_hilbproto(sinH);
[phaseH,~,~] = co_fbtrT(phaseH);  %in [0,2*pi[

% figure(4)
% subplot(211)
% plot(UT,sinH,'-r',t,p,'*b')
% title('Bring Heart Peaks to a sin-like signal')
% xlabel('Time')
% subplot(212)
% plot(UT,phaseH,'-k')
% title('Phase of sinH')
% xlabel('Time')



% 
% Parameters.Visu = true;
% if Parameters.Visu
%     Parameters.nofig = 1; %Parameters.nofig + 1;
%     figure(Parameters.nofig), clf
%     ICOL = 1 : T;
%     subplot(311)
%     plot(UT,filtV,'-k',Tl,Xl,'or',UT,XL,'-b')
%     legend('xfilt','Inflexions','Interpol')
%     title('Bring Signal Arround 0'), grid on
%     subplot(312)
%     plot(UT,filtV0,'-k',tmax,pmax,'*b')
%     subplot(313)
%     plot(UT,sinH,'-k',tpeak,peak,'*b',UT,phaseH,'-r')
%     'wait'
% end
% 
% 
% % Calculate PHASES
% XPHASES = filtV0;
% 
% disp(n)
% phaseH = co_hilbproto(filtV0(:,n));
% [phases,~,~] = co_fbtrT(phaseH);  %in [0,2*pi[
% XPHASES(:,n) = phases;
% 
% if Parameters.Visu
%     Parameters.nofig = 1; %Parameters.nofig + 1;
%     figure(Parameters.nofig), clf
%     ICOL = 1 : T; 500;
%     subplot(211)
%     plot(UT(ICOL),X(ICOL,n),'-k',UT(ICOL),filtV0(ICOL,n),'-r'), legend('x','xfilt0')
%     title('Positions'), grid on
%     
%     subplot(212)
%     plot(UT(ICOL),phaseH(ICOL),'-k',UT(ICOL),phases(ICOL),'-r'), legend('protoPH','PH')
%     title('Phases'), grid on
%     'wait'
% end
