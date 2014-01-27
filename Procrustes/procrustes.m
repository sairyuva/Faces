%%Author : Sandeep Manandhar <manandhar.sandeep@gmail.com>
%%Procrustes analysis code, vital for non rigid tracking

itol = 35; %iteration no.
ftol = .25;



a = csvread('muct.csv',1,2);
disp('before elimination, size of Samples');
[N n] = size(a)

X = a';
j = 0;
zeroPointIndex = [];
for i = 1:N
    if isempty(find(X(:,i)==0))
        continue;
    else
        zeroPointIndex = [zeroPointIndex i];
       
    end
end
P = X;
P(:, zeroPointIndex(:)) = [];
[n N] = size(P);
%%Zero points Samples removed
%%Muct dataset has (0,0) coordinates value for the landmark that were
%%indistinguishable so these sets will be removed

for i=1:N
    
    p = P(:,i);
    mx = 0; my = 0;
    x = p(1:2:n); y = p(2:2:n);
    mx = sum(x)/length(x);
    my = sum(y)/length(y);
    
    p(1:2:n) = x - mx;
    p(2:2:n) = y - my;
    
end
% disp('after elimination, size of Samples');
% size(P)
% y = P(2:2:n, 11);
% x = P(1:2:n, 11);
% scatter(x,y, '.', 'r');
% 
 C_old = zeros(n, 1);
% figure;
% y = P(2:2:n, 6);
% x = P(1:2:n, 6);
% scatter(x,y, '.', 'r');
% axis([0, 600, 0, 600]);
% hold on;
% y = P(2:2:n, 16);
% x = P(1:2:n, 16);
% scatter(x,y, '.', 'b');
% axis([0, 600, 0, 600]);
% 
% y = P(2:2:n, 116);
% x = P(1:2:n, 116);
% scatter(x,y, '.', 'g');
% axis([0, 600, 0, 600]);
% 
% y = P(2:2:n, 1116);
% x = P(1:2:n, 1116);
% scatter(x,y, '.', 'y');
% axis([0, 600, 0, 600]);
% hold off;
for i = 1:itol
    C = P*ones(N, 1)/N;
    normalizedC = C/(sqrt(sum(C.*C)));
    D = norm(normalizedC - C_old);
    if i > 1
        if D < 2.9249e+03   %%threshold
            disp('break');
            break;
        end
    end
    C_old = C;
    for i = 1:N
        %get rotscale aligned matrix
        R = rot_scale(P(:,i), C);
        for j = 1:n/2
            x = P(2*j - 1, i); y = P(2*j, i);
            P(2*j -1, i) = R(1, 1)*x + R(1, 2)*y;
            P(2*j   , i) = R(2, 1)*x + R(2, 2)*y;
            %transfrom each column of P
        end
    end
end

size(P)

%%Visualizing the aligned shapes 
%%only a few for preserving execution time
figure(2);
for i = 1:10
y = P(2:2:n, i);
x = P(1:2:n, i);
plot(x, y, '--rs', 'MarkerEdgeColor', [i/100 i/100*.5 i/100*.3]);
scatter(x, y, '.', 'MarkerEdgeColor', [i/100 i/100*.5 i/100*.3]);
axis([0, 600, 0, 600]);
hold on;
end
y = P(2:2:n, 16);
x = P(1:2:n, 16);
scatter(x,y, '.', 'b');
axis([0, 600, 0, 600]);

y = P(2:2:n, 116);
x = P(1:2:n, 116);
scatter(x,y, '.', 'g');
axis([0, 600, 0, 600]);

y = P(2:2:n, 1116);
x = P(1:2:n, 1116);
scatter(x,y, '.', 'y');
axis([0, 600, 0, 600]);
y = P(2:2:n, 2116);
x = P(1:2:n, 2116);
scatter(x,y, '.', 'black');
axis([0, 600, 0, 600]);

