clear all
clc
tic;
feature = [1 2; 2 1; 1 3; 3 1; 2 2];
frameSz = 19;
[numPos, numNeg] = Db_integralImage();  %may be I should receive database path here instead of inscribing it on one of the called functions...may be later

for i =1:1:5
    sizeX = feature(i,1);
    sizeY = feature(i,2);
    
    for x=2:frameSz - sizeX
        for y=2:frameSz - sizeY
            for windowLen = sizeX:sizeX:frameSz-x
                for windowWid = sizeY:sizeY:frameSz - y
                      %disp('threshold calc');
                    fprintf('x: %e\n', x);
                    fprintf('y: %e\n', y);
                    fprintf('width: %d\n', windowWid);
                    fprintf('length: %d\n', windowLen);
                    fprintf('Classifier: %d\n',i);
                    calcBestThresh(x, y, windowWid, windowLen, i, numPos, numNeg);
                end
            end
        end
    end
    
end
toc;

 







        
        
    