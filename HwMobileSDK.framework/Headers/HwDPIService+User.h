//
//  HwDPIService+User.h
//  HwMobileSDK
//
//  Created by ios on 2021/5/14.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <HwMobileSDK/HwMobileSDK.h>
#import <HwMobileSDK/HwQueryAccelerationParam.h>
#import <HwMobileSDK/HwUserAccelerationInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwDPIService (User)

/// 查询网关加速概要
/// @param deviceId 网关mac
/// @param param 入参模型
/// @param callback Array<HwOntAccelerationInfo>
- (void)queryAcceleration:(NSString *)deviceId param:(HwQueryAccelerationParam *)param callback:(id<HwCallback>)callback;


/// 查询用户加速历史记录
/// @param deviceId 网关mac
/// @param param 入参模型
/// @param callback 回调 Array<HwUserAccelerationInfo>
- (void)queryUserHistoryAcceleration:(NSString *)deviceId param:(HwQueryUserAccelerationParam *)param callback:(id<HwCallback>)callback;

@end

NS_ASSUME_NONNULL_END
