function [T,P] = f_Pic2Sin(t,p,tabs)

% Transform a suite of "peaks" (t(k),p(k)) with p(k+1) = -p(k), k = 1, ...
% into a "sinusoidal" curve attaining the +/- 1 values at the same points
% [T(1),P(1)] = [0,0] by defalut

T = tabs; LT = length(T);
P = zeros(LT,1);

N = length(t);

T1 = T(1); P1 = P(1);
for k = 1 : N
    
    % Find the interval    
    T2 = t(k); P2 = p(k);    
    
    I12 = and(T >= T1,T <= T2);
    % Find the interpolating points
    t12 = T(I12); 
    t12(1) = T1; t12(end) = T2;
    
    % Toward sinusoid
    L12 = T2 - T1;
    a = pi / L12; b = 0.5 * pi - T2 * a;
    if T1 == 0, a = 0.5 * pi / T2; b = 0; end
    x12 = a * t12 + b;
    z = max(x12);
    p12 = sin(x12);
    
    if P2 == -1, p12 = -p12; end
    
    P(I12) = p12;
    
%     figure(4), clf, hold on
%     plot([T1,T2],[P1,P2],'-k',t12,p12,'-r')
%     
%     'wait'
    
    
    % Update point
    T1 = T2; P1 = P2;
end


