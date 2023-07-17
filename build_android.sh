#!/bin/bash

export ANDROID_NDK=/opt/android-ndk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NATIVE_API_LEVEL=33
export STRIP=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip

echo "========== Build All started =========="
echo ""

echo "Preparing working files and directories"

rm -rf build_android
rm -rf CMakeCache.txt
mkdir -p build_android
cd build_android

declare -a AndroidArchitectures=("x86" "x86_64" "arm" "arm64")
declare -a iOSArchitectures=("x86_64" "arm64" "arm64e")

LibraryName="OpenCVMobile"
Android_NDK_Host_Name="linux"
Android_NDK_Host_Tag="linux-x86_64"
Android_Minimum_Api_Version="33"
iOS_SDK_Version="12.2"
iOS_SDK_Min_Version="8.0"

echo ""
echo "=== BUILD TARGET (Android) ==="
echo ""
echo "PWD: ${PWD}"

# cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local 

# cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang++ -DANDROID_ABI=arm64-v8a -D CMAKE_BUILD_TYPE=Release -D ANDROID_NATIVE_API_LEVEL=33 -D WITH_CUDA=OFF -D WITH_MATLAB=OFF -D BUILD_ANDROID_EXAMPLES=OFF -D BUILD_DOCS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_TESTS=OFF -D ANDROID_STL=c++_shared -D BUILD_SHARED_LIBS=ON -D BUILD_opencv_objdetect=OFF -D BUILD_opencv_video=OFF -D BUILD_opencv_videoio=OFF -D BUILD_opencv_features2d=OFF -D BUILD_opencv_flann=OFF -D BUILD_opencv_highgui=ON -D BUILD_opencv_ml=ON -D BUILD_opencv_photo=OFF -D BUILD_opencv_python=OFF -D BUILD_opencv_shape=OFF -D BUILD_opencv_stitching=OFF -D BUILD_opencv_superres=OFF -D BUILD_opencv_ts=OFF -D BUILD_opencv_videostab=OFF -DBUILD_ANDROID_PROJECTS=OFF ..

# cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_TOOLCHAIN=clang++ \
#     -DBUILD_LIST=core,imgproc -DCMAKE_INSTALL_PREFIX=install \
#     -DCMAKE_BUILD_TYPE=Release \
#     `cat ../../opencv-mobile/opencv4_cmake_options.txt` \
#     -DBUILD_opencv_world=OFF ..

# cat ../../opencv-mobile/opencv4_cmake_options.txt

cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_USE_LEGACY_TOOLCHAIN_FILE=False \
        -DANDROID_ABI="armeabi-v7a" -DANDROID_ARM_NEON=ON -DANDROID_PLATFORM=android-33 -DANDROID_CPP_FEATURES="no-rtti no-exceptions" \
        -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release `cat ../../opencv-mobile/opencv4_cmake_options.txt` -DBUILD_opencv_world=OFF -DOPENCV_DISABLE_FILESYSTEM_SUPPORT=ON ..
        

# cmake -D CMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
#       -D ANDROID_NDK=${ANDROID_NDK} \
#       -D ANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
#       -D ANDROID_ABI="armeabi-v7a with NEON" \
#       -D BUILD_SHARED_LIBS=ON \
#       -D BUILD_LIST=core,imgproc \
#       ..

make -j20
# make install
# make clean