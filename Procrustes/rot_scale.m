%%Author : Sandeep Manandhar <manandahr.sandeep@gmail.com>
%%Routine for rigid transformation
function R = rot_scale(src, dst)
n = size(src,1)/2; 
a = 0; b = 0; d = 0;
for i=1:n
    d = d + src(2*i - 1)*src(2*i - 1) + src(2*i)*src(2*i);
    a = a + src(2*i - 1)*dst(2*i - 1) + src(2*i)*dst(2*i);
    b = b + src(2*i - 1)*dst(2*i) - src(2*i)*dst(2*i - 1);
end

a = a/d; b = b/d;
R = [a -b;
    b a];

