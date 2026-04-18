#!/bin/bash

# Copy the defconfig
cp -f kernelsu-defconfig/x1q_kor_singlex_defconfig arch/arm64/configs/vendor/x1q_kor_singlex_defconfig

# Copy the patches
cp -rf kernelsu-patches/. .

# Add KernelSU Next legacy branch
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s legacy

# FIX FOR MISSING strscpy_pad FUNCTION
echo "Patching KernelSU compat header to use standard strscpy..."
sed -i 's/return strscpy_pad(dest, src, count);/return strscpy(dest, src, count);/g' drivers/kernelsu/compat/kernel_compat.h

export ARCH=arm64
# Added -p so the script doesn't throw an error if the directory already exists on rebuilds
mkdir -p out

BUILD_CROSS_COMPILE=$(pwd)/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
KERNEL_LLVM_BIN=$(pwd)/toolchain/llvm-arm-toolchain-ship/10.0/bin/clang
CLANG_TRIPLE=aarch64-linux-gnu-
KERNEL_MAKE_ENV="DTC_EXT=$(pwd)/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"

echo "Running defconfig..."
if ! make -j16 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE vendor/x1q_kor_singlex_defconfig; then
    echo "Error: defconfig failed! Aborting build."
    exit 1
fi

echo "Compiling the kernel..."
if ! make -j16 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE; then
    echo "Error: Kernel compilation failed! Aborting build."
    exit 1
fi

echo "Compilation successful. Packaging AnyKernel zip..."

# Build the anykernel flashable zip
cp out/arch/arm64/boot/Image $(pwd)/anykernel
cd anykernel && 7z a -tzip ../x1q_ksunext.zip . && cd ..

if [ -f "x1q_ksunext.zip" ]; then
    echo "Flashable zip file created at: $(pwd)/x1q_ksunext.zip"
else
    echo "Error: Zip file was not found!"
fi
