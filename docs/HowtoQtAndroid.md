# How to deploy a Qt Application for Android

## Pre-requisites 
Start installing all the Prerequisites for your Host OS. It is explained in the following point, but all of these steps were extracted from the following references: https://doc.qt.io/qt-5/android-getting-started.html, https://doc.qt.io/qtcreator/creator-developing-android.html and https://doc.qt.io/qt-5/examples-android.html

* Java Develop Kit: JDK 11 (LTS). Extract and save where you wish. In my case and to use it as example, the path is: `~/Libraries/jdk-11.0.13+8`.
    
    Open QtCreator and go to `Tools -> Options -> Devices -> Android`. By default, it is set to `/usr/lib/jvm/java-11-openjdk-amd64/` but it probable that your current version presents some errors. Select your path, in my case `/home/ricardo/Libraries/jdk-11.0.13+8`, and the errors should disappear.

* APK builder: Gradel. It will be installed together with the Android SDK

* Android SDK: Android Studio. Extract and save where you wish. In my case: `~/Libraries/android-studio`.

    Open QtCreator and select again `Tools -> Options -> Devices -> Android`. By default, it is `~/Android/Sdk` but it could present errors due to this path is wrong. To fix it, create the folder where you want to install the Android SDK, in my case `~/Libraries/Android-SDK`, select it and press the button `Set Up SDK`. Follow the automatic procedure to install all the required packages.

* OpenSSL for Android. Again, go to `Tools -> Options -> Devices -> Android` and press the button `Download OpenSSL`. Continuing with my case as example, this path is: `~/Libraries/Android-SDK/android_openssl`. In this case, this path is also important from the point of view of the [Qt Project file](../where_is_my_car.pro), because it is including a file at this path:

    ```bash
    ## Add OpenSSL for Android
    android: include(../Android-SDK/android_openssl/openssl.pri)
    ```

    Modify it in case you are using any other OpenSSL path.

* Android NDK. It can be also installed using the SDK Manager on QtCreator `Tools -> Options -> Devices -> Android`.

Once you installed all of the previous modules, all the error markers should disappear in that windows `Tools -> Options -> Devices -> Android` of QtCreator.

Finally, some Android SDK Essential packages must be installed executing:

```bash
cd <ANDROID_SDK_ROOT>/tools/bin/
./sdkmanager --sdk_root=<ANDROID_SDK_ROOT> --install "cmdline-tools;latest"
./sdkmanager --sdk_root=<ANDROID_SDK_ROOT> --install "platform-tools" "platforms;android-29" "build-tools;29.0.2" "ndk;21.3.6528147"
./sdkmanager --sdk_root=<ANDROID_SDK_ROOT> --install "emulator" "patcher;v4"
```
Replace `<ANDROID_SDK_ROOT>`  by the path to the folder `Android-SDK`, in my case `~/Libraries/Android-SDK`.

In case of running on a Linux 64 bits, install also the following packages:

```bash
sudo apt-get install libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386
sudo apt-get install libsdl1.2debian:i386
```

## Qt Creator Kit

It is necessary install the Android Kit for Qt. If you didn't do it before, use the Maintenance Tool to get it for your Qt Version. In my case, I am using Qt 5.15.2, and the installed Kit is Android Qt 5.15.2 Clang Multi-Abi. That means this kit is able to compile the project for arm64-v8a, armeabi-v7a, x86 and x86_64. Don't forget to set the desired architecture when configure your project on `Projects -> Build Settings -> Build Steps -> qmake (Details) -> ABIs`. **Otherwise, the program will fail when you try to run it**.

## Adding Android Virtual Devices (AVD)

The available AVDs are listed in `Tools -> Options -> Devices -> Devices`. It's possible that you need to restart QtCreator after install Android SDK and before to be able to add an AVD. 

To add a new one, press the Add button and select Android Devices and select your target emulator device.

It is also possible you need to install some images using the SDK Manager at `Tools -> Options -> Devices -> Android -> SDK Manager`. For example, for Android 11, install the ARM 64 v8a and the Intel x86 Atom_64 system images.

Ref: https://doc.qt.io/qtcreator/creator-developing-android.html#managing-android-virtual-devices-avd

## Compiling and running on the emulator

First, let's test with a QtCreator example. Go to `QtCreator -> Examples` and select the Example `Analog Clock` for Qt 5.15.2 for Android. Configure the project for your Android kit. In case of Multi-ABI, don't forget to set your target architecture on `Projects -> <Android Qt Kit> -> Build -> Build Steps -> qmake (Details) -> ABIs`. In this case, I have created a x86 emulator, so I select x86 in the field ABIs. Press the hammer to compile and press the play button, the Android Emulator should be opened and your app should start.

Later, repeat the process with this application. Notice it uses the online OpenStreetMap, so it needs you have installed OpenSSL for Android as it's explained in the previous sections.

## Compiling and running on a real device

First, follow the next steps in the Android device:

* Connect the device to the developing PC and set the mode File Transfer.
* Enable USB Debugging on the device Developer Settings and accept any prompt.

Then, on QtCreator you should now be able to select your Android device on the left-bottom corner (the button above the play button) in the Device drop-down. Select it, build and run your app.

## Generating the APK

Qt for Android has binaries for armv7a, arm64-v8a, x86, and x86-64. To support several different ABIs in your application, build an AAB that contains binaries for each of the ABIs. The Google Play store uses the AAB to generate optimized APK packages for the devices issuing the download request and automatically signs them with your publisher key.

So, if you are going to generate an AAB package (in other words, an APK for every ABI) make sure first you are building the project for every ABI. To do it, go to `Projects -> <Android Qt Kit> -> Build -> Build Steps -> qmake (Details) -> ABIs` and select all of them. Later, go to `Projects -> <Android Qt Kit> -> Build -> Build Steps -> Build Android APK (Details)` and select the checkbox `Build Android App Bundle` and `Open package location after build`, so we can get this AAB package. As you can see, the generated APKs and AABs are placed inside the Qt Build folder of the project at `android-build/build/outputs`.

In case you are using OpenSSL, like it is the case of the where-is-my-car app, make sure you also check the option to include it in the APK.

At this point, we already have the ABB package. Before install it in our device, let's config Qt to uninstall any previous version before install it. Go to `Project -> <Android Qt Kit> -> Run -> Deploy to Android Device` and check the option `Uninstall the existing app` before deployment.

Ref: https://doc.qt.io/qtcreator/creator-deploying-android.html#packaging-applications

## Installing the APK

To install the APK in the emulator or in your device (it only depends on which one you have selected as Device), simply go to `Projects -> <Android Qt Kit> -> Run -> Deploy to Android Device` and press the button `Install an APK file`. Then, navigate to `android-build/build/outputs/apk` and select the generated APK file. 

## Android Manifest

To be able to set, among others, the app name, it is necessary that your project contains an Android Manifest file. To create one, you can use the Qt Android Manifest Editor: Projects -> <Android Qt Kit> -> Build -> Build Android APK (Details) -> Create Templates.

Ref: https://doc.qt.io/qtcreator/creator-deploying-android.html#android-manifest-editor 