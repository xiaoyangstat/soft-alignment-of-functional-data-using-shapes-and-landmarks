function [f1p,f2p,gam1,gam2]=pairwiseHardRegistration(f1,f2,lm1,lm2,centering)
% the function is a hard registration for warping f2 to align with f1. The
% idea is first divide f1 and f2 by their landmarks. And using SRVF
% alignment for each segements. Finally concatenate segements of f2, which
% is f2p.

T = length(f1);
t=linspace(0,1,T);

for i=1:length(lm1)
    if i==1
        f1seg{i}=f1(1:lm1(i));
        f2seg{i}=interp1(linspace(0,1,lm2(i)),f2(1:lm2(i)),linspace(0,1,lm1(i)),'spline');
        [f2pseg{i},gampseg{i}]=pairwiseSRVFAlignment(f1seg{i},f2seg{i});
    else
        f1seg{i}=f1(lm1(i-1):lm1(i));
        f2seg{i}=interp1(linspace(0,1,lm2(i)-lm2(i-1)+1),f2(lm2(i-1):lm2(i)),linspace(0,1,lm1(i)-lm1(i-1)+1),'spline');
        [f2pseg{i},gampseg{i}]=pairwiseSRVFAlignment(f1seg{i},f2seg{i});
    end
end

f1seg{end+1}=f1(lm1(end):end);
f2seg{end+1}=interp1(linspace(0,1,length(f2)-lm2(end)+1),f2(lm2(end):end),linspace(0,1,length(f1)-lm1(end)+1),'spline');
[f2pseg{end+1},gampseg{end+1}]=pairwiseSRVFAlignment(f1seg{end},f2seg{end});

f2p=[];gamp=[];
lm2=[lm2 length(t)];
for i=1:length(lm1)+1
    if i==1
        f2p=[f2p f2pseg{1}];
        gamp=[gamp gampseg{1}*t(lm2(i))];
    else
        f2p=[f2p f2pseg{i}(2:end)];
        gamp=[gamp gampseg{i}(2:end)*(t(lm2(i))-t(lm2(i-1)))+t(lm2(i-1))];
    end
end
f1p = f1;gam1 = linspace(0,1,T);gam2 = gamp;

if nargin > 4 %centering
    gam = [gam1; gamp];
    gamI = SqrtMeanInverse(gam);
    f1p = interp1(t, f1, gamI);   
    f2p = interp1(t, f2p, gamI); 
    gam1 = interp1(t, gam1, gamI);
    gam2 = interp1(t, gamp, gamI);
end

