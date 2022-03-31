function [fn,gam,qn,newLandmarks] = multipleSoftAlignment(t,f,lambda,lm,min_ind1,dispFig)
%
% Args:
%   t: time domain vector;
%   f: NxT; N is number of functions and T is number of points for each function
%   lambda: tuning parameter
%   lm: Nxn; each function has n landmarks;


if size(f,1) > size(f,2)
  f = f';
end

f0 = f;
[N,T] = size(f);
q0 = zeros(N,T);
for i = 1:N
    q0(i,:) = f2q(f(i,:));
end
q = q0;

%% Initialization
mnq = mean(q0,1);
dqq = sqrt(sum((q0 - ones(N,1)*mnq).^2,2));
[~, min_ind] = min(dqq);
mq{1} = q0(min_ind,:);
fprintf('initializing with index %d\n',min_ind);

%% Compute Mean
fprintf('computing Karcher mean of %d functions in SRVF space...\n',N);
ds = inf;
MaxItr = 20;

for r = 1:MaxItr
    fprintf('updating step: r=%d \n', r);
    if r == MaxItr
        fprintf('maximal number of iterations is reached. \n');
    end
    mq_c = mq{r};
    %%%% Matching Step %%%%
    clear gam gam_dev;
    % use DP to find the optimal warping for each function w.r.t. the mean
    for k = 1:N
        q_c = q0(k,:);
        gam0 = DynamicProgrammingSoft(q_c,mq_c,lambda,0);
%        gam0 = DynamicProgrammingSoftMiddleNeighbor(q_c,mq_c,lambda1,0);
%        gam0 = DynamicProgrammingSoftBigNeighbor(q_c,mq_c,lambda1,0);
        gam(k,:) = (gam0-gam0(1))/(gam0(end)-gam0(1));  % slight change on scale
        gam_dev(k,:) = gradient(gam(k,:), 1/(T-1));
        f(k,:) = interp1(t, f0(k,:), (t(end)-t(1)).*gam(k,:) + t(1));
        q(k,:) = f2q(f(k,:));
    end

    ds(r+1) = sum(trapz(t, ((ones(N,1)*mq{r}-q).^2)'))+lambda*sum(trapz(t, (1-sqrt(gam_dev')).^2));

    %%%% Minimization Step %%%%
    % compute the mean of the matched function
    mq{r+1} = mean(q,1);

    if (ds(r) < ds(r+1) || norm(mq{r+1}-mq{r})/norm(mq{r}) < 1e-2)
        break;
    end
end

% %% Centering
% center = 1;
% if ~isempty(center)
%     fprintf('Centering...\n');
%     for k = 1:N
%         q_c = q0(k,:); mq_c = mq{r+1};
%         gam0 = DynamicProgrammingSoft(q_c/norm(q_c),mq_c/norm(mq_c),0,0);
%         gam(k,:) = (gam0-gam0(1))/(gam0(end)-gam0(1));  % slight change on scale
%         gam_dev(k,:) = gradient(gam(k,:), 1/(T-1));
%     end
%     gamI = SqrtMeanInverse(gam);
%     gamI_dev = gradient(gamI, 1/(T-1));
%     for k = 1:N
%         q(k,:) = interp1(t, q(k,:), (t(end)-t(1)).*gamI + t(1))'.*sqrt(gamI_dev');
%         f(k,:) = interp1(t, f(k,:), (t(end)-t(1)).*gamI + t(1))';
%         gam(k,:) = interp1(t, gam(k,:), (t(end)-t(1)).*gamI + t(1));
%     end
% end

%% Result
fn = f;
qn = q;

% find warped landmarks
newLandmarks=[];
if ~isempty(lm)
    if ~isempty(min_ind1)
        newLandmarks = zeros(size(lm));
        for i=1:size(lm,1)
            for j = 1:size(lm,2)
                temp = lm(:,j);
                [~,newLandmarks(i,j)] = min(abs(gam(i,:)-temp(min_ind1)/length(t)));
            end
        end
    else
        newLandmarks = zeros(size(lm));
        for i=1:size(lm,1)
            for j = 1:size(lm,2)
                [~,newLandmarks(i,j)] = min(abs(gam(i,:)-lm(i,j)/length(t)));
            end
        end

    end
end

if ~isempty(dispFig)
    figure;
    plot(t, f0, 'linewidth', 2);
    set(gca,'FontSize',20)
    title('Input Data', 'fontsize', 16);

    figure;
    plot(linspace(0,1,T), gam, 'linewidth', 2);
    set(gca,'FontSize',20)
    axis square;
    title(['Time Warping, \lambda = ', num2str(lambda)], 'fontsize', 16);

    figure;
    plot(t, fn, 'LineWidth',2);
    set(gca,'FontSize',20)
    title(['Soft Aligned Data, \lambda = ', num2str(lambda)], 'fontsize', 16);
    for i = 1:size(lm,1)
        for j =1: size(lm,2)
            hold on
            plot(t(newLandmarks(i,j)),fn(i,newLandmarks(i,j)),'ko','LineWidth',5)
        end
    end

end
