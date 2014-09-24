imageFileNames = {
  %   '.\88.tif',...
  %   '.\89.tif',...
 %    '.\98.tif',...
     '.\99.tif',...
     };
 
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

Psrc = cell(1,size(imageFileNames,2));
fid=fopen('a.txt','wt'); %加t表示以文本文件模式（text mode）打开
for i = 1:size(imageFileNames,2)  
    fprintf(fid,'\n  %s \n',imageFileNames{i});
    Psrc{i} = imagePoints(:,:,i);
    for j = 1:size(Psrc{i},1)
        fprintf(fid,'%f %f \n',Psrc{i}(j,1),Psrc{i}(j,2));
    end 
    
    figure,
    disp(imageFileNames{i});
    im = imread(imageFileNames{i});
    imshow(im);
    hold on 
    plot(Psrc{i}(:,1),Psrc{i}(:,2),'r*');
    hold off
end
fclose(fid);

