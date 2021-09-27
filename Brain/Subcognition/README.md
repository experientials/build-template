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
- [yolo v4 tiny](YOLOv4: Optimal Speed and Accuracy of Object Detection)
- [MediaPipe Hands: On-device Real-time Hand Tracking](https://arxiv.org/abs/2006.10214)
- [fast hand detection and gesture recognition](https://ieeexplore.ieee.org/document/7340956/)

All the 3 methods are tested in a general computer machine featuring Intel Core i5-8365U CPU @ 1.60 GHz, 1896 MHz, 4 Core(s). The results can be found below:

| Method      | Fps (min - max) | Implementation/Test |
| ----------- | ----------- | ----------- |
| yolo v4 tiny | 6.5 - 23.9  | Python - Yolo library |
| MediaPipe Hands: On-device Real-time Hand Tracking | Python - Mediapipe library |
| fast hand detection and gesture recognition | No implementation found. Manually developed in python |
