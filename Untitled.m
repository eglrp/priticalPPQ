 M_n = cell(4,1); 
for i = 1:4
    alpha =  gloBestVS(i,1);
    beta =  gloBestVS(i,2);
    gamma =  gloBestVS(i,3);
    R{i} = [ cos(alpha)*cos(gamma)-cos(beta)*sin(alpha)*sin(gamma)  -cos(beta)*cos(gamma)*sin(alpha)-cos(alpha)*sin(gamma)  sin(alpha)*sin(beta);
                          cos(gamma)*sin(alpha)+cos(alpha)*cos(beta)*sin(gamma)   cos(alpha)*cos(beta)*cos(gamma)-sin(alpha)*sin(gamma) -cos(alpha)*sin(beta);
                          sin(beta)*sin(gamma)                        cos(gamma)*sin(beta)                       cos(beta)      ];  
                      
    Rn = [R{i},[0 0 0]';0 0 0 1];
    M_n{i} = M{i}*Rn;
end
 
  P_3d_n = cell(6,1);
cnt = size(Psrc{1},1);
    for i=1:cnt
        pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{2}(i,:),M89);
        P_3d_n{1} = [P_3d_n{1};pn];
        pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{3}(i,:),M98);
        P_3d_n{2} = [P_3d_n{2};pn];
        pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{4}(i,:),M99);
        P_3d_n{3} = [P_3d_n{3};pn];
        pn = Im2D23D(Psrc{2}(i,:),M89,Psrc{3}(i,:),M98);
        P_3d_n{4} = [P_3d_n{4};pn]; 
        pn = Im2D23D(Psrc{2}(i,:),M89,Psrc{4}(i,:),M99);
        P_3d_n{5} = [P_3d_n{5};pn];
        pn = Im2D23D(Psrc{3}(i,:),M98,Psrc{4}(i,:),M99);
        P_3d_n{6} = [P_3d_n{6};pn];
    end
    %%
    %2、对点云进行中心化对齐
    for i = 1:6
        Sum = zeros(1,3);
        for j =1:cnt
            Sum = Sum + P_3d_n{i}(j,:);
        end
        avg = Sum/cnt;
        for j =1:cnt
            P_3d_n{i}(j,:) = P_3d_n{i}(j,:) - avg;
        end
    end
    
    %% 绘图：各3D重建结果
    figure,
plot3(P_3d_n{1}(:,1),P_3d_n{1}(:,2),P_3d_n{1}(:,3),'r.');
hold on 
% plot3(P_3d_n{2}(:,1),P_3d_n{2}(:,2),P_3d_n{2}(:,3),'b.');
% hold on
% plot3(P_3d_n{3}(:,1),P_3d_n{3}(:,2),P_3d_n{3}(:,3),'g.');
% hold on
% plot3(P_3d_n{4}(:,1),P_3d_n{4}(:,2),P_3d_n{4}(:,3),'k.');
% hold on
% plot3(P_3d_n{5}(:,1),P_3d_n{5}(:,2),P_3d_n{5}(:,3),'c.');
hold on
plot3(P_3d_n{6}(:,1),P_3d_n{6}(:,2),P_3d_n{6}(:,3),'m.');
hold off


  
