function [] = adaBoost(x, y, winWidth, winLength, classifier, posMean, posStd, j, err, adaWeights, c, posMax, posMin,posErr, negErr)
% x and y coordinates of classifier
% width and length are width and length of classifier
% feature num is the feature being used
% posMean is the mean of the feature being used
% posStd is the standard deviation
% j is the best number of the standard deviation to use for classification
% err is the error to calculate alpha
% adaWeights are the current weights of adaboost for each image
% c contains information about which images were classified correctly and
% which were not by writing a zero to correctly classified and 1 for
% incorrectly classified

%disp('Using Adaboost on weak classifier');
bestClassFile = 'classifiers.mat';
classifiers = open(bestClassFile);
classifiers = classifiers.classifiers;
alpha = 1/2*(log((1-err)/err));
i = 1:max(size(adaWeights));    %max(size(adaWeights)) = total weights or total images because this value was not sent from calling function
adaWeights(i) = adaWeights(i).*exp(alpha*c(i)); %those correctly classified images will have c(i)= 0 making no change in their adaWeights
adaWeights = adaWeights/sum(adaWeights);
weightsFile = 'weights.mat';
save(weightsFile, '-double', 'adaWeights');

[M N] = size(classifiers);
classifiers(1, N+1) = x;
classifiers(2, N+1) = y;
classifiers(3, N+1) = winWidth;
classifiers(4, N+1) = winLength;
classifiers(5, N+1) = classifier;
classifiers(6, N+1) = posMean;
classifiers(7, N+1) = posStd;
classifiers(8, N+1) = posMax;
classifiers(9, N+1) = posMin;
classifiers(10, N+1) = j;
classifiers(11, N+1) = alpha;
classifiers(12, N+1) = err;
classifiers(13, N+1) = posErr;
classifiers(14, N+1) = negErr;
save(bestClassFile, 'classifiers');
fprintf('x start value: %e\n', x);
fprintf('y start value: %e\n', y);
fprintf('Width: %e\n', winWidth);
fprintf('Length: %e\n', winLength);
fprintf('classifier: %e\n', classifier);
fprintf('Mean value: %e\n', posMean);
fprintf('Std Value: %e\n', posStd);
fprintf('Max value: %e\n', posMax);
fprintf('Min value: %e\n', posMin);
fprintf('j: %e\n', j);

fprintf('classifier saved; new classifier increased to %dx%d size\n', size(classifiers,1), size(classifiers,2));
