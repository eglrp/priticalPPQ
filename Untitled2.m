load 'pic88.txt'
a = pic88(1:54,:);
b = pic88(55:end,:);
a = flipud(a);

c = [a;b];
fid=fopen('pic88n.txt','wt'); %加t表示以文本文件模式（text mode）打开
    for j = 1:size(c,1)
        fprintf(fid,'%f %f \n',c(j,1),c(j,2));
    end 
    
    fclose(fid);