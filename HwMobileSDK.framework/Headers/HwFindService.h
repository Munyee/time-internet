#import <Foundation/Foundation.h>
#import "HwGatewayDevice.h"

@protocol HwCallback;

/**
 *  
 *
 *  @brief 设备发现服务
 *
 *  @since 1.0
 */
@interface HwFindService : NSObject

/**
 *  
 *
 *  @brief 查找设备
 *
 *  @param conditions 查找的条件(SN,MAC,PPPOE_ACCOUNT,COMMON)
 *  @param callback   返回回调
 *
 *  @since 1.0
 */
- (void)find:(NSDictionary *)conditions withCallback:(id<HwCallback>)callback;

@end
