close all
clear
%%
Cam88ExData = [-0.263762448700697,	0.951350977422150,	-0.159250395331791,	-816.982124603909,
		0.566782496588887,	0.0192679735646857,	-0.823642122984964,	-99.2903123461814,
		-0.780504306340382,	-0.307506199860474,	-0.544291250004526,	3716.72506415133,
		0,	0,	0,	1];
Cam88InData = [1102.01326149165,	0,	277.413229496810,	0,
		0,	1096.74472810592,	242.248121093796,	0,
		0,	0,	1,	0];

 Cam89ExData = [  0.454569938710746,	0.851714451986509,	0.260669643606290,	-505.961650021673;
		0.546829077885983,	-0.0358429771921313,	-0.836476682618452,	-3.46104418465871;
		-0.703096103245406,	0.522778895196933,	-0.482035368347386,	3525.42579780070;
		0,	0,	0,	1  ];

 Cam89InData = [ 1140.90357301518,	0,	327.814209142770,	0;
		0,	1141.11688441642,	237.087322877972,	0;
		0,	0,	1,	0];
 Cam98ExData = [  0.186666 ,	 -0.978722 ,	 -0.085200 ,  -751.439824  ;
		                        -0.589527, 	 -0.042216 , -0.806645  , -260.305300;
		                        0.785884 ,	 0.200801 	, -0.584863 ,  3084.210249;
		                        0        ,           0 ,         0     ,     1         ];

  Cam98InData = [1050.77334,   0,           466.65185 ,  0; 
		                        0  ,        1148.63287 , 410.29566 ,  0;
		                        0  ,         0  ,          1   ,      0];


  Cam99ExData = [  -0.483594 ,	 -0.839359 ,	 0.248220  ,      105.439430;
								-0.498046 ,	 0.030670 ,	 -0.866608     ,  279.535740;
								0.719782 ,	 -0.542711 ,	 -0.432872 ,      3734.464675;
								0	     ,     0       ,          0    ,          1            ];

  Cam99InData = [  1134.74570 ,   0           ,   345.36929  , 0;
					0          ,   1138.08795  ,   189.67517  , 0;
					0          ,   0           ,   1          , 0];

M88 = Cam88InData*Cam88ExData;
M89 = Cam89InData*Cam89ExData;
M98 = Cam98InData*Cam98ExData;
M99 = Cam99InData*Cam99ExData;
%%
load 'pic88.txt'
load 'pic89.txt'
load 'pic98.txt'
load 'pic99.txt'

Psrc = cell(1,4);
Psrc{1} = pic88;
Psrc{2} = pic89;
Psrc{3} = pic98;
Psrc{4} = pic99;

%% 以各种参数组合做3维重建
Pab = []; 
Pac = [];
Pad = [];
Pbc = [];
Pbd = [];
Pcd = [];
cnt = size(Psrc{1},1);
for i=1:cnt
    pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{2}(i,:),M89);
    Pab = [Pab;pn];
    pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{3}(i,:),M98);
    Pac = [Pac;pn];
    pn = Im2D23D(Psrc{1}(i,:),M88,Psrc{4}(i,:),M99);
    Pad = [Pad;pn];
    pn = Im2D23D(Psrc{2}(i,:),M89,Psrc{3}(i,:),M98);
    Pbc = [Pbc;pn]; 
    pn = Im2D23D(Psrc{2}(i,:),M89,Psrc{4}(i,:),M99);
    Pbd = [Pbd;pn];
    pn = Im2D23D(Psrc{3}(i,:),M98,Psrc{4}(i,:),M99);
    Pcd = [Pcd;pn];
end
%% 绘图：各3D重建结果
plot3(Pab(:,1),Pab(:,2),Pab(:,3),'r.');
hold on 
plot3(Pac(:,1),Pac(:,2),Pac(:,3),'b.');
hold on
plot3(Pad(:,1),Pad(:,2),Pad(:,3),'g.');
hold on
plot3(Pbc(:,1),Pbc(:,2),Pbc(:,3),'k.');
hold on
plot3(Pbd(:,1),Pbd(:,2),Pbd(:,3),'c.');
hold on
plot3(Pcd(:,1),Pcd(:,2),Pcd(:,3),'m.');
hold off
%%
Pavg = (Pab + Pac + Pad + Pbc + Pbd + Pcd)/6;
%以均方差作为评价指标
K = cell(6,1);
K{1} = (Pab - Pavg);
K{2} = (Pac - Pavg);
K{3} = (Pad - Pavg);
K{4} = (Pbc - Pavg);
K{5} = (Pbd - Pavg);
K{6} = (Pcd - Pavg);
JudgeMentBefore = zeros(6,1);
for i = 1:6
    JudgeMentBefore(i) = sum( sqrt(K{i}(:,1).^2 + K{i}(:,2).^2 + K{i}(:,3).^2 ))/size(K{i},1);
