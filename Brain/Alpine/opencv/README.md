# Setup dependencies for openCV 4.5.3

* Install the following packages:
``` 
apk update && apk upgrade && apk --no-cache add \
  bash \
  build-base \
  ca-certificates \
  clang-dev \
  clang \
  cmake \
  coreutils \
  curl \ 
  freetype-dev \
  ffmpeg-dev \
  ffmpeg-libs \
  gcc \
  g++ \
  git \
  gettext \
  lcms2-dev \
  libavc1394-dev \
  libc-dev \
  libffi-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libressl-dev \
  libtbb@edgetest \
  libtbb-dev@edgetest \
  libwebp-dev \
  linux-headers \
  make \
  musl \
  openblas@edgecomm \
  openblas-dev@edgecomm \
  openjpeg-dev \
  openssl \
  python3 \
  python3-dev \
  tiff-dev \
  unzip \
  zlib-dev \
  opj_decompress 
```
  
* Run `/usr/local/bin/pip3 install --upgrade pip` to upgrade pip
* Make a symbolic link for locale header `ln -s /usr/include/locale.h /usr/include/xlocale.h`
* Install numby `/usr/local/bin/pip3 install numpy`
* The int64_t is redefined in the modules. Comment out line#21 of `/opt/opencv_contrib-4.5.3/modules/wechat_qrcode/src/zxing/common/bitarray.cpp` (there is a typedef definition there)
* Install OpenCV by running:
```
  cd /opt && \
  wget https://github.com/opencv/opencv/archive/4.5.3.zip && \
  unzip 4.5.3.zip && rm 4.5.3.zip && \
  wget https://github.com/opencv/opencv_contrib/archive/4.5.3.zip && \
  unzip 4.5.3.zip && rm 4.5.3.zip \
  && \
  cd /opt/opencv-4.5.3 && mkdir build && cd build && \
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_C_COMPILER=/usr/bin/clang \
    -D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D INSTALL_C_EXAMPLES=OFF \
    -D WITH_FFMPEG=ON \
    -D WITH_TBB=ON \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-4.5.3/modules \
    -D PYTHON_EXECUTABLE=/usr/local/bin/python \
    .. \
  && \
  make -j$(nproc) && make install && cd .. && rm -rf build
```
