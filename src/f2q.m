function q=f2q(f,t)
% convert scalar function f to SRVF q
%
% Args:
%   f: 1 x T; scalar function
%   t: 1 x T; time points of the function

if nargin<2
    T = length(f);
    binsize = 1/(T-1);
else
    binsize=mean(diff(t));
end

q = sign(gradient(f, binsize)).*sqrt(abs(gradient(f, binsize)));
