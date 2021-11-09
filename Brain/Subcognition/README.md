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

### Mediapipe - Tradeoff between performance and FPS

The webcamera used in our experiments has max. resolution of 30 FPS. In the analysis above, we saw that mediapipe can run with lower FPS without an impact in the accuracy. The question here is, what is impact of a lower resolution (= lower FPS) in mediapipe performance? Also, how is it affected by distance? 

| Distance [m] | Camera frame rate [FPS] | mediapipe exec. time [s]
| ----------- | ----------- | ----------- | 
| 0.35 | 2 | 0.034 |
| 0.35 | 5 | 0.031 | 
| 0.35 | 15 | 0.026 |
| 0.35 | 30 | 0.027 |
| 1 | 2 | 0.042 | 
| 1 | 5 | 0.032 | 
| 1 | 15 | 0.033 |
| 1 | 30 | 0.029 |
| 2 | 2 | 0.031 |
| 2 | 5 | 0.031 |
| 2 | 15 | 0.032 |
| 2 | 30 | 0.031 |

**Conclusions:** 
- In a distance smaller than 2 meters, when the camera frame rate is higher, the average execution time is smaller. That can be explained because mediapipe makes more use of the tracking algorithm.
- In a distance bigger than 2 meters, the FPS do not have a big impact on performance. This is probably explained since the hit rate of mediapipe decreases a lot. 

### Test with gloves

As expected, the accuracy of all algorithms is seriously decreased with globes (drops more than 95%). Another algorithm should be researched in case glove detection is desired.

## Boundary box 

### Calculation of box size 

Both the mediapipe and the yolo algorithms result in a boundary box with the detected hand in the center. However, the dimensions do not include the item but only the hands. Assuming that the desired object to be recognised has dimensions similar to the hand (e.g., it's probably a small toy), and in order for the boundary box to include the item, it has to be extended according to the hand size. The formula that is used in our tests:

- boundary box width = original width + (x1-x2)/scale_factor
- boundary box height = original height + (y1-y2)/scale_factor

*Note:* The fast hand detection algorithm failed to accurately detect the hand. That said, it won't be used for hand detection.

### Distinction between hand and object

There are many segmentation algorithms out there that can be used for object segmentation. A nice article is [Image Segmentation using OpenCV](https://nayakpplaban.medium.com/image-segmentation-using-opencv-39013013920a)

We will test the following ones:

- K-Means (Clustering based segmentation)
- Contour Detection (Edge based segmentation)
- Hand colour segmentation (Threshold segmentation using HSV and/or YCrCb mask)

#### Testing

| Method      | Fps (min - max) | Implementation/Test | Notes
| ----------- | ----------- | ----------- | ----------- | 
| K-Means | TBD | Python - OpenCV library | Overall good segmentation, however it fails to accurately detect the hand in some cases. The performance of the algorithm greatly depends on the background. Would consider this algorithm only if there is high contrast between the hand and the object.|
| Contour Detection | TBD | Python - OpenCV library | The edge detection fails in many cases. it cannot accurately detect the boundaries of the object. That said, it blends object and hand many times resulting in a very wrong contour |
| Hand colour | TBD | Python - OpenCV library | The segmentation based on hand colour gives the best results. Even if it's not 100% accurate, it removes only hand pixels. This depends on the colour size, but we don't expect objects with the exact same colour as the hand, otherwise a distinction wouldn't be possible. |

## Gesture recognition

Mediapipe produces the landmarks of the fingers. By analyzing the landmarks (relative) positions it's easy to recognise many gestures. See [concept](https://gist.github.com/TheJLifeX/74958cc59db477a91837244ff598ef4a)

## Surroundings cognition system

The subcognition application should be able to produce some information based on the detected events. 

### Detect number of hands appeared in the scene

Every time that a hand appears we want to say that hand appear, and every time that it goes away we want to say that hand disappeared. From the above analysis, it is obvious that mediapipe algorithm gives the best results. Mediapipe outputs the number of hands detected in a list (measurement is per frame). However, there are some deficiencies that must be tackled:
- Mediapipe sometimes fail to detect the hands. That said, if the camera works at 30 FPS and the hands are not detected in the 5 out of the 30 FPS per second we can't deduct that hands disappeared for 0.17 sec! (**solution: low pass filter**)
- Mediapipe sometimes falsely calculates two hands when only 1 hand is present in the scene. (**solution: filterout the hand centers which are very close together**)
- Hand is occluded due to another item. How do we treat this use case? Do we say that hand disappeared? (motion prediction??)

### Object (in the hand) detection

#### Part 1

After a hand is detected and a user interaction is taking place, the user might show an object in the camera. The question is: Is the user showing an object in the camera? 
If we try to decide whether the user holds and object by distinguishing between an empty and a non-empty hand through image features, we will have to face the following obstacles:
- Reliable distinction between hand and object (not 100% accurate, see above section "Distinction between hand and object")
- Reliable distinction between hand-object item and background (tested different implementation, the contour of the object and the background is not sharpely detected). Those simple background removal algorithms are mostly based on motion. If the hand is not doing any rapid movements, the background cannot be reliably removed. 
- If the above are implemented, we could filter out the hand and the background. The pixels remaining are the ones of the object. But still, how do we know if those pixels depict an item?

Since the target objects to be detected are not very specific, neither is the background static, the above obstacles are really difficult to deal with. This is the reason that we opt for a simpler solution, that is, detection by gesture recognition. When a hand grabs an objects, it has a specific gesture.
- When a user shows an object in the camera, the landmarks of the hand (6, 7, 8, 10, 11, 12, 14, 15 and 16) have specific relative positions.
- All of them have close y coordinates.

When it is detected 1) intended user interaction and 2) hand gesture of holding an object, the algorithm has to take snapshots in order to later train the object detection network.

#### Part 2

The box around the detected object must be defined. The dimension of this box should be derived in one of the following ways:
- Based on the closeness of the hand to the camera (see above), hand landmarks [2-4, 6-8, 10-12, 14-16, 18-20] and handiness (left/right) 
- When an item is hold, the user will use their thumb (unless it is a very akward holding)
- Another idea for the future, is to make a better estimation using a background removal algorithm

#### Part 3

After doing some research on **object detection** algorithms, it was concluded that they are not the ideal choise for our goal. Instead **image classification** may be prefered. Let's revise here the difference between those two:
"... we will be using the term object recognition broadly to encompass both image classification (a task requiring an algorithm to determine what object classes are present in the image) as well as object detection (a task requiring an algorithm to localize all objects present in the image ..." ([Source: ImageNet Large Scale Visual Recognition Challenge](https://arxiv.org/abs/1409.0575))

Some of the most popular image classification algorithms:
- [ResNet50](https://iq.opengenus.org/resnet50-architecture/)
- [MobileNetV2](https://paperswithcode.com/method/mobilenetv2#:~:text=MobileNetV2%20is%20a%20convolutional%20neural,are%20between%20the%20bottleneck%20layers)
- [Volo](https://arxiv.org/abs/2106.13112)
- [EfficientNetB0](https://paperswithcode.com/method/efficientnet#:~:text=EfficientNet%20is%20a%20convolutional%20neural,resolution%20using%20a%20compound%20coefficient.&text=EfficientNet%20uses%20a%20compound%20coefficient%20to%20uniformly%20scales%20network%20width,resolution%20in%20a%20principled%20way)

