QT += widgets qml quick location  # Others usual: 3dinput positioning svg multimedia gamepad
CONFIG += c++17         # C++ Version
CONFIG += qml_debug     # Enable QML console debug
#CONFIG += resources_big # Set this flag if your resources are big and cause a compilation error

VERSION = 1.0.0         # App version as major.minor.patch
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

INCLUDEPATH += include/Core \
               include/DataLayer \
               include/Utils
HEADERS += \
    include/Core/WhereIsMyCarApp.h \
    include/DataLayer/Constants.h \
    include/DataLayer/DataManager.h \
    include/DataLayer/Car.h \
    include/DataLayer/Database.h \
    include/DataLayer/DeviceGeolocation.h \
    include/Utils/QmlObjectListModel.h

SOURCES += \
    src/Core/WhereIsMyCarApp.cpp \
    src/DataLayer/DataManager.cpp \
    src/DataLayer/Car.cpp \
    src/DataLayer/Database.cpp \
    src/DataLayer/DeviceGeolocation.cpp \
    src/Utils/QmlObjectListModel.cc \
    src/main.cpp

OTHER_FILES += \
    qml/main.qml

RESOURCES += \
    where_is_my_car_media.qrc \
    where_is_my_car_qml.qrc

## Add OpenSSL for Android
android: include(../Android-SDK/android_openssl/openssl.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