end 
figure,
bar(JudgeMentBefore,0.5);
%%


%% % 把所有的点归到平均位置上
    %-------------------------
    % xx -> avg
    R = cell(6,1);
    T = cell(6,1);
    s = cell(6,1);
    RR = cell(6,1);
    A = cell(6,1);
    err = cell(6,1);
    Pdis = cell(6,1);
    A{1} = Pab'; A{2} = Pac'; A{3} = Pad'; A{4} = Pbc'; A{5} = Pbd'; A{6} = Pcd';
    B = Pavg';
    for i = 1:6
        Src = A{i};
        [s{i}, R{i}, T{i}, err{i}] = absoluteOrientationQuaternion( Src, B, 0);
        RR{i} = [R{i},T{i}./s{i};0 0 0 1];
        Pdis{i} = (s{i}*R{i}*A{i})';
        for j = 1:cnt
            Pdis{i}(j,:) = Pdis{i}(j,:) + T{i}';
        end
    end
figure,
plot3(Pdis{1}(:,1),Pdis{1}(:,2),Pdis{1}(:,3),'r.');
hold on 
plot3(Pdis{2}(:,1),Pdis{2}(:,2),Pdis{2}(:,3),'b.');
hold on
plot3(Pdis{3}(:,1),Pdis{3}(:,2),Pdis{3}(:,3),'g.');
hold on
plot3(Pdis{4}(:,1),Pdis{4}(:,2),Pdis{4}(:,3),'k.');
hold on
plot3(Pdis{5}(:,1),Pdis{5}(:,2),Pdis{5}(:,3),'c.');
hold on
plot3(Pdis{6}(:,1),Pdis{6}(:,2),Pdis{6}(:,3),'m.');
hold off

Pavg = 0;
for i = 1:6
    Pavg = Pavg + Pdis{i};
end
Pavg = Pavg / 6;
K = cell(6,1);
for i = 1:6
    K{i} =  Pdis{i} - Pavg;
end
JudgeMentMiddle = zeros(6,1);
for i = 1:6
    JudgeMentMiddle(i) = sum( sqrt(K{i}(:,1).^2 + K{i}(:,2).^2 + K{i}(:,3).^2 ))/size(K{i},1);
end 
figure,
bar(JudgeMentMiddle,0.5);
%%  
%粒子群算法
%1、初始化粒子
StatuePos = cell(6,2);
for i = 1:6
    StatuePos{i,1} = R{i};
    StatuePos{i,2} = T{i};
end
V_o = [];
for i = 1:(2*pi/30):2*pi
    for j = 1:(2*pi/30):2*pi
        for k = 1:(2*pi/30):2*pi
            V_n = [ cos(i)*cos(k)-cos(j)*sin(i)*sin(k)  -cos(j)*cos(k)*sin(i)-cos(i)*sin(k)  sin(i)*sin(j);
                    cos(k)*sin(i)+cos(i)*cos(j)*sin(k)   cos(i)*cos(j)*cos(k)-sin(i)*sin(k) -cos(i)*sin(j);
                    sin(j)*sin(k)                        cos(k)*sin(j)                       cos(j)      ];
            V_o = [V_o;V_n];    
        end
    end
end
vSize = size(V_o,1)/3;
V = cell(vSize,1);
for i = 1:vSize
    V{i} = V_o((3*i-2):3*i,:);
end
clear V_o;
for i = 1:6
    StatuePos{i,1} = R{i};
    StatuePos{i,2} = T{i};
end
particleSet = cell(1,6*vSize);
for i = 1:6
    for j = 1:vSize
        particleSet{(i-1)*vSize+j} = cParticle(StatuePos{i},V{j},K);
    end
end
%2、对所有粒子进行评价
%%



%     M88_n = M88/RR1;
%     M89_n = M89/RR1;
%     M88_n = M88_n./s;
%     M89_n = M89_n./s;
%     P1 = []; 
%     cnt = size(Psrc{1},1);
%     for i=1:cnt
%         pn = Im2D23D(Psrc{1}(i,:),M88_n,Psrc{2}(i,:),M89_n);
%         P1 = [P1;pn];
%     end
    
    
figure,
plot3(P2(:,1),P2(:,2),P2(:,3),'r.');
hold on 
plot3(P1(:,1),P1(:,2),P1(:,3),'b.');
hold on 



