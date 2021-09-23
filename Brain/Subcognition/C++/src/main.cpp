#include <iostream>
#include "hello.h"
#include <memory>
#include <string>
#include <vector>

int main(int argc, char const* argv[]) {
    std::cout << "Hello world. My name is Alex." <<
              "\n";

    // Execute smoke tests with image and video files
    execute_smoke_test();
    execute_blur_filter();
    test_camera();

    /* code */
    return 0;
}

