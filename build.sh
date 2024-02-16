#!/bin/bash

#set -e

K_ROOT_DIR=$(pwd)
KERNEL_DEFCONFIG=alioth_nethunter_defconfig
ANYKERNEL3_DIR=$K_ROOT_DIR/AnyKernel3/
FINAL_KERNEL_ZIP=Bifr0st_Alioth_1.0.zip
export ARCH=arm64

# Speed up build process
MAKE="./makeparallel"

BUILD_START=$(date +"%s")
blue='\033[1;34m'
yellow='\033[1;33m'
nocol='\033[0m'

# Always do clean build lol
echo -e "$yellow**** Cleaning ****$nocol"
mkdir -p out
make O=out clean

echo -e "$yellow**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****$nocol"
echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"
make $KERNEL_DEFCONFIG O=out
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=$K_ROOT_DIR/../../android/toolchains/prebuilts_clang-r445002/bin/clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=$K_ROOT_DIR/../../android/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android- \
                      CROSS_COMPILE_ARM32=$K_ROOT_DIR/../../android/toolchains/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-

echo -e "$yellow**** Verify Image.gz-dtb & dtbo.img ****$nocol"
ls $K_ROOT_DIR/out/arch/arm64/boot/Image.gz-dtb
ls $K_ROOT_DIR/out/arch/arm64/boot/dtbo.img

echo -e "$yellow**** Verifying AnyKernel3 Directory ****$nocol"
ls $ANYKERNEL3_DIR
echo -e "$yellow**** Removing leftovers ****$nocol"
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf $ANYKERNEL3_DIR/dtbo.img
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP

echo -e "$yellow**** Copying Image.gz-dtb & dtbo.img ****$nocol"
cp $K_ROOT_DIR/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL3_DIR/
cp $K_ROOT_DIR/out/arch/arm64/boot/dtbo.img $ANYKERNEL3_DIR/

echo -e "$yellow**** Time to zip up! ****$nocol"
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
cp $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP $K_ROOT_DIR/../../android/$FINAL_KERNEL_ZIP

echo -e "$yellow**** Done, here is your checksum ****$nocol"
cd ..
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf $ANYKERNEL3_DIR/dtbo.img
rm -rf out/

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
sha1sum $K_ROOT_DIR/../../android/$FINAL_KERNEL_ZIP
