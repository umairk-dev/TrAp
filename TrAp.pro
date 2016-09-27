TEMPLATE = app

QT += qml quick webview widgets sql core charts
CONFIG += c++11

SOURCES += main.cpp \
    controls.cpp \
    cyclonetrack.cpp \
    cyclone.cpp \
    utils.cpp \
    dbmanager.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    .gitignore

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    controls.h \
    cyclonetrack.h \
    cyclone.h \
    utils.h \
    dbmanager.h
