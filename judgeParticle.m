function score = judgeParticle(M,Psrc)
%1、根据当前参数矩阵重建6组点云
    M88 = M{1};
    M89 = M{2};
    M98 = M{3};
    M99 = M{4};    
    P_3d = cell(6,1);
    cnt = size(Psrc{1},1);
    for i=1:cnt
        pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{2}(i,:),M89);
        P_3d{1} = [P_3d{1};pn];
        pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{3}(i,:),M98);
        P_3d{2} = [P_3d{2};pn];
        pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{4}(i,:),M99);
        P_3d{3} = [P_3d{3};pn];
        pn = Im2D23D(Psrc{2}(i,:),M89,Psrc{3}(i,:),M98);
        P_3d{4} = [P_3d{4};pn]; 
        pn = Im2D23D(Psrc{2}(i,:),M89,Psrc{4}(i,:),M99);
        P_3d{5} = [P_3d{5};pn];
        pn = Im2D23D(Psrc{3}(i,:),M98,Psrc{4}(i,:),M99);
        P_3d{6} = [P_3d{6};pn];
    end
%2、对点云进行中心化对齐
    for i = 1:6
        Sum = zeros(1,3);
        for j =1:cnt
            Sum = Sum + P_3d{i}(j,:);
        end
        avg = Sum/cnt;
        for j =1:cnt
            P_3d{i}(j,:) = P_3d{i}(j,:) - avg;
        end
    end
    
%3、计算尺度差异，补偿
    S_sum = zeros(6,1);
    for i = 1:6
        disPoint = 0;
        for j =1:cnt
            disPoint = disPoint + ((P_3d{i}(j,:)-avg).^2);
        end
        S_sum(i) = sum(disPoint);
    end
    S_sum = S_sum./S_sum(1);
    S_sum = (S_sum.^0.5);
    for i = 1:6
        for j =1:cnt
            disPoint = disPoint*S_sum(i);
        end
    end
%4、计算点云方差，输出
    Pavg = 0;
    for i = 1:6
        Pavg = Pavg + P_3d{i};
    end
    Pavg = Pavg / 6;
    K = cell(6,1);
    for i = 1:6
        K{i} =  P_3d{i} - Pavg;
    end
    JudgeMentMiddle = zeros(6,1);
    for i = 1:6
        JudgeMentMiddle(i) = sum( sqrt(K{i}(:,1).^2 + K{i}(:,2).^2 + K{i}(:,3).^2 ))/size(K{i},1);
    end     
    score = sum(JudgeMentMiddle);
end