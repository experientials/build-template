// OpenCV libraries
#include <opencv2/opencv.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

// Standard libraries
#include <iostream>

// Local libraries
#include "hello.h"

// Namespace
using namespace cv;

void execute_smoke_test() {
    std::string file_name = "videos/dogRunning.mp4";
    VideoCapture cap(file_name);

    // Check if video opened successfully
    if (!cap.isOpened()) {
        std::cout << "Error opening video stream or file" << std::endl;
    } else {
        std::cout << "Video file opened succesfully" << std::endl;
    }

    VideoCapture cap2;
    cap2.open(0, 0);
    if (!cap2.isOpened()) {
        std::cout  << "Error opening camera" << std::endl;
    }
    else {
        std::cout  << "Camera open succesfully" << std::endl;
    }

    Mat myImage;//Declaring a matrix to load the frames//

    cap2 >> myImage;
    if (myImage.empty()) { //Breaking the loop if no video frame is detected//
        std::cout  << "No image captured" << std::endl;
    }
    imwrite("images/camera_snapshot.jpg", myImage);

    cap.release();//Releasing the buffer memory//
    cap2.release();//Releasing the buffer memory//
}

void execute_blur_filter() {
    Mat src = imread("images/example.jpg");

    Mat dst;
    // Gaussian filter
    // sigmaX and sigmaY are both 0, just calculated by ksize.width and ksize.height
    // Size w, h must be an odd number
    GaussianBlur(src, dst, Size(5, 5), 0, 0);
    imwrite("images/example_blurred.jpg", dst);
}
