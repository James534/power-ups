#ifndef NODRINGDELEGATE_H
#define NODRINGDELEGATE_H
#include "OpenSpatialServiceController.h"
#include <QObject>



class QElapsedTimer;
class QTimer;

class NodRingDelegate: public QObject, public OpenSpatialDelegate
{
    Q_OBJECT

public:
    NodRingDelegate();
    ~NodRingDelegate();
    virtual void pointerEventFired(PointerEvent event);
    virtual void gestureEventFired(GestureEvent event);
    virtual void pose6DEventFired(Pose6DEvent event);
    virtual void buttonEventFired(ButtonEvent event);


public slots:
    void onTimeoutAfterGesture();
    bool getEnableMove(){ return m_bEnableMove; }
    void setEnableMove(bool value);

signals:
    void enableMoveChanged();

private:
    bool m_bRightTapState;
    bool m_bLeftTapState;
   bool m_bEnableMove;
    int m_positionCounter;
    bool m_initiatePostionFlag;
    //QTimer *timer;
    QElapsedTimer *timer;
    float horizontalOffset;


signals:
    void positionChanged(QString action);



};

#endif // NODRINGDELEGATE_H
