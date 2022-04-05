//
//  HwWebPwdAndWifiInfo.h
//  HwMobileSDK
//
//  Created by ios on 2020/4/27.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <HwMobileSDK/HwInternetWanInfo.h>
#import <HwMobileSDK/HwWifiInfo.h>
#import <HwMobileSDK/HwSetGatewayConfigStatusParam.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwWebPwdAndWifiInfo : NSObject
/**
 密码
 */
@property (nonatomic, copy) NSString *password;

/**
 wifiInfo
 */
@property (nonatomic, strong) HwWifiInfo *wifiInfo;

/**
 ssidIndex
 */
@property (nonatomic, assign) int ssidIndex;

/**
配置状态：已完成/未完成
*/
@property (nonatomic, assign) kHwGatewayConfigStatus gatewayConfigStatus;

@end

NS_ASSUME_NONNULL_END
