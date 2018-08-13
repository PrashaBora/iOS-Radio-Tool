#ifndef CORETELEPHONY_H_
#define CORETELEPHONY_H_

#include <CoreFoundation/CoreFoundation.h>
#include <CoreTelephony/CTCall.h>

//struct __CTServerConnection {
//  int a;
//  int b;
//  CFMachPortRef myport;
//  int c;
//  int d;
//  int e;
//  int f;
//  int g;
//  int h;
//  int i;
//};

// iOS 6.1
struct _CTServerConnection {
    struct __CFRuntimeBase {
        unsigned int _field1;
        unsigned char _field2[4];
    } _field1;
    struct dispatch_queue_s *_field2;
    struct CTServerState *_field3;
    unsigned char _field4;
    unsigned int _field5;
    struct _xpc_connection_s *_field6;
};

struct dispatch_object_s;

struct dispatch_queue_s;

struct queue {
    struct dispatch_object_s *fObj;
};

#pragma mark Typedef'd Structures

// @jason
  struct CTError{
    SInt32 domain;
    SInt32 error;
  } ;

typedef struct {
    int _field1;
    int _field2;
} CDStruct_1ef3fb1f;


struct CTResult
{
    int flag;
    int a;
};

//////////////////////////////



typedef struct __CTServerConnection CTServerConnection;
typedef CTServerConnection* CTServerConnectionRef;
//
//struct __CellInfo {
//    int servingmnc;
//    int network;
//    int location;
//    int cellid;
//    int station;
//    int freq;
//    int rxlevel;
//    int c1;
//    int c2;
//};
//typedef struct __CellInfo CellInfo;
//typedef CellInfo* CellInfoRef;

//
//// r4, r7,lr
//mach_port_t _CTServerConnectionGetPort(CTServerConnectionRef);

// r4, r5, r6, r7, lr
//void _CTServerConnectionCellMonitorStart(CFMachPortRef port, CTServerConnectionRef);
//
//void _CTServerConnectionRegisterForNotification(CTServerConnectionRef,void *,void(*callback)(void));
//void kCTCellMonitorUpdateNotification();
//
//void _CTServerConnectionCellMonitorGetCellCount(CFMachPortRef port,CTServerConnectionRef,int *cellinfo_count);

// r4, r5, r6, r7, lr
//void _CTServerConnectionCellMonitorGetCellInfo(CFMachPortRef port,CTServerConnectionRef,int cellinfo_number,CellInfoRef* ref);

//int _CTServerConnectionSetVibratorState(int *, void *, int, int, int, int, int);



//void _CTServerConnectionCellMonitorGetUmtsCellCount(struct CTError *,CTServerConnectionRef,int *cellinfo_count);
//void _CTServerConnectionCellMonitorGetUmtsCellInfo(struct CTError *,CTServerConnectionRef,int cellinfo_number,CellInfoRef* ref);

typedef void (*CTServerConnectionCallback)(CTServerConnectionRef, CFStringRef, CFDictionaryRef, void *);

CTServerConnectionRef _CTServerConnectionCreate(CFAllocatorRef allocator, CTServerConnectionCallback, int *unknown);

// @jason
//extern void _CTServerConnectionCellMonitorCopyCellInfo( struct CTError *, CTServerConnection *, void* unkn, NSArray ** cellData );
#ifdef __LP64__
extern void _CTServerConnectionCellMonitorCopyCellInfo(CTServerConnection *, void* unkn, NSArray ** cellData);
#else
extern void _CTServerConnectionCellMonitorCopyCellInfo( struct CTError *, CTServerConnection *, void* unkn, NSArray ** cellData );
#endif

int *  _CTServerConnectionCopyMobileEquipmentInfo(struct CTError *,
                                                  CTServerConnection * Connection,
                                                 NSDictionary ** cellData
                                                  );


#ifdef __LP64__

void _CTServerConnectionGetLocationAreaCode(CTServerConnectionRef, int*);
void _CTServerConnectionGetCellID(CTServerConnectionRef, int*);

#else

void _CTServerConnectionGetLocationAreaCode(struct CTResult*, CTServerConnectionRef, int*);
#define _CTServerConnectionGetLocationAreaCode(connection, LAC) { struct CTResult res; _CTServerConnectionGetLocationAreaCode(&res, connection, LAC); }

void _CTServerConnectionGetCellID(struct CTResult*, CTServerConnectionRef, int*);
#define _CTServerConnectionGetCellID(connection, CID) { struct CTResult res; _CTServerConnectionGetCellID(&res, connection, CID); }

#endif
//
//void _CTServerConnectionCellAddToRunLoop();
//
//
//void _CTServerConnectionGetSignalStrength();


// @phone
//void __CTCallDisconnect(id call,id a);
//extern void CTCallDisconnect(id call);
//
//id CTTelephonyCenterGetDefault();
//
//extern NSString *CTCallCopyAddress(void*, CTCall *);


#endif  // CORETELEPHONY_H_
