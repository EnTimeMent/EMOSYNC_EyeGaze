function [orderParamTime, orderParam, timephase, isi] = f_OrderParameter(groupphases)

% Author: Carmela Calabrese
% Input:
% GROUP phases (GROUPSIZE x TIMESPAN) matrix for each trial
% - phases with dimension equal to number of players(rows) x time_instants(columns)
% Output:
% - orderParamTime: degree of phase synchronization in time
% - orderParam: average degree of phase synchronization
% - q : phase in time of the phase synchronization index

[N, Nt] = size(groupphases); %,1); Nt=size(groupphases,2);
timephase = zeros(1,Nt);
orderParamTime = zeros(1,Nt);
orderParam = 0;

for j = 1 : Nt
    for k = 1 : N
        timephase(j) = timephase(j) + exp(1i*groupphases(k,j));
    end
    timephase(j) = timephase(j)/N; % this is q'(t) formula (1) p7
    orderParamTime(j) = abs(timephase(j));
%     orderParam = orderParam + orderParamTime(j);
    timephase(j) = atan2(imag(timephase(j)),real(timephase(j))); % this is q(t) WHAT is the role of this HERE
end
orderParam = mean(orderParamTime); %orderParam / Nt;

% Calculate ISI individual synchronization index
isi = zeros(N,1);
for k = 1 : N
    phik = groupphases(k,:) - timephase;
    phi1k = mean(exp(1i*phik));
    isi(k) = abs(phi1k);
end
end