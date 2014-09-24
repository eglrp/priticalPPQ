close all
clear
%% 数据初始化
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

M = cell(1,4);
M{1} = M88;
M{2} = M89;
M{3} = M98;
M{4} = M99;

%BeginScore = judgeParticle(M,Psrc);

%%
%% 2、粒子初始化
vSize = 100;
V = cell(vSize,1);
EulerInit   = cell(vSize,1);
for i = 1:vSize
%             V{x} = [ cos(i)*cos(k)-cos(j)*sin(i)*sin(k)  -cos(j)*cos(k)*sin(i)-cos(i)*sin(k)  sin(i)*sin(j);
%                     cos(k)*sin(i)+cos(i)*cos(j)*sin(k)   cos(i)*cos(j)*cos(k)-sin(i)*sin(k) -cos(i)*sin(j);
%                     sin(j)*sin(k)                        cos(k)*sin(j)                       cos(j)      ];  
            V{i} = zeros(4,3);      
            EulerInit{i} = zeros(4,3);
            for j = 1:4
                V{i}(j,1) = random('Uniform',-(pi/4),(pi/4));
                V{i}(j,2) = random('Uniform',-(pi/4),(pi/4));
                V{i}(j,3) = random('Uniform',-(pi/4),(pi/4));
            end 
end
particleSet = cell(vSize,1);

for i = 1:vSize
    particleSet{i} = cParticle(EulerInit{i},V{i});
    particleSet{i} = particleSet{i}.Move(M,Psrc);
    particleSet{i}.scoreBest = particleSet{i}.score;%第一次赋值时要手动更新scoreBest与VSbest
    particleSet{i}.EulerBest = particleSet{i}.Euler ;  
end
gloBestScore = particleSet{1}.score;
gloBestEuler = particleSet{1}.Euler;


%%
%粒子运动
out = [];
for k = 1:50
    for i = 1:vSize
        particleSet{i} = particleSet{i}.Move(M,Psrc);
        if particleSet{i}.score <  gloBestScore 
            gloBestScore = particleSet{i}.score ;
            gloBestEuler = particleSet{i}.Euler;
        end
        particleSet{i} = particleSet{i}.updataV(gloBestEuler,0.1,0.1);
    end
     particleSet{1} = cParticle(gloBestEuler,V{1});
     particleSet{1}.scoreBest = gloBestScore;%第一次赋值时要手动更新scoreBest与VSbest
     particleSet{1}.EulerBest = particleSet{1}.Euler ;  
    out = [out;gloBestScore];
end


