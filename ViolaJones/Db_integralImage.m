function[faces_num, Nfaces_num] = Db_integralImage()
%tic;
disp('Initializing Database...');


DbPath_faces = 'VarianceFaces\';
faces_files = dir(DbPath_faces);
faces_num = -1; %offset because we got folder named int there along with images
for i = 1:size(faces_files,1)
    if not(strcmp(faces_files(i).name, '.') | strcmp(faces_files(i).name,'..') | strcmp(faces_files(i).name,'Thumbs.db'))
       faces_num = faces_num+1;
    end
end




for i=1:faces_num
    str = strcat(DbPath_faces, int2str(i), '.pgm');
    eval('img = imread(str);');
     intImg = cumsum(cumsum(double(img)),2); %this is the integral image which will be saved for next use
     save(strcat(DbPath_faces, 'int\', int2str(i), '.mat'), '-double', 'intImg');
end
disp('Database for positive integral images created');


DbPath_Nfaces = 'VarianceNonFaces\';
Nfaces_files = dir(DbPath_Nfaces);
Nfaces_num = -1; %offset because we got folder named int there along with images
for i = 1:size(Nfaces_files,1)
    if not(strcmp(Nfaces_files(i).name, '.') | strcmp(Nfaces_files(i).name,'..') | strcmp(Nfaces_files(i).name,'Thumbs.db'))
       Nfaces_num = Nfaces_num+1;
    end
end


for i=1:Nfaces_num
    str = strcat(DbPath_Nfaces, int2str(i), '.pgm');
    eval('img = imread(str);');
    intImg = cumsum(cumsum(double(img)),2);
    save(strcat(DbPath_Nfaces, 'int\', int2str(i), '.mat'), '-double', 'intImg');   
end
disp('Database for negative integral images created');

wp = ones(1, faces_num);
wn = ones(1, Nfaces_num);
total = faces_num + Nfaces_num;
adaWeights = [wp/total wn/total];
adaweight = 'weights.mat';
save(adaweight, '-double', 'adaWeights');   %string name(filename), data type, variable name
disp('Weights initialized and saved');

classifiers = zeros(14,0);
save('classifiers.mat', 'classifiers');
disp('Classifiers initialized and saved');
fprintf('Database initialized with %d positive images and %d negative images \n', faces_num, Nfaces_num);
%toc;
