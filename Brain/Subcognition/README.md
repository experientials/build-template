# Subcognition

## Description	

This is a cognitive system that runs by default. It monitors the surrounding environment to identify
the nature of changes. The initial version will be processing camera input to identify movement. It will
also monitor a light sensor to identify dominant color and light level.

If possible it should produces an OS video device that provides a slightly compressed feed which filters out
periods of no activity.

It should be written in Rust if possible, C++ as a secondary choice. It can rely on OpenCV.

Supported camera devices to be considered.

# Hand detection

## Research on hand detection algorithms

There are many research papers that published hand detection techniques over the years. Two of those give a nice overview of the most popular techniques:
- [Hand Gesture Recognition Based on Computer Vision: A Review of Techniques](https://www.mdpi.com/2313-433X/6/8/73)
- [Vision-Based Hand Gesture Recognition System for a Dynamic and Complicated Environment](https://ieeexplore.ieee.org/document/7379635)

## Testing

The most popular methods that we will test are:
- [yolo v4 tiny](https://arxiv.org/abs/2004.10934)
- [MediaPipe Hands: On-device Real-time Hand Tracking](https://arxiv.org/abs/2006.10214)
- [fast hand detection and gesture recognition](https://ieeexplore.ieee.org/document/7340956/)

All the 3 methods are tested in a general computer machine featuring Intel Core i5-8365U CPU @ 1.60 GHz, 1896 MHz, 4 Core(s). For the testing we used a general webcap with 640x480 resolution. The results can be found below:

| Method      | Fps (min - max) | Implementation/Test | Notes
| ----------- | ----------- | ----------- | ----------- | 
| yolo v4 tiny | 13 - 95 (size = 150) | Python - Yolo library | Medium timing performance for a fast setup. The largest the size, the highest the accuracy of this method. However, even if we set a very big size (e.g., 500), the accuracy is not dramatically improved. This doesn't use a tracking algorithm like the mediapipe algorithm. |
| MediaPipe Hands: On-device Real-time Hand Tracking | 11 - 86 | Python - Mediapipe library | Good performance on a general CPU. Very accurate detection. The implementation is based on hand tracking (besides palm and finger detection). Google claims their implementation achieves 95% palm detection accuracy |
| fast hand detection and gesture recognition | 35 - 1100 | No implementation found. Manually developed in python | In general it can detect skin but with outliers (even after background removal algorithms). This is because the background subtraction doesn't work well when the hand is very close to the camera. Also, hasn't found a way yet to distinguish between face and hands.

### Test with only 4 FPS

The above 3 methods were tested with 4 FPS video. The main observation is that all algorithms exhibit almost the same behaviour and results. Regarding mediapipe, it may lose tracking more often if the human movement is very rapid, which is not our usual use case. If mediapipe loses tracking it will re-initialize hand detection without taking advantage of its tracking algorithm.

Observation: Perhaps we can even go as low as 2 FPS. Since this doesn't affect algorithm accuracy and an intended interaction shouldn't take less than 1 sec.

### Test with gloves

As expected, the accuracy of all algorithms is seriously decreased with globes (drops more than 95%). Another algorithm should be researched in case glove detection is desired.

## Boundary box 

### Calculation of box size 

Both the mediapipe and the yolo algorithms result in a boundary box with the detected hand in the center. However, the dimensions do not include the item but only the hands. Assuming that the desired object to be recognised has dimensions similar to the hand (e.g., it's probably a small toy), and in order for the boundary box to include the item, it has to be extended according to the hand size. The formula that is used in our tests:

- diagonal = square(x1-x2)^2 + (y1-y2)^2)
- boundary box width = original width + diagonal/scale_factor
- boundary box height = original height + diagonal/scale_factor

*Note:* The fast hand detection algorithm failed to accurately detect the hand. That said, it won't be used for hand detection.

### Distinction between hand and object

There are many segmentation algorithms out there that can be used for object segmentation. A nice article is [Image Segmentation using OpenCV](https://nayakpplaban.medium.com/image-segmentation-using-opencv-39013013920a)

We will test the following ones:

- K-Means (Clustering Based Segmentation)
- Contour Detection (Edge based segmentation)
- Simple segmentation based on colour 
- 

#### Testing

| Method      | Fps (min - max) | Implementation/Test | Notes
| ----------- | ----------- | ----------- | ----------- | 
| K-Means | TBD | Python - OpenCV library | Overall good segmentation, however it fails to accurately detect the hand in some cases. The performance of the algorithm greatly depends on the background. Would consider this algorithm only if there is high contrast between the hand and the object.|
| Contour Detection | TBD | Python - OpenCV library | The edge detection fails in many cases. it cannot accurately detect the boundaries of the object. That said, it blends object and hand many times resulting in a very wrong contour |


