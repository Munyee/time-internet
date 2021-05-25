#import <Foundation/Foundation.h>
#import "HwParam.h"

/**
 *  
 *
 *  @brief 网关相关操作基本请求参数 (basic gateway-related operation request parameters)
 *
 *  @since 1.0
 */
@interface HwGatewayBasicParam : HwParam

/** 网关的设备ID(最长128字节) (gateway device ID, containing a maximum of 128 bytes)*/
@property(nonatomic, copy) NSString *deviceId;

@end
