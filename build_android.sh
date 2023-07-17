#!/bin/bash

export ANDROID_NDK=/opt/android-ndk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export ANDROID_NATIVE_API_LEVEL=33
export STRIP=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip

echo "========== Build All started =========="
echo ""

echo "Preparing working files and directories"

output_folder=build_libs_android-$ANDROID_NATIVE_API_LEVEL 

mkdir -p ${output_folder} # FINAL OUTPUTS ARE COPIED HERE


declare -a AndroidArchitectures=("x86" "x86_64" "arm" "arm64")
# declare -a AndroidArchitectures=("arm")
declare -a iOSArchitectures=("x86_64" "arm64" "arm64e")

LibraryName="OpenCVMobile"
Android_NDK_Host_Name="linux"
Android_NDK_Host_Tag="linux-x86_64"
Android_Minimum_Api_Version=$ANDROID_NATIVE_API_LEVEL
iOS_SDK_Version="12.2"
iOS_SDK_Min_Version="8.0"

## Dynamic or Static library output
## ON = *.so ; OFF = *.a
SET_SHARED=ON

echo ""
echo "=== BUILD TARGET (Android) ==="
echo ""
echo "PWD: ${PWD}"

for i in "${AndroidArchitectures[@]}"
    do
        echo "Build for $i:"

        ABI_Folder_Name=$i

        if [ $i == "arm" ]
        then
            ABI_Folder_Name="armeabi-v7a"
        elif [ $i == "arm64" ]
        then
            ABI_Folder_Name="arm64-v8a"
        fi

        # Temp build folder
        rm -rf _build_android_$ABI_Folder_Name-$ANDROID_NATIVE_API_LEVEL 
        rm -rf CMakeCache.txt
        mkdir -p _build_android_$ABI_Folder_Name-$ANDROID_NATIVE_API_LEVEL 
        cd _build_android_$ABI_Folder_Name-$ANDROID_NATIVE_API_LEVEL 
        
        cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake -DANDROID_USE_LEGACY_TOOLCHAIN_FILE=False \
                -DANDROID_ABI=${ABI_Folder_Name} -DANDROID_ARM_NEON=ON -DANDROID_PLATFORM=android-33 -DANDROID_CPP_FEATURES="no-rtti no-exceptions" \
                -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=${SET_SHARED} `cat ../opencv4_cmake_options.txt` -DBUILD_opencv_world=OFF -DOPENCV_DISABLE_FILESYSTEM_SUPPORT=ON ..

        make -j20

        echo "Copying /lib/$ABI_Folder_Name to ../$output_folder"
        cp -R lib/$ABI_Folder_Name ../$output_folder

    done

cd ..
echo "** BUILD SUCCEEDED (Android) **"
echo ""     

        

# cmake -D CMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
#       -D ANDROID_NDK=${ANDROID_NDK} \
#       -D ANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
#       -D ANDROID_ABI="armeabi-v7a with NEON" \
#       -D BUILD_SHARED_LIBS=ON \
#       -D BUILD_LIST=core,imgproc \
#       ..

# make install
# make clean