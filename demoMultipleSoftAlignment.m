clear;close all;
addpath('./src/');

%% Example 1: good landmarks
load('./data/simu_five_functions_good_lm.mat');

figure
plot(t,f,'LineWidth',2)
for i=1:size(lm,1)
    for j=1:size(lm,2)
        hold on
        plot(t(lm(i,j)),f(i, lm(i,j)),'go','LineWidth',4)
    end
end
title('Original Functions')
set(gca,'fontsize', 14);

% LOOCV
lam = linspace(0,400,10);
lam = fliplr(lam);

E = selectLambda(t,f,lm,lam,[]);
[~, idx] = min(E);
best_lam = lam(idx);

figure
plot(lam,E,'*-','LineWidth',2)
set(gca,'fontsize', 14);
xlabel('\lambda','FontSize',14)
title('LOOCV')

% Soft Alignment
[fp,gamp,hard_id]=multipleHardRegistration(t,f,lm,[]);

figure
subplot(1,2,1);
plot(t,fp,'LineWidth',2)
for i=1:size(lm,1)
    for j=1:size(lm,2)
        hold on
        plot(t(lm(hard_id,j)),fp(i,lm(hard_id,j)),'go','LineWidth',4)
    end
end
set(gca,'fontsize', 14);
subplot(1,2,2);
plot(t,gamp,'LineWidth',2)
set(gca,'fontsize', 14);
sgtitle ('Hard Registration')

[fn,gam,qn,nlm] = multipleSoftAlignment(t,fp,best_lam,lm,hard_id,[]);

figure
subplot(1,2,1);
plot(t,fn,'LineWidth',2)
for i=1:size(lm,1)
    for j=1:size(lm,2)
        hold on
        plot(t(nlm(i,j)),fn(i,nlm(i,j)),'go','LineWidth',4)
    end
end
set(gca,'fontsize', 14);
subplot(1,2,2);
plot(t,gam,'LineWidth',2)
set(gca,'fontsize', 14);
sgtitle ('Soft Alignment')


%% Example 2: bad landmarks
load('./data/simu_five_functions_bad_lm.mat');

figure
plot(t,f,'LineWidth',2)
for i=1:size(lm,1)
    for j=1:size(lm,2)
        hold on
        plot(t(lm(i,j)),f(i, lm(i,j)),'go','LineWidth',4)
    end
end
title('Original Functions')
set(gca,'fontsize', 14);

% LOOCV
lam = linspace(0,5000,10);
lam = fliplr(lam);

E = selectLambda(t,f,lm,lam,[]);
[~, idx] = min(E);
best_lam = lam(idx);

figure
plot(lam,E,'*-','LineWidth',2)
set(gca,'fontsize', 14);
xlabel('\lambda','FontSize',14)
title('LOOCV')

% Soft Alignment
[fp,gamp,hard_id]=multipleHardRegistration(t,f,lm,[]);

figure
subplot(1,2,1);
plot(t,fp,'LineWidth',2)
for i=1:size(lm,1)
    for j=1:size(lm,2)
        hold on
        plot(t(lm(hard_id,j)),fp(i,lm(hard_id,j)),'go','LineWidth',4)
    end
end
set(gca,'fontsize', 14);
subplot(1,2,2);
plot(t,gamp,'LineWidth',2)
set(gca,'fontsize', 14);
sgtitle ('Hard Registration')

[fn,gam,qn,nlm] = multipleSoftAlignment(t,fp,best_lam,lm,hard_id,[]);

figure
subplot(1,2,1);
plot(t,fn,'LineWidth',2)
for i=1:size(lm,1)
    for j=1:size(lm,2)
        hold on
        plot(t(nlm(i,j)),fn(i,nlm(i,j)),'go','LineWidth',4)
    end
end
set(gca,'fontsize', 14);
subplot(1,2,2);
plot(t,gam,'LineWidth',2)
set(gca,'fontsize', 14);
sgtitle ('Soft Alignment')
