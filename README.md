# x1q-kernelsu-next
KernelSU Next integration for the Samsung Galaxy S20 Snapdragon variant (x1q).

This kernel was built for the `SM-G981N` (Korean variant), with firmware `G981NKSS8IYC2`.

<img src="https://i.imgur.com/LJWzWd3.jpeg" width="300" />

# How to install

Flash the latest `x1q_ksunext.zip` from the release page with TWRP or from the KernelSU Manager app.

# How to build
This repo was tested on Ubuntu 22.04 LTS (Jammy Jellyfish).

## Install the dependencies

```sh
sudo apt install -y build-essential libncurses5 libncurses5-dev flex bison libssl-dev \
zlib1g-dev lz4 cpio git wget bc python2 python3 openssh-client android-tools-mkbootimg p7zip-full
```

## Clone the repo

```sh
git clone --recursive https://github.com/postkevone/x1q-kernelsu-next.git
cd x1q-kernelsu-next
```

## Set python2 as default
```sh
sudo ln -sf python2 /usr/bin/python
```
## Run the build script
```sh
./build_kernel.sh
```
# Credits
[GoRhanHee](https://github.com/GoRhanHee/kernel_samsung_sm8250/issues/3)

![KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next/tree/legacy)

![WildKernels](https://github.com/WildKernels/kernel_patches/tree/main/next)
