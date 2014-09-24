classdef cParticle
    
    properties
        Euler       
        d_Euler      
        score    
        scoreBest
        EulerBest
    end
    
    methods
        function obj = cParticle(EulerInit,d_EulerInit)
            obj.Euler   = EulerInit;
            obj.d_Euler = d_EulerInit;
        end
        
        function  obj = Move(obj,Msrc,Psrc)
            Mop = cell(4,1);
            for i = 1:4
                obj.Euler(i,:) = obj.Euler(i,:) + obj.d_Euler(i,:);              
                alpha = obj.Euler(i,1);
                beta  = obj.Euler(i,2);
                gamma = obj.Euler(i,3);
              
                R = [ cos(alpha)*cos(gamma)-cos(beta)*sin(alpha)*sin(gamma)  -cos(beta)*cos(gamma)*sin(alpha)-cos(alpha)*sin(gamma)  sin(alpha)*sin(beta);
                      cos(gamma)*sin(alpha)+cos(alpha)*cos(beta)*sin(gamma)   cos(alpha)*cos(beta)*cos(gamma)-sin(alpha)*sin(gamma) -cos(alpha)*sin(beta);
                      sin(beta)*sin(gamma)                        cos(gamma)*sin(beta)                       cos(beta)      ];     
                RT = [R,[0 0 0]';0 0 0 1]; 
                Mop{i} = R*Msrc{i}*RT;
            end
            obj.score = judgeParticle(Mop,Psrc);
            if obj.score < obj.scoreBest
                obj.scoreBest = obj.score;
                obj.EulerBest = obj.Euler;
            end
           
        end
        
        function  obj = updataV(obj,gloBestEuler,a1,a2)
            obj.d_Euler = obj.d_Euler + a1*random('Uniform',0,1)*(obj.Euler - obj.EulerBest) + a2*random('Uniform',0,1)*(obj.Euler - gloBestEuler);
        end
    end
end

