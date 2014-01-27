clear all
close all
clc


TrainDbPath = 'C:\Users\walrus\Desktop\PCA-LDA based face recognition\TrainDatabase';
TrainFiles = dir(TrainDbPath);
TrainImgNo = 0;
for i = 1:size(TrainFiles,1)
    if not(strcmp(TrainFiles(i).name,'.')|strcmp(TrainFiles(i).name,'..')|strcmp(TrainFiles(i).name,'Thumbs.db'))
        TrainImgNo = TrainImgNo + 1; % Number of all images in the training database
    end
end

%constructing 2D matrix with 1D vector images
T = [];

for i = 1:TrainImgNo
    str = int2str(i);
    str = strcat(TrainDbPath, '\', str, '.jpg');
    img = imread(str);
    img = rgb2gray(img);
    [row col] = size(img);
    temp = reshape(img', row*col,1);
    T = [T temp];
end
T = double(T);
Class_number = size(T,2)/2; %%because i am using 2 faces per class
Class_population = 2; 
P = size(T,2);

mean_db = mean(T, 2);

A = T - repmat(mean_db, 1, P); %%replicating mean_db upto P cols; P = total training images
% now A = deviation of each images form mean image

%%Eigenface algorithm
% we could have done C = A*A' but that would have led to highly dimensional matrix.
% we use a technique where L = A'*A is calculated
% say size(A) = 10304*4 (10304 = total pixel and 4 training images) so if we do A*A', it will be 10304*10304 matrix
% Now if we do A'*A, it will be 4*4 matrix.
% further A'*A is a symmetric matrix os A'*A = (A*A')'
% Now we need to calculate the eigenvectors of this small covariance matrix
% Let v be the eigenvector of A'*A with a non zero eigen Value
% So A'*A*v = lambda*v
% multiplying both sides with A
% A*A'*A*v = A*lambda*v
% (A*A')*A*v = lambda*A*v
% So we can see, A*v is the eigen vector of A*A' which was originally
% intended covariance matix
% gentlemen we have reduced some calculations

L = A'*A;   %covariance matrix with small dimension
[V D] = eig(L); %D has the eigenvalues along its diagonal in ascending order
% we have got the eigvectros and eigvals
L_eig_vec = []; %eigvectors with relevant eigvals
for i = P:-1:Class_number+1
   %the higher eigvals are present at higher cols
   %so we move from last col to class number+1
   %if there were 4 classes(each have two images) we would go from 8th to
   %5th cols total of 4 eigvectors
    L_eig_vec = [L_eig_vec V(:,i)];
   
end
%up to this point, only the eigen vectors of the smaller cov matrix have
%been found
%eigen vectors of covariance matrix 'C', the larger one
V_PCA = A*L_eig_vec;
v = uint8(V_PCA);
figure(1);    
for i = 1:size(V_PCA,2)
    img = reshape(v(:,i), col, row);
    img = img';
    subplot(3,4,i);
    if(i == 3)
           title('Eigen Faces', 'fontsize',15);
    end
    imshow(img); hold on;

end
hold off;
%%requires refresher on basis and alternate coordinate system
PImages_PCA = [];
for i=1:P
    temp = V_PCA'*A(:,i);   %centered image to face space
    PImages_PCA = [PImages_PCA temp];
end
% projecting into face space done

m_PCA = mean(PImages_PCA,2); %%mean in eigenspace
m  = zeros(P - Class_number, Class_number);
Sw = zeros(P-Class_number, Class_number);
Sb = zeros(P-Class_number, Class_number);

for i = 1:Class_population
   % m(:,i) = mean((PImages_PCA(:,((i-1)*2+1):i*2)),2)';
    m(:,i) = mean( ( PImages_PCA(:,((i-1)*Class_population+1):i*Class_population) ), 2 )';
   % taking the mean of each class
   
   S = zeros(P - Class_number, P - Class_number);
   for j = (i-1)*Class_population+1:i*Class_population
       S = S + (PImages_PCA(:,j) - m(:,i))*(PImages_PCA(:,j) - m(:,i))';
   end
   
   %calculate within class scatter matrix by adding up all the S matrices
   %of individual classes
   
   Sw = Sw + S;
   Sb = Sb + 2*(m(:,i) - m_PCA)*(m(:,i) - m_PCA)';
end


[J_eigVec, J_eigVal] = eig(Sb,Sw);
J_eigVec;
%%eigVal are arranged in ascending order
%so flipping the eigVec matrix will arrange them in descending order of
%eigVal
J_eigVec = fliplr(J_eigVec);

for i=1:Class_number-1
    V_Fisher(:,i) = J_eigVec(:,i); %largest eigVect being collected
end

for i=1:Class_population*Class_number %total training images
    PImages_Fisher(:,i) = V_Fisher'*PImages_PCA(:,i);
end

[FileName,PathName] = uigetfile({'*.jpg';'*.bmp';'*.pgm'},'Select the test image file');
strT = strcat(PathName,FileName);
testIm = imread(strT);
testImg = rgb2gray(testIm);
[row col] = size(testImg);
testCase = [];
testCase = reshape(testImg', row*col, 1);
diffImage = double(testCase) - mean_db;
ProjectedTestImage = V_Fisher'*V_PCA'*diffImage;

%finding the euclidean distance from the training images

euc_dist = [];
for i = 1:TrainImgNo
    training_sample = PImages_Fisher(:,i);
    dist = (norm(ProjectedTestImage - training_sample))^2;
  
    euc_dist = [euc_dist dist];
end
[euc_distance matchingImageIndex] = min(euc_dist)

matchedImage = strcat(TrainDbPath,'\', int2str(matchingImageIndex),'.jpg');
figure(2);
subplot(2,2,1);
imshow(matchedImage); title('match found!!!', 'fontsize', 15); hold on;
subplot(2,2,2);
imshow(testIm); title('test image', 'fontsize',15);