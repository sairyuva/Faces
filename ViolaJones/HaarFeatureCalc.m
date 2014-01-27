function[thres] = HaarFeatureCalc(intImg, x, y, winWidth, winLength, classifier)

if(classifier == 1)
    firstRec = [x y uint16(winWidth-1) uint16(winLength/2 -1)];  %say firstRec is white rect
                                                    %x,y is the top left
                                                    %corner's coordinates
                                                    %3rd and 4th parameters
                                                    %are window's width and
                                                    %length
    secRec   = [uint16(x + winLength/2) y uint16(winWidth - 1) uint16(winLength/2 -1)];
    thres = calcIntegralRec(intImg, firstRec) - calcIntegralRec(intImg, secRec);
end

if(classifier == 2)
    firstRec = [x y uint16(winWidth/2-1) winLength - 1];
    secRec = [x uint16(y+winWidth/2) uint16(winWidth/2 -1) uint16(winLength - 1)];
     thres = calcIntegralRec(intImg, firstRec) - calcIntegralRec(intImg, secRec);
end
if(classifier == 3)
    firstRec = [x y uint16(winWidth - 1) uint16(winLength/3 -1)];
    secRec   = [uint16(x + winLength/3) y uint16(winWidth - 1) uint16(winLength/3 -1)];
    thirdRec = [uint16(x + 2*winLength/3) y uint16(winWidth - 1) uint16(winLength/3 -1)];
    thres = calcIntegralRec(intImg, firstRec) - calcIntegralRec(intImg, secRec) + calcIntegralRec(intImg, thirdRec);
end
if(classifier == 4)
    firstRec = [x y uint16(winWidth/3 - 1) winLength - 1];
    secRec   = [x uint16(y+winWidth/3) uint16(winWidth/3 - 1) winLength - 1];
    thirdRec = [x uint16(y+2*winWidth/3) uint16(winWidth/3 - 1) winLength - 1];
    thres = calcIntegralRec(intImg, firstRec) - calcIntegralRec(intImg, secRec) + calcIntegralRec(intImg, thirdRec);
end
if(classifier == 5)
    firstRec = [x y uint16(winWidth/2 - 1) uint16(winLength/2 - 1)];
    
    secRec   = [x uint16(y + winWidth/2) uint16(winWidth/2 - 1) uint16(winLength/2 - 1)];
   
    thirdRec = [uint16(x + winLength/2) y uint16(winWidth/2 - 1) uint16(winLength/2 - 1)];
   
    fourthRec= [uint16(x + winLength/2) uint16(y + winWidth/2) uint16(winWidth/2 - 1) uint16(winLength/2 - 1)];
 
     thres = calcIntegralRec(intImg, firstRec) - calcIntegralRec(intImg, secRec) - calcIntegralRec(intImg, thirdRec) + calcIntegralRec(intImg, fourthRec);
end