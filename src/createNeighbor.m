% create neighbors for dynamic programming;

n=[1 1];

for i=2:100
    temp=int16.empty(0,2);
    for j=1:i-1
        temp=[temp;[j i]];
    end
    n=[n;temp];
    n=[n;[temp(:,2) sort(temp(:,1),'descend')]];
end

for i=1:9901
    disp(['{' num2str(n(i,1)) ',' num2str(n(i,2)) '},'])
end
