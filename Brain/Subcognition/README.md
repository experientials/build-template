# Subcognition

This is a cognitive system that runs by default. It monitors the surrounding environment to identify
the nature of changes. The initial version will be processing camera input to identify movement. It will
also monitor a light sensor to identify dominant color and light level.

If possible it should produces an OS video device that provides a slightly compressed feed which filters out
periods of no activity.

It should be written in Rust if possible, C++ as a secondary choice. It can rely on OpenCV.

Supported camera devices to be considered.
