cmake_minimum_required (VERSION 3.10)

#-------------------------------------------------------------------------------
# Project Settings Section
#-------------------------------------------------------------------------------

# Name our project
project(hello-world-openCV VERSION 0.1
        DESCRIPTION "Subcognition for Brain project - AArch64"
        LANGUAGES CXX)

SET(BUILD_ROOT "./build")
get_filename_component(SRC_ROOT ${BUILD_ROOT}/../../src ABSOLUTE)
#get_filename_component(ABSOLUTE_PATH_BUILD_ROOT ${BUILD_ROOT} ABSOLUTE)

#-------------------------------------------------------------------------------
# Make File Settings Section
#-------------------------------------------------------------------------------

# set environment
SET(CMAKE_VERBOSE_MAKEFILE on)
SET(CMAKE_COLOR_MAKEFILE on)
# check for errors
set(CMAKE_FIND_DEBUG_MODE 1)

SET(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_FIND_DEBUG_MODE 1)


#-------------------------------------------------------------------------------
# Compiler Settings Section
#-------------------------------------------------------------------------------

#---- Common settings for all builds -------------------------------------------
# Compiler Settings
SET(COPTS "${COPTS} -std=c++11")
SET(COPTS "${COPTS} -Wall")

#SET(COPTS "${COPTS} -print-search-dirs")

#SET(COPTS "${COPTS} --target=arm-arm-none-eabi")
#SET(COPTS "${COPTS} -mcpu=cortex-m3")

# Compile-time Definitions
SET(CDEFINES "${CDEFINES} -D__FILENAME__=\"$\(<F\)\"")

# Combine all common Compiler settings for C and C++ compiler
SET(CMAKE_C_FLAGS "${COPTS} ${CDEFINES}")
SET(CMAKE_CXX_FLAGS "${COPTS} ${CDEFINES}")


#-------------------------------------------------------------------------------
# Linker Settings Section
#-------------------------------------------------------------------------------

#set(CMAKE_EXE_LINKER_FLAGS "-static")

#-------------------------------------------------------------------------------
# Source Settings Section
#-------------------------------------------------------------------------------

# list files to compile
set(hello_SRC
  # new file structure
${SRC_ROOT}/hello.cpp
${SRC_ROOT}/main.cpp
)

# all src files in a single variable
FILE(GLOB SRC_FILES ../src/*.cpp)


#-------------------------------------------------------------------------------
# Include directories
#-------------------------------------------------------------------------------

# Include OpenCV header files
#target_include_directories(${PROJECT_NAME} PUBLIC /home/alyr/opt/opencv/3rd_party_libs/opencv/build_aarch64/install_aarch64/usr/local/include/opencv4)
#set(OpenCV_DIR "/home/alyr/opt/opencv/3rd_party_libs/opencv/build_aarch64/install_aarch64/usr/local/lib/cmake/opencv4")
#set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules)
set(OpenCV_STATIC ON)
#set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_STATIC_LIBRARY_SUFFIX})
find_package(OpenCV REQUIRED)

#include_directories(${OpenCV_INCLUDE_DIRS}) # not needed for opencv>=4.0
include_directories(${OpenCV_INCLUDE_DIRS})

#-------------------------------------------------------------------------------
# Executable Settings section
#-------------------------------------------------------------------------------

add_executable(${PROJECT_NAME} ${hello_SRC})

#-------------------------------------------------------------------------------
# Library
#-------------------------------------------------------------------------------

# Link the pre-compiled libraries to the executable we just declared 
#set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
#set(BUILD_SHARED_LIBS OFF)

# all src files in a single variable
#FILE(GLOB AARCH64_LINUX_LIBS /usr/aarch64-linux-gnu/lib/*.a)

#set(dc1394_LIBS "/usr/lib/x86_64-linux-gnu/libdc1394.so")

#target_link_directories(${PROJECT_NAME} PUBLIC ~/opt/opencv/3rd_party_libs/opencv/build_aarch64/install_aarch64/usr/local)
# target_link_libraries (${PROJECT_NAME} *.a)
# target_link_libraries (${PROJECT_NAME} PUBLIC ${AARCH64_LINUX_LIBS})
target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS})