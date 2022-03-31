function E = selectLambda(t,f,lm,lam,disp)
% LOOCV
%
% Args:
%   t: time domain of f
%   f: N x T; N input functions with T points each;
%   lm: N x n; each function has n landmarks;
%   lam: tuning parameter
% Returns:
%   E:

E = zeros(1,length(lam));

for i = 1:length(lam)
    fprintf('iteration %d/%d...\n', i, length(lam));
    for j = 1:size(f,1)
        fj = f; fj(j,:)=[];
        lmj = lm; lmj(j,:)=[];
%         if lam(i)~=0
%             [fp,~]=multipleHardRegistration(t,fj,lmj,[]);
%         else
%             fp=fj;
%         end
        [fp,~] = multipleHardRegistration(t,fj,lmj,[]);
        [fn,gam,qn] = multipleSoftAlignment(t,fp,lam(i),[],[],[]);
        muq = mean(qn,1); muf = mean(fn,1);

        if ~isempty(disp)
            if j<=9
                figure(i+1)
                subplot(3,3,j)
                plot(t,gam)
                axis square
                title(['\lambda = ', num2str(lam(i))]);
            end
        end

        qj = f2q(f(j,:));

        if ~isempty(disp)
            if j<=9
                figure(i+200)
                subplot(9,1,j)
                plot(t,muf,'r')
                hold on
                plot(t,f(j,:),'b-.')
                title(['\lambda = ', num2str(lam(i))]);
                legend('muf','f_j')
            end
        end

        gam = DynamicProgrammingSoft(qj,muq,0,0);
        gam = (gam-gam(1))/(gam(end)-gam(1));

        qj=f2q(interp1(t,f(j,:),gam));

        E(i) =  E(i) + norm(muq-qj,'fro');

    end
end
