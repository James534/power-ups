TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    OpenSpatialServiceController.cpp \
    nodringclass.cpp \
    nodringdelegate.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    OpenSpatialServiceController.h \
    stdafx.h \
    nodringclass.h \
    nodringdelegate.h

CONFIG += console

