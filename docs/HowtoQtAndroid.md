# How to deploy an Qt Application for Android

## Pre-requisites 
Start installing all the Prerequisites for your Host OS. Used references: https://doc.qt.io/qt-5/android-getting-started.html, https://doc.qt.io/qtcreator/creator-developing-android.html and https://doc.qt.io/qt-5/examples-android.html

* Java Develop Kit: JDK 11 (LTS). Extract and save where you wish. In my case and to use it as example, the path is: /home/ricardo/Libraries/jdk-11.0.13+8
    
    Open QtCreator and go to Tools -> Options -> Android. By default, it is set to /usr/lib/jvm/java-11-openjdk-amd64/ but it probably presents some errors. Select your path, in my case /home/ricardo/Libraries/jdk-11.0.13+8, and the errors should disappear.


* APK builder: Gradel. It will be installed together with the Android SDK

* Android SDK: Android Studio. Extract and save where you wish. In my case: /home/ricardo/Libraries/android-studio

    Open QtCreator and select again Tools -> Options -> Android. By default, it is /home/ricardo/Android/Sdk but it should present errors due to this path is wrong. To fix it, create the folder where you want to install the Android SDK, in my case /home/ricardo/Libraries/Android-SDK, select it and press the button "Set Up SDK". Follow the automatic procedure to install all the required packages.

* OpenSSL for Android. Again, go to Tools -> Options -> Android and press the button "Download OpenSSL".

* Android NDK. It can be installed using the SDK Manager on QtCreator Tools -> Options -> Android

All the errors should have disappeared on the tab Tools -> Options -> Android of QtCreator.

Finally, some Android SDK Essential packages must be installed executing:

```bash
cd <ANDROID_SDK_ROOT>/tools/bin/
./sdkmanager --sdk_root=<ANDROID_SDK_ROOT> --install "cmdline-tools;latest"
./sdkmanager --sdk_root=<ANDROID_SDK_ROOT> --install "platform-tools" "platforms;android-29" "build-tools;29.0.2" "ndk;21.3.6528147"
./sdkmanager --sdk_root=<ANDROID_SDK_ROOT> --install "emulator" "patcher;v4"
```
In my case, <ANDROID_SDK_ROOT> is replaced by /home/ricardo/Libraries/Android-SDK

In case of running on a Linux 64 bits, install also the following packages:

```bash
sudo apt-get install libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386
sudo apt-get install libsdl1.2debian:i386
```

## Qt Creator Kit

It is necessary install the Android Kit for Qt. If you didn't do it before, use the Maintenance Tool to get it for your Qt Version. In my case, I am using Qt 5.15.2, and the installed Kit is Android Qt 5.15.2 Clang Multi-Abi. That means this kit is able to compile the project for arm64-v8a, armeabi-v7a, x86 and x86_64. Don't forget to set the desired architecture when configure your project on the Build Settings -> Build Steps -> qmake (Details) -> ABIs. **Otherwise, the program will fail when you try to run it**.

## Adding Android Virtual Devices (AVD)

The available AVDs are listed in Tools -> Options -> Devices. It's possible that you need to restart QtCreator after install Android SDK and before to be able to add an AVD. 

To add a new one, press the Add button and select Android Devices and select your target emulator device.

It is also possible you need to install some images using the SDK Manager at Tools -> Options -> Android -> SDK Manager. For example, for Android 11, install the ARM 64 v8a and the Intel x86 Atom_64 system images.

Ref: https://doc.qt.io/qtcreator/creator-developing-android.html

## Compiling and running on the emulator

First, let's test with a QtCreator example. Go to QtCreator -> Examples and select the Example Analog Clock for Qt 5.15.2 for Android. Configure the project for your Android kit. In case of Multi-ABI, don't forget to set your target architecture on Project -> Build Settings -> Build Steps -> qmake (Details) -> ABIs. In this case, I have created a x86 emulator, so I select x86 in the field ABIs. Press the hammer to compile and press the play button, the Android Emulator should be openned and your app should start.

Later, repeat the process with this application. Notice it uses the online OpenStreetMap, so it needs you have installed OpenSSL for Android as it's explained in the previous sections.
