#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwResult.h>

@interface HwQueryLanDeviceListResult : HwResult

/** 下挂设备列表 */
@property (nonatomic, strong) NSMutableArray *lanDeviceList;

@end
