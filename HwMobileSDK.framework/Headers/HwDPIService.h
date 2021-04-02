//
//  HwDPIService.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/25.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwCallback.h"

NS_ASSUME_NONNULL_BEGIN
@class HwGetGatewayNetQualityParam;
@class HwGetApOrSTANetQualityParam;
@interface HwDPIService : NSObject

/**
 查询指定网关网络质量数据

 @param deviceId 网关id
 @param param 查询参数
 @param callback 回调
 */
- (void) getGatewayNetQualityWithDeviceid:(NSString *)deviceId param:(HwGetGatewayNetQualityParam *)param callback:(id<HwCallback>)callback;

/**
 查询网关下挂指定AP或者STA设备的网络质量信息

 @param deviceId 网关id
 @param param 查询参数
 @param callback 回调
 */
- (void) getApOrSTANetQualityWithDeviceId:(NSString *)deviceId param:(HwGetApOrSTANetQualityParam *)param callback:(id<HwCallback>)callback;
/**
 查询网关所有下挂AP和STA设备的网络质量信息
 
 @param deviceId 网关id
 @param param 查询参数
 @param callback 回调
 */
- (void) getAllApOrSTANetQualityWithDeviceId:(NSString *)deviceId param:(HwGetApOrSTANetQualityParam *)param callback:(id<HwCallback>)callback;

@end

NS_ASSUME_NONNULL_END
