/**
 *  
 *
 *  @brief 网关速率(gateway speed)
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>
#import "HwParam.h"

@interface HwGatewaySpeed : HwParam

/** 表示上行流量,单位K字节(Uplink speed in KB) */
@property(nonatomic, assign)int upSpeed;

/** 表示下行流量,单位K字节(Downlink speed in KB) */
@property(nonatomic, assign)int downSpeed;

@end
