clear;close all;
addpath('./src/');

%% Simulate two functions
T=1001;
t=linspace(0,1,T);
binsize = mean(diff(t));

% one and six peaks
sigma=0.015;
f2=2*normpdf(t,0.20,sigma);
f1=2*normpdf(t,0.20,sigma)+1.6*normpdf(t,0.35,sigma)+1.4*normpdf(t,0.45,sigma)+1.2*normpdf(t,0.55,sigma)+1*normpdf(t,0.65,sigma);

figure
plot(t,f1,'r','LineWidth',2)
hold on
plot(t,f2,'b-.','LineWidth',2)
set(gca,'fontsize',20)
legend('f_1','f_2')
title('Original Functions')


[~,temp]=findpeaks(f1);
lm1=temp(end);
[~,temp]=findpeaks(f2);
lm2=temp(end);

%% Pe-alignment: hard registration
[f1p,f2p,gam1,gam2] = pairwiseHardRegistration(f1,f2,lm1,lm2);

figure
plot(t,f1p,'r','LineWidth',2)
hold on
plot(t,f2p,'b-.','LineWidth',2)
hold on
plot(t(lm1),f2p(lm1),'go','LineWidth',2)
hold on
plot(t(lm1),f1p(lm1),'go','LineWidth',2)
ylim([0 inf])
set(gca,'fontsize',20)
legend('f_1','f_2 \circ \gamma_p')
title('Hard Registration')

figure
plot(t, gam1, 'linewidth', 2);
hold on
plot(t, gam2, 'linewidth', 2);
hold on
plot(t(410),gam1(410),'go','LineWidth',2)
hold on
plot(t(410),gam2(410),'go','LineWidth',2)
set(gca,'FontSize',20)
axis equal;
title('Hard Registration')

%% Soft alignment
q1 = f2q(f1p);
q2 = f2q(f2p);

% Try different values for different peaks
lambdas = [0 120 160 500 1500];

for i = 1:length(lambdas)
    lambda = lambdas(i);

    gam0=DynamicProgrammingSoft(q2,q1,lambda,0);
    gam = (gam0-gam0(1))/(gam0(end)-gam0(1));

    f2a = interp1(t, f2p, gam);

    [~,newlm] = min(abs((gam - lm1/T)));

    figure
    subplot(1,2,1);
    plot(t,f1p,'r',t,f2a,'b-.',t(lm1),f1p(lm1),'go',t(newlm),f2a(newlm),'go','LineWidth',2)
    set(gca,'fontsize',20)
    legend('f_1','f_2 \circ \gamma_p \circ \gamma')
    ylim([0 inf])
    title(sprintf('$\\lambda=%d$',lambda),'Interpreter','latex')

    subplot(1,2,2);
    plot(t,gam,t(newlm),gam(newlm),'go','LineWidth',2);
    set(gca,'fontsize',20)
    title(sprintf('$\\lambda=%d$',lambda),'Interpreter','latex')
end
