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
        std::cout << "Error opening camera" << std::endl;
    } else {
        std::cout << "Camera open succesfully" << std::endl;
    }

    Mat myImage; //Declaring a matrix to load the frames//

    cap2 >> myImage;
    if (myImage.empty()) { //Breaking the loop if no video frame is detected//
        std::cout << "No image captured" << std::endl;
    }
    imwrite("images/camera_snapshot.jpg", myImage);

    cap.release(); //Releasing the buffer memory//
    cap2.release(); //Releasing the buffer memory//
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

void test_camera() {
    VideoCapture cap;
    // open the default camera, use something different from 0 otherwise;
    // Check VideoCapture documentation.
    if (!cap.open(0)) {
        std::cout << "No camera available" << std::endl;
        return;
    }
    cap.set(CAP_PROP_FRAME_WIDTH, 640);
    cap.set(CAP_PROP_FRAME_HEIGHT,480);

    double dWidth = cap.get(CAP_PROP_FRAME_WIDTH); //get the width of frames of the video
    double dHeight = cap.get(CAP_PROP_FRAME_HEIGHT); //get the height of frames of the video

    std::cout << "Resolution of the video : " << dWidth << " x " << dHeight
            << std::endl;
    std::string window_name = "My Camera Feed";
    namedWindow(window_name); //create a window called "My Camera Feed"

    for (;;) {
        Mat frame;
        cap >> frame;
        bool bSuccess = cap.read(frame); // read a new frame from video
        //Breaking the while loop if the frames cannot be captured
        if (bSuccess == false) {
            std::cout << "Video camera is disconnected" << std::endl;
            std::cin.get(); //Wait for any key press
            break;
        }

        // GrabCut implementation

        cv::Mat1b markers(frame.rows, frame.cols);
        // let's set all of them to possible background first
        markers.setTo(cv::GC_PR_BGD);

        // cut out a small area in the middle of the image
        int m_rows = 0.5 * frame.rows;
        int m_cols = 0.5 * frame.cols;
        // of course here you could also use cv::Rect() instead of cv::Range to select
        // the region of interest
        cv::Mat1b fg_seed = markers(cv::Range(frame.rows/2 - m_rows/2, frame.rows/2 + m_rows/2),
                                    cv::Range(frame.cols/2 - m_cols/2, frame.cols/2 + m_cols/2));
        // mark it as foreground
        fg_seed.setTo(cv::GC_FGD);

        // select first 5 rows of the image as background
        cv::Mat1b bg_seed = markers(cv::Range(0, 5),cv::Range::all());
        bg_seed.setTo(cv::GC_BGD);

        cv::Mat bgd, fgd;
        int iterations = 1;
        cv::grabCut(frame, markers, cv::Rect(), bgd, fgd, iterations, cv::GC_INIT_WITH_MASK);

        // let's get all foreground and possible foreground pixels
        cv::Mat1b mask_fgpf = ( markers == cv::GC_FGD) | ( markers == cv::GC_PR_FGD);
        // and copy all the foreground-pixels to a temporary image
        cv::Mat3b tmp = cv::Mat3b::zeros(frame.rows, frame.cols);
        frame.copyTo(tmp, mask_fgpf);
        // show it
        cv::imshow("foreground", tmp);

        //show the frame in the created window
        imshow(window_name, frame);

        //wait for for 10 ms until any key is pressed.
        //If the 'Esc' key is pressed, break the while loop.
        //If the any other key is pressed, continue the loop
        //If any key is not pressed withing 10 ms, continue the loop
        if (waitKey(10) == 27) {
            std::cout << "Esc key is pressed by user. Stopping the video" << std::endl;
            break;
        }
    }
    // the camera will be closed automatically upon exit
    cap.release();

}
