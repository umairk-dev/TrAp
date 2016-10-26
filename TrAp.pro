TEMPLATE = app

QT += qml quick widgets sql core charts
CONFIG += c++11

SOURCES += main.cpp \
    controls.cpp \
    cyclonetrack.cpp \
    cyclone.cpp \
    utils.cpp \
    dbmanager.cpp \
    prediction.cpp \
    settings.cpp \
    dbupdate.cpp \
    predictionthread.cpp \
    ella.cpp \
    UpdateThread.cpp \
    model.cpp \
    variable.cpp

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
    .gitignore \
    TrAp.pro.user.tP1924 \
    README.md \
    android/gradle.properties \
    android/local.properties

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    controls.h \
    cyclonetrack.h \
    cyclone.h \
    utils.h \
    dbmanager.h \
    prediction.h \
    settings.h \
    dbupdate.h \
    predictionthread.h \
    ella.h \
    UpdateThread.h \
    model.h \
    variable.h \
    Rmath.h


INCLUDEPATH += $$PWD/.
DEPENDPATH += $$PWD/.
