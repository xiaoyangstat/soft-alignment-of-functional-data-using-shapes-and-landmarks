function [f2a,gam]=pairwiseSRVFAlignment(f1,f2)
% warping f2 to align with f1 in SRVF

t=linspace(0,1,length(f1));

interpFlag=0;
T = 51;
if length(t)<T
    fprintf('interplation for sparse functions with length = %d \n',length(f1));
    t1 = linspace(0,1,T);
    f1 = interp1(t,f1,t1,'spline');
    f2 = interp1(t,f2,t1,'spline');
    t0 = t;
    t = t1;
    interpFlag = 1;
end
    
q1 = f2q(f1,t); q2 = f2q(f2,t);
gam0=DynamicProgrammingSoft(q2,q1,0,0);
gam = (gam0-gam0(1))/(gam0(end)-gam0(1));
f2a = interp1(t, f2, gam);

if interpFlag
    gam = interp1(t,gam,t0,'spline');
    f2a = interp1(t,f2a,t0,'spline');
end