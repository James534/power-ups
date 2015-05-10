#include "nodringclass.h"
#include "OpenSpatialServiceController.h"
#include "nodringdelegate.h"

NodRingClass::NodRingClass()
{
    //Initialize controller
    m_pNodController = new OpenSpatialServiceController;

    //set delegate
    m_pNodDelegate = new NodRingDelegate;
    m_pNodController->setDelegate(m_pNodDelegate);

    //subscribe
    m_pNodController->subscribeToPointer(m_pNodController->names.at(0));

}

NodRingClass::NodRingClass(std::string controllerName){

    name = controllerName;

    //Initialize controller
    m_pNodController = new OpenSpatialServiceController;

    //set delegate
    m_pNodDelegate = new NodRingDelegate;

    m_pNodController->setDelegate(m_pNodDelegate);

    //subscribe
     //m_pNodController->subscribeToGesture(controllerName);
    m_pNodController->subscribeToPointer(controllerName);
    m_pNodController->subscribeToButton(controllerName);

    //m_pNodController->setMode(name, MODE_TTM);

    m_bRightTapState = false;
    m_bLeftTapState = false;

    connect(m_pNodDelegate, SIGNAL(positionChanged(QString)), this, SIGNAL(positionChanged(QString)));
    connect(m_pNodDelegate, SIGNAL(enableMoveChanged()), this, SIGNAL(enableMovedChanged()));

}

void NodRingClass::setEnableMove(bool value){
    m_pNodDelegate->setEnableMove(value);
}

void NodRingClass::calibrate(){
    m_pNodController->recalibrate(name);
}

bool NodRingClass::getEnableMove(){
    bool result = m_pNodDelegate->getEnableMove();
    return result;
}
