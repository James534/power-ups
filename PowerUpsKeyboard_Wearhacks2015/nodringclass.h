#ifndef NODRINGCLASS_H
#define NODRINGCLASS_H
#include <QObject>
#include "OpenSpatialServiceController.h"
#include "nodringdelegate.h"

class OpenSpatialServiceController;
class OpenSpatialDelegate;
class NodRingDelegate;

class NodRingClass: public QObject
{
    Q_OBJECT
public:
    NodRingClass();
    NodRingClass(std::string controllerName);
    bool m_bRightTapState;
    bool m_bLeftTapState;

signals:
    void positionChanged(QString action);
    void rightTapStateChanged(bool tapState);
    void enableMovedChanged();


public slots:
    void calibrate();
    bool getEnableMove();
    void setEnableMove(bool value);

private:
    OpenSpatialServiceController *m_pNodController;
    NodRingDelegate * m_pNodDelegate;
    std::string name;
};

#endif // NODRINGCLASS_H
