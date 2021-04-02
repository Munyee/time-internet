#import <Foundation/Foundation.h>
#import "HwGatewayBasicParam.h"

@interface HwGetLanDeviceNameParam : HwGatewayBasicParam

/** 下挂设备MAC */
@property(nonatomic, strong) NSMutableArray *lanDeviceMacList;

@end
