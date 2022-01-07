function [vsync,hsync] = t_DefineSyncLevels(oV0,oH0,p)

% Calculate cdf of each opmt
[fv,xv] = f_PdfCdf(oV0,100,0, 1, 'cdf');
[fh,xh] = f_PdfCdf(oH0,100,0, 1, 'cdf');

plot(xv,fv,'-b',xh,fh,'-y')
vsync = zeros(1,3);
hsync = zeros(1,3);
f = (1:3) * p;

for k = 1 : 3
    [~,ik] = min(abs(fv - f(k)));
    vsync(k) = xv(ik);
    [~,ik] = min(abs(fh - f(k)));
    hsync(k) = xh(ik);
end    