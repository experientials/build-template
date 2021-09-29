# Subcognition

This is a cognitive system that runs by default. It monitors the surrounding environment to identify
the nature of changes. The initial version will be processing camera input to identify movement. It will
also monitor a light sensor to identify dominant color and light level.

If possible it should produces an OS video device that provides a slightly compressed feed which filters out
periods of no activity.

It should be written in Rust if possible, C++ as a secondary choice. It can rely on OpenCV.

Supported camera devices to be considered.

# Hand detection

There are many research papers published hand detection techniques over the years. Two of those give a nice overview of the most popular techniques:
- [Hand Gesture Recognition Based on Computer Vision: A Review of Techniques](https://www.mdpi.com/2313-433X/6/8/73)
- [Vision-Based Hand Gesture Recognition System for a Dynamic and Complicated Environment](https://ieeexplore.ieee.org/document/7379635)

The most popular methods that we will test are:
- [yolo v4 tiny](https://arxiv.org/abs/2004.10934)
- [MediaPipe Hands: On-device Real-time Hand Tracking](https://arxiv.org/abs/2006.10214)
- [fast hand detection and gesture recognition](https://ieeexplore.ieee.org/document/7340956/)

All the 3 methods are tested in a general computer machine featuring Intel Core i5-8365U CPU @ 1.60 GHz, 1896 MHz, 4 Core(s). For the testing we used a general webcap with 640x480 resolution. The results can be found below:

| Method      | Fps (min - max) | Implementation/Test | Notes
| ----------- | ----------- | ----------- | ----------- | 
| yolo v4 tiny | 6.5 - 23.9  | Python - Yolo library | Bad timing performance for a fast setup. The neural network used is very expensive. Moreover, the standard tuning is not accurate. |
| MediaPipe Hands: On-device Real-time Hand Tracking | 9 - 26 | Python - Mediapipe library | Good performance on a general CPU. Very accurate detection. The implementation is based on an optimized detection based on hand tracking. Google claims its implementation achieved 95% palm detection accuracy |
| fast hand detection and gesture recognition | TBD | No implementation found. Manually developed in python | TBD
