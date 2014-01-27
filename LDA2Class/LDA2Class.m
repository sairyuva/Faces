%%Author : Sandeep Manandhar <manandhar.sandeep@gmail.com> 11/7/2012
%%matlab implementation of LDA of two classes

%%Two classes
X1 = [4, 2; 2, 4;, 2, 3;, 3, 6;, 4, 4];
X2 = [9, 10; 6, 8; 9, 5; 8, 7; 10, 8];

%%class means
u1 = mean(X1);
u2 = mean(X2);

%%calculate covariance matrix of both classes
S1 = cov(X1);
S2 = cov(X2);

%%Withing-class scatter matrix
Sw = S1 + S2;

%%Between class scatter matrix
Sb = (u1 - u2)*(u1 - u2)';

%%computing LDA projection
inverseSw = inv(Sw);
product = inverseSw*Sb;

%%finally get the projection vector
[V, D] = eig(product);

%%projection vector with highest eigen value
W = V(:, 1);

%%projecting the samples along the projection axes

Y1 = W'*X1';
Y2 = W'*X2';


minY = min(min(Y1), min(Y2));
maxY = max(max(Y1), max(Y2));
yo = minY:0.05:maxY;

u_Y1 = mean(Y1);
sigma_Y1 = std(Y1);

u_Y2 = mean(Y2);
sigma_Y2 = std(Y2);

Y1_pdf = mvnpdf(yo', u_Y1, sigma_Y1);
Y2_pdf = mvnpdf(yo', u_Y2, sigma_Y2);
figure(1);
plot(Y2_pdf); hold on;
plot(Y1_pdf, 'red');
