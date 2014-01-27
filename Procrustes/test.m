
a = [1 3 1; 1 0 1; 0 4 1; 0 0 1; 3 1 1; 4 2 1]
[n N] = size(a);
R = zeros(6, 4);
mean = a*ones(3, 1)/3
 for i = 1:n-1
     R(i, 1) = mean(i); R(i + 1, 1) = mean(i+1);
     R(i, 2) = -mean(i+1); R(i + 1, 2) = mean(i);
     R(i, 3) = 1;   R(i + 1, 2) = 0;
     R(i, 4) = 0;   R(i + 1, 4) = 1;
 end
 
 for i = 1:4
     r = R(:,i);
     for j = 1:i
         b = R(:,j); r = r - b*b'*r;
     end
     r = r/(sqrt(sum(r.*r)));
 end
 
 