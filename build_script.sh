#!/bin/bash

echo "========== Build All started =========="
echo ""

echo "Preparing working files and directories"

output_folder=build_x64

mkdir -p ${output_folder} # FINAL OUTPUTS ARE COPIED HERE

## Dynamic or Static library output
## ON = *.so ; OFF = *.a
SET_SHARED=OFF

echo ""
echo "=== BUILD TARGET (x64) ==="
echo ""
echo "PWD: ${PWD}"

rm -rf CMakeCache.txt

cd ${output_folder}

echo "Build for x64:"

echo "PWD: ${PWD}"

#cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DENABLE_PIC=TRUE -DANDROID_USE_LEGACY_TOOLCHAIN_FILE=False \
#        -DANDROID_STL=c++_static -DANDROID_ABI=${ABI_Folder_Name} -DANDROID_ARM_NEON=ON -DANDROID_PLATFORM=android-33 -DANDROID_CPP_FEATURES="no-rtti no-exceptions" \
#        -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=${SET_SHARED} `cat ../opencv4_cmake_options.txt` -DBUILD_opencv_world=OFF -DOPENCV_DISABLE_FILESYSTEM_SUPPORT=ON ..

#cmake -DENABLE_PIC=TRUE -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=${SET_SHARED} `cat ../opencv4_cmake_options.txt` -DBUILD_opencv_world=OFF -DOPENCV_DISABLE_FILESYSTEM_SUPPORT=OFF ..
#cmake -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=${SET_SHARED} `cat ../opencv4_cmake_options.txt` -DBUILD_opencv_world=OFF -DOPENCV_DISABLE_FILESYSTEM_SUPPORT=OFF ..
cmake -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF `cat ../opencv4_cmake_options.txt` -DBUILD_opencv_world=OFF ..

make -j20

echo "Copying /lib/ABI_Folder_Name to ../$output_folder"
#cp -R lib/ ../$output_folder


echo "** BUILD SUCCEEDED (x64) **"
echo ""
