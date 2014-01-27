function[rectVal] = calcIntegralRec(intImg, points)
rowVal = points(1, 1); colVal = points(1,2);

wid = points(1,3); ht = points(1,4);

% fprintf('r: %d, c: %d || w: %d, h: %d \n', rowVal, colVal, wid, ht);
one = intImg(rowVal-1, colVal-1);
two = intImg(rowVal-1, colVal+wid);
three = intImg(rowVal+ht, colVal-1);
four = intImg(rowVal+ht, colVal+wid);
rectVal = one+four-two-three;

% fprintf('two : %d\n', two);
% fprintf('three : %d\n', three);
% fprintf('four : %d\n', four);
%possible errors
%Attempted to access intImg(1,0); index
%must be a positive integer or logical.
%