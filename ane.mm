#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#import <IOSurface/IOSurfaceRef.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

enum ANEDeviceUsageType {
  UsageNoProgram,
  UsageWithProgram,
  UsageCompile
};

struct H11ANEDeviceInfoStruct {
  uint64_t pm1;
  uint64_t pm2;
  uint64_t pm3[0x100];
};

struct H11ANEProgramCreateArgsStruct {
  void *pm1;
  uint64_t pm2;
  uint64_t pm3[4];
  char pm4;
};

struct H11ANEProgramCreateArgsStructOutput {
  uint64_t pm1;
  int pm2[0x20000];
};

struct H11ANEProgramPrepareArgsStruct {
  uint64_t pm1;
  uint64_t pm2;
  uint64_t pm3[0x100];
};

struct H11ANEProgramRequestArgsStruct {
  uint64_t pm1[0x1000];
};

namespace H11ANE {
  class H11ANEDevice;
  class H11ANEServicesThreadParams;

  class H11ANEDeviceController {
    public: H11ANEDeviceController(int (*callback)(H11ANE::H11ANEDeviceController*, void*, H11ANE::H11ANEDevice*), void *arg);
  };

  class H11ANEDevice {
    public:
      H11ANEDevice(H11ANE::H11ANEDeviceController *param_1, unsigned int param_2);

      unsigned long H11ANEDeviceOpen(int (*callback)(H11ANE::H11ANEDevice*, unsigned int, void*, void*), void *param_2, ANEDeviceUsageType param_3, H11ANEDeviceInfoStruct *param_4);

      int ANE_IsPowered();

      int ANE_ReadANERegister(unsigned int param_1, unsigned int *param_2);
      int ANE_ForgetFirmware();
      int ANE_PowerOn();
      int ANE_PowerOff();

      void EnableDeviceMessages();

      int ANE_ProgramCreate(H11ANEProgramCreateArgsStruct*, H11ANEProgramCreateArgsStructOutput*);
      int ANE_ProgramPrepare(H11ANEProgramPrepareArgsStruct*);
      int ANE_ProgramSendRequest(H11ANEProgramRequestArgsStruct*, unsigned int);

  };

  unsigned long CreateH11ANEDeviceController(H11ANE::H11ANEDeviceController**,
    int (*callback)(H11ANE::H11ANEDeviceController*, void*, H11ANE::H11ANEDevice*), void *arg);

};

using namespace H11ANE;

H11ANEDevice *device = NULL;

// Controller notifications
int MyH11ANEDeviceControllerNotification(H11ANEDeviceController *param_1, void *param_2, H11ANEDevice *param_3)
{
    return (0);
}

int MyH11ANEDeviceMessageNotification(H11ANE::H11ANEDevice* dev, unsigned int param_1, void* param_2, void* param_3)
{
    return (0);
}


extern "C" {
  int H11ANEDeviceOpen(unsigned long *param_1, void *param_2, unsigned long param_3, unsigned long param_4);

  int H11ANEProgramProcessRequestDirect(H11ANEDevice *pANEDevice, void *programRequest,void *requestCallback);

  int H11InitializePlatformServices(void);
  int H11ANEProgramCreate(long param_1, long *param_2, long *param_3);

  int H11ANEProgramPrepare(long param_1,long *param_2, unsigned long param_3);
}

struct programRequest {
  int param1;
  int param2;
  IOSurfaceRef param3;
  char param4[0x2038-0x10];
};
