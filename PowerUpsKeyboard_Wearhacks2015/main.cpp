#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "nodringclass.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;


    //Initialize
    NodRingClass *nodRingControllerRight = new NodRingClass("nod-411");
    //NodRingClass *nodRingControllerLeft = new NodRingClass("")

    engine.rootContext()->setContextProperty("nodRingControllerRight", nodRingControllerRight);
    //engine.rootContext()->setContextProperty("nodRingControllerLeft", nodRingControllerLeft)


    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));



    return app.exec();
}
