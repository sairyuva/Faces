/*Copyright (c) 2013, Sandeep Manandhar<manandhar.sandeep@gmail.com>

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer 
in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//Face detection using CUDA
//The source code was written and tested in windows machine running windows 8, visual studio 2012 with following configuration:
//CPU : Intel corei7 4700MQ
//RAM : 8GB
//GPU : Nvidia GeForce GT755M
//
*/

#include <opencv2\core\core.hpp>
#include <opencv2\highgui\highgui.hpp>
#include <opencv2\imgproc\imgproc.hpp>
#include <opencv2\gpu\gpu.hpp>
#include <iostream>
#define WIDTH 1280	//capture window's width
#define HEIGHT 720	//capture window's height
#define FPS 30		//capture fps

using namespace cv;

int main()
{
	std::cout<<"***********TESTING GPU*************\n";
	int CUDA_DEV_COUNT = gpu::getCudaEnabledDeviceCount();
	if(CUDA_DEV_COUNT == 0)
		return -1;
	std::cout<<"CUDA enabled device found : "<<CUDA_DEV_COUNT<<"\n";

	/*******setting device*********/
	gpu::setDevice(0);	// Important: device number starts with 0
	gpu::DeviceInfo device(0);
	
	int devID = device.deviceID();
	string devName = device.name();
	int majorComputeCapability = device.majorVersion();
	int minorComputeCapability = device.minorVersion();
	int multiProcessorCount = device.multiProcessorCount();
	size_t totalMemory = device.totalMemory();
	size_t freeMemory = device.freeMemory();
	std::cout<<"\nDevice ID : "<<devID;
	std::cout<<"\nDevice Name : "<<devName;
	std::cout<<"\nMajor compute capability version : "<<majorComputeCapability;
	std::cout<<"\nMinor compute capability version : "<<minorComputeCapability;
	std::cout<<"\nMultiprocessor count : "<<multiProcessorCount;
	std::cout<<"\nTotal Memory : "<<totalMemory/(1024*1024*1024)<<" Gigabytes";
	std::cout<<"\nFree memory : "<<freeMemory/(1024*1024*1024)<<" Gigabytes";
	std::cout<<"\n";

	
	gpu::CascadeClassifier_GPU haarClass;
	if(haarClass.load("classifiers//haarcascade_frontalface_alt.xml"))	//classifier file
		std::cout<<"\nclassifier loaded";
	
	std::cout<<"\n*************initiating camera************\n";

	VideoCapture cap(0);	//capture device

	cap.set(CV_CAP_PROP_FRAME_WIDTH, WIDTH);	
	cap.set(CV_CAP_PROP_FRAME_HEIGHT, HEIGHT);
	cap.set(CV_CAP_PROP_FPS, FPS);
	
	if(!cap.isOpened())	
	{
		std::cout<<"error opening camera\n";
		return -1;
	}
	std::cout<<"Camera found\nNow Detecting faces\n";

	gpu::GpuMat objBuf;

	//initiate capture and detect sequence
	for(;;)
	{
		Mat frame ;
		Mat frame_gray, frame_pyrD;	//frame_pyrD for downSampling 

		cap>>frame;	//get frames from capture device
		cvtColor(frame, frame_gray, CV_BGR2GRAY);	//convert BGR image to gray
	    
		pyrDown(frame_gray, frame_pyrD);	//down sampling decrease processing time
		gpu::GpuMat d_frame(frame_pyrD);	//copying frame to cuda device
		
		
	    Mat h_obj;
		int detectedNum = haarClass.detectMultiScale(d_frame, objBuf, 1.2, 5);	//detector
		//std::cout<<detectedNum<<"\n";

		objBuf.colRange(0, detectedNum).download(h_obj);	
		Rect *faces = h_obj.ptr<Rect>();	//rectangles for all the detected faces
		Point p1, p2;	//p1 = topLeft coordinates, p2 = bottomRight coordinates
		Size sz;	//size of the rectangle
	
		for(int i = 0; i<detectedNum; ++i)	{
		
			 p1 = faces[i].tl(); //topleft coordinates
			 sz = faces[i].size();
			 p1.x *=2;	//multiplication is necessary if previously downsampled. Multiplication by 2 because down sampled by 1/2
			 p1.y *=2;
			 p2 = Point(p1.x + sz.width*2, p1.y + sz.height*2);	
			rectangle(frame, p1, p2, Scalar(255), 2);	//patching  the rectangles with original unaltered frame

			std::stringstream coor;	
			coor<<p1.x<<","<<p1.y;	//number to stream
			std::string a = coor.str();
			putText(frame, a, p1, FONT_HERSHEY_SIMPLEX, 0.5, Scalar(255,255,255), 1);
		}
		
	    imshow("Face detected", frame);
		
		
		
		if(waitKey(30) >= 0) break;
	}
	
	
	
}
