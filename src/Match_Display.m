function Match_Display(q1,q2)


shfx = 0.3;
shfy = 0.3;
shfz = 0.3;
NumPlot =20;
[n,T] = size(q1);
i = [1:NumPlot]*floor(T/NumPlot);

figure; 
p1 = q_to_curve(q1);
p2 = q_to_curve(q2);

if(n == 2)
    z = plot( p1(1,:),  p1(2,:),'b');
    hold on; axis equal;
    % axis off;
    set(z,'LineWidth',[2]);
    p2new = [shfx + p2(1,:),;shfy + p2(2,:)];
    z = plot(shfx + p2(1,:), shfy + p2(2,:),'b');
    % z = plot(shfx + p1(1,ii), shfy + p1(2,ii),'b+');
    set(z,'LineWidth',[3]);

    idx = floor(linspace(1,T,NumPlot));
    for k=1:length(idx)
        line([p2new(1,idx(k)),p1(1,idx(k))],[p2new(2,idx(k)),p1(2,idx(k))],'Color','r','LineWidth',1.5);
    end
%     for k = 1:length(idx)
%         text(p2new(1,idx(k)),p2new(2,idx(k)),char(65 + (k)));
%         text(p1(1,idx(k)),p1(2,idx(k)),char(65 + (k)));
%     end
%     print(gcf,'-depsc2', 'match.eps');
end

if(n == 3)
    z = plot3( p1(1,:),  p1(2,:),p1(3,:),'b');
    hold on;
    % axis off;
    set(z,'LineWidth',[2]);
    p2new = [shfx + p2(1,:),;shfy + p2(2,:);shfz + p2(3,:)];
    z = plot3(shfx + p2(1,:), shfy + p2(2,:),shfz + p2(3,:),'b');
    % z = plot(shfx + p1(1,ii), shfy + p1(2,ii),'b+');
    set(z,'LineWidth',[3]);

    idx = floor(linspace(1,T,NumPlot));
    for k=1:length(idx)
        line([p2new(1,idx(k)),p1(1,idx(k))],[p2new(2,idx(k)),p1(2,idx(k))],[p2new(3,idx(k)),p1(3,idx(k))],'Color','r','LineWidth',2);
    end
%     for i = 1:length(idx)
%         text(p2new(1,idx(k)),p2new(2,idx(k)),p2new(3,idx(k)),num2str(idx(k)));
%         text(p1(1,idx(k)),p1(2,idx(k)),p1(3,idx(k)),num2str(idx(k)));
%     end
end
axis equal; 
axis off;
axis ij;
return

