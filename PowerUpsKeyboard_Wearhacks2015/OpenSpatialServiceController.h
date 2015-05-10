#pragma once

#if defined(OPENSPATIAL_EXPORT) // inside DLL
#   define OSAPI   __declspec(dllexport)
#else // outside DLL
#   define OSAPI   __declspec(dllimport)
#endif  // XYZLIBRARY_EXPORT



#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include <string>
#include <iostream>
#include <winsvc.h>


// Need to link with Ws2_32.lib, Mswsock.lib, and Advapi32.lib
#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")


#define BUFFER_SIZE 512
#define DEFAULT_PORT 19999
#define DATA_PORT 20001

#define SUBSCRIBE_TO_POINTER 128
#define SUBSCRIBE_TO_GESTURE 129
#define SUBSCRIBE_TO_POSE6D 130
#define SUBSCRIBE_TO_BUTTON 131
#define SHUTDOWN_NOD 132
#define GET_CONNECTED_NAMES 133
#define SET_TTM 134
#define SET_GAMEPAD 135
#define SET_3DMODE 136
#define RECENTER_NOD 137
#define RECALIBRATE_NOD 138
#define FLIP_Y_NOD 139
#define FLIP_ROT_NOD 140
#define SET_SCREEN_RES 141
#define SET_INPUT_QUEUE_DEPTH 142
#define SET_TAP_TIME 143
#define SET_DOUBLE_TAP_TIME 144
#define REFRESH_SERVICE 145

#define MODE_TTM 0
#define MODE_GAMEPAD 1
#define MODE_3D 2

#define G_OP_SCROLL 0x0001
#define G_OP_DIRECTION 0x0002
#define GRIGHT 0x01
#define GLEFT 0x02
#define GDOWN 0x03
#define GUP 0x04
#define GCW 0x05
#define GCCW 0x06
#define SLIDE_LEFT 0x01
#define SLIDE_RIGHT 0x02

#define BUTTON_UP 2
#define BUTTON_DOWN 1

#define PORT_COUNT_KEY TEXT("portCounter")
//Methods to open sockets on different threads for nonblocking
DWORD WINAPI openDataSocket(LPVOID lpParam);
DWORD WINAPI listenNameSocket(LPVOID lpParam);
void decodeAndSendEvents(unsigned char* bytes, int numBytes);


enum ButtonEventType {
	TOUCH0_DOWN,
	TOUCH0_UP,
	TOUCH1_UP,
	TOUCH1_DOWN,
	TOUCH2_DOWN,
	TOUCH2_UP,
	TACTILE1_DOWN,
	TACTILE1_UP,
	TACTILE0_DOWN,
	TACTILE0_UP,
};

enum GestureEventType {
	SWIPE_DOWN,
	SWIPE_LEFT,
	SWIPE_RIGHT,
	SWIPE_UP,
	CW,
	CCW,
	SLIDER_LEFT,
	SLIDER_RIGHT
};

struct PointerEvent
{
	int x;
	int y;
	int sender;
};

struct GestureEvent
{
	int gestureType;
	int sender;
};

struct ButtonEvent
{
	int buttonEventType;
	int sender;
};

struct Pose6DEvent
{
	int x;
	int y;
	int z;
	float yaw;
	float pitch;
	float roll;
	int sender;
};

class OpenSpatialDelegate
{
public:
	virtual void pointerEventFired(PointerEvent event) = 0;
	virtual void gestureEventFired(GestureEvent event) = 0;
	virtual void pose6DEventFired(Pose6DEvent event) = 0;
	virtual void buttonEventFired(ButtonEvent event) = 0;
	std::vector<std::string> names;
    //bool getEnableMove();
};

class OpenSpatialServiceController
{
public:
	OpenSpatialServiceController();
	~OpenSpatialServiceController();
	void waitForServiceStatus(DWORD statusTo, SC_HANDLE service);
	std::vector<std::string> names;
	std::vector<std::string> getNames();
	BOOL setup;
	void subscribeToPointer(std::string name);
	void subscribeToGesture(std::string name);
	void subscribeToButton(std::string name);
	void subscribeToPose6D(std::string name);
	void shutdown(std::string name);
	void setMode(std::string name, int mode);
	void recenter(std::string name);
	void recalibrate(std::string name);
	void flipY(std::string name);
	void flipRot(std::string name);
	void setDelegate(OpenSpatialDelegate* del);
	void refreshService();
	SC_HANDLE serviceManager;
	/* To Implement
	void setRes();
	void setInputQueueDepth();
	void setTapTime();
	void setDoubleTapTime();
	void startService()
	void stopService()

	Other nControl / Battery and etc. Once implemented in service
	*/
private:
	void ClearGlobalVariables();

	DWORD openNameSocket();
	SC_HANDLE OSService;
	int setupService();
	void sendName(std::string name);

	HANDLE dataThreadHandle;
	HANDLE nameThreadHandle;

	DWORD dataThreadID;
	DWORD nameThreadID;
};


