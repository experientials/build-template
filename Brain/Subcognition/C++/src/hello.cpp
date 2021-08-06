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
