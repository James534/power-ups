#include "nodringdelegate.h"
#define THRESHOLD 4
#include <QTimer>
#include <QElapsedTimer>
#include <math.h>
#define PI 3.14159265

NodRingDelegate::NodRingDelegate()
{
    m_bRightTapState = false;
    m_bLeftTapState = false;
    m_positionCounter =0;
    m_initiatePostionFlag = false;
    m_bEnableMove = false;
    timer = new QElapsedTimer;
    timer->start();


}

NodRingDelegate::~NodRingDelegate()
{
}

void NodRingDelegate::onTimeoutAfterGesture(){


}

void NodRingDelegate::buttonEventFired(ButtonEvent event)
{

//    if(event.buttonEventType == 0){
//        m_bRightTapState = true;
//    }else if(event.buttonEventType == 1){
//        m_bRightTapState = false;
//    }

//    if(event.buttonEventType == 3){
//        m_bLeftTapState = true;
//        m_initiatePostionFlag = true;
//    }else if(event.buttonEventType == 2){
//        m_bLeftTapState = false;
//    }

    if(event.buttonEventType == 4){
        m_bEnableMove = true;
        timer->restart();
        enableMoveChanged();
    }else if(event.buttonEventType == 5){
        m_bEnableMove = false;
        enableMoveChanged();
    }

    printf("\nButton Event Fired. ButtonEventType: %d from id: %d", event.buttonEventType, event.sender);
}

void NodRingDelegate::pointerEventFired(PointerEvent event)
{
    if(m_bEnableMove && timer->elapsed() > 600)
    {


//       int distance = sqrt(event.x^2 + event.y^2);

//       if(distance > 4){
//            std::cout << "X position changed: " << event.x << " Y position changed: " << event.y << std::endl;
//       }


       if(abs(event.x) > 5  || abs(event.y)  > 5){

           double x = event.x;
           double y = event.y;

           double degree = 0;
           bool skip = false;


           if(x!=0 && y!=0){
               degree = atan2(y,x) * 180/PI;
           }else if( x == 0){
               if(y < 0){
                   //moving down
                   std::cout << "DOWN" << std::endl;
                   skip = true;
                   emit positionChanged("DOWN");
               }else{
                   //moving up
                   std::cout << "UP" << std::endl;
                   skip = true;
                   emit positionChanged("UP");
               }
           }else if(y == 0){
               if(x < 0){
                   //moving left
                   std::cout << "LEFT" << std::endl;
                   skip = true;
                   emit positionChanged("LEFT");
               }else{
                   //moving right
                   std::cout << "RIGHT" << std::endl;
                   skip = true;
                   emit positionChanged("RIGHT");
               }
           }

           if(!skip){
               if(degree <= 22.5 && degree > -22.5){
                   //swipe right
                   std::cout << "RIGHT" << std::endl;
                   emit positionChanged("RIGHT");
               }
               else if(degree > 22.5 && degree <= 67.5){
                   //swipe upper right
                   std::cout << "UPPER RIGHT" << std::endl;
                   emit positionChanged("UPPER_RIGHT");
               }else if(degree > 67.5 && degree <= 112.5){
                    //swipe up
                    std::cout << "UP" << std::endl;
                    emit positionChanged("UP");
               }else if(degree > 112.5 && degree <= 157.5){
                   //swipe UPPER left
                   std::cout << "UPPER LEFT" << std::endl;
                   emit positionChanged("UPPER_LEFT");
               }else if(degree >157.5 && degree <= -157.5){
                   //swipe left
                   std::cout << "LEFT" << std::endl;
                   emit positionChanged("LEFT");
               }else if(degree > -157.5 && degree<= -112.5){
                   //swipe lower left
                   std::cout << "LOWER LEFT" << std::endl;
                   emit positionChanged("LOWER_LEFT");
               }else if(degree > -112.5 && degree  <= -67.5){
                   //swipe down
                   std::cout << "DOWN" << std::endl;
                   emit positionChanged("DOWN");
               }else{
                   //swipe right
                   emit positionChanged("RIGHT");
               }

           }

           std::cout << "ANGLE IS: " << degree << std:: endl;
           std::cout << "X position changed: " << event.x << " Y position changed: " << event.y << std::endl;
           timer->restart();
       }


//       //determine if it is a left swipe
//       if(event.x < -5  && event.y < 2 && event.y >-2){
//           std::cout << "Swipe left"  << std::endl;
//           timer->restart();
//       }

//       //determine right swipe
//       if(event.x > 5 && event.y < 2 && event.y > -2){
//           std::cout << "Swipe right" << std::endl;
//           timer->restart();
//       }

//       //determine if top swipe
//       if(event.y > 5 && event.x > -2 && event.x < 2){
//           std::cout << "Swipe top" << std::endl;
//           timer->restart();
//       }

//       //determine if bottom swipe
//       if(event.y < -5 && event.x > -2 && event.x < 2){
//           std::cout << "Swipe bottom" << std::endl;
//           timer->restart();
//       }

//       //determine upperleft
//       if(event.x < - 5 && event.y > 2 && event.y < 5){
//           std::cout << "Swipe Upper left" << std::endl;
//            timer->restart();
//       }

//       //determine upper right
//       if(event.x > 5 && event.y > 2 && event.y < 5){
//           std::cout << "Swipe UPper right" << std::endl;
//            timer->restart();
//       }

//       //determine bottom left
//       if(event.x < -5 && event.y < -2 && event.y > -5){
//           std::cout << "Swipe lower left" << std::endl;
//           timer->restart();
//       }

//       //determine bottom right
//       if(event.x > 5 && event.y < -2 && event.y > -5){
//           std::cout << "Swipe lower right" << std::endl;
//           timer->restart();
//       }

       //determine bottom right

//        position changed
//        if(m_initiatePostionFlag){
//            ++m_positionCounter;
//            if(m_positionCounter == THRESHOLD){
//                m_initiatePostionFlag = false;
//                m_positionCounter = 0;

//            }
//        //}
    }
}

void NodRingDelegate::gestureEventFired(GestureEvent event)
{
    printf("\nGesture Event Fired. Gesture Type: %d from id: %d", event.gestureType, event.sender);
}

void NodRingDelegate::pose6DEventFired(Pose6DEvent event)
{
    printf("\nPose6D Event Fired. Yaw: %f, Pitch: %f, Roll %f from id: %d", event.yaw, event.pitch, event.roll, event.sender);
}

void NodRingDelegate::setEnableMove(bool value){
    m_bEnableMove = value;
}
