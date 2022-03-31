function [fp,gamp,min_ind]=multipleHardRegistration(t,f,lm,dispFig)
% Pre-align multiple functions by hard registration;
%
% Args:
%   t: 1 x T; time domain of f
%   f: N x T; N input functions;
%   lm: N x n; each function has n landmarks;
%
% Returns:
%   fp (aligned f)
%   gamp (time warping function for f).

if size(f,1) > size(f,2)
  f = f';
end

%% Initilization
q = zeros(size(f)); N = size(f,1);
for i = 1:N
    q(i,:) = f2q(f(i,:),t);
end

% choice 1: pick one minimize the variance
% mnq = mean(q,2);
% dqq = sqrt(sum((q - mnq*ones(1,N)).^2,1));
% [~, min_ind] = min(dqq);

% choice 2: pick one s.t. landmark is in the middle
mnq = mean(lm,1);
dqq = sqrt(sum((lm-ones(N,1)*mnq).^2,2));
[~, min_ind] = min(dqq);

%min_ind=x %change x into any integer from 1 to N as the template

%% Hard register all the functions to the template
fp = zeros(size(f)); gamp = zeros(size(f));
for i=1:N
    if i == min_ind
        fp(i,:) = f(i,:);
        gamp(i,:) = linspace(0,1,size(f,2));
    else
        [~,ftemp,~,gamp(i,:)]=pairwiseHardRegistration(f(min_ind,:),f(i,:),lm(min_ind,:),lm(i,:));
        fp(i,:) = interp1(linspace(0,1,length(ftemp)),ftemp,linspace(0,1,length(t)));
        clear ftemp
    end
end
gamp=t(1)+gamp*(t(end)-t(1));

if ~isempty(dispFig)
    figure;
    plot(t, f, 'linewidth', 2);
    set(gca,'FontSize',20)
    title('Raw Data', 'fontsize', 16);
    for i = 1:size(lm,1)
        for j =1: size(lm,2)
            hold on
            plot(t(lm(i,j)),f(i,lm(i,j)),'go','LineWidth',5)
        end
    end

    figure;
    plot(t, gamp, 'linewidth', 2);
    set(gca,'FontSize',20)
    axis square;
    title('Time Warping Functions', 'fontsize', 16);

    figure;
    plot(t, fp, 'LineWidth',2);
    set(gca,'FontSize',20)
    title('Hard Registration', 'fontsize', 16);
    for i = 1:size(lm,1)
        for j =1:size(lm,2)
            hold on
            plot(t(lm(min_ind,j)),fp(i,lm(j,min_ind)),'go','LineWidth',5)
        end
    end
end
