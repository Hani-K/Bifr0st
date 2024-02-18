# Bifr0st Kernel
A customized kernel for Alioth devices with NetHunter support.

## How to compile

You need to get the toolchains used to compile the kernel.
The Kernel was compiled using [clang-r445002](https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/5642ce999b98ff59fdc99b013b60f09f73a50864), [aarch64-linux-android-4.9](https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+/357ead66eff30a77b2b752595d4df09fb56e23f0) and [arm-linux-androideabi-4.9](https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+/e9b2ab0932573a0ca90cad11ab75d9619f19c458/).

Once you get these toolchains downloaded,

Clone the repo
```
git clone https://github.com/Hani-K/Bifr0st.git
cd Bifr0st
```

Now you need to pull the latest version of KernelSU as it is required to compile the kernel.
```
rm -r KernelSU
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
```

Now edit the build.sh file according to the location of your toolchains, then build.
```
./build.sh
```

