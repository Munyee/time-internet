//
//  HwSetWlanRadioInfoParam.h
//  HwMobileSDK
//
//  Created by ios on 2019/8/7.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwGetWlanRadioInfoParam.h>
#import <HwMobileSDK/HwSetWlanHardwareSwitchParam.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSetWlanRadioInfoParam : NSObject

/** 设备MAC地址，为空或者不指定代表网关本身，不为空代表下挂AP */
@property (nonatomic, copy) NSString *mac;

/** 频段类型,"G2P4"代表2.4G，"G5"代表5G*/
@property (nonatomic, assign) HwSetWlanRadioType radioType;

/** 此频段是否开启*/
@property (nonatomic, assign) BOOL enable;

/** 使用的802.11标准，取值11a/11b/11g/11n/11ac(in-use 802.11 standard: 11a, 11b, 11g, 11n, or 11ac) */
@property (nonatomic, copy) NSString *standard;

/** 当前使用的信道(currently used channel) */
@property (nonatomic) int channel;

/** 发射功率 */
@property (nonatomic, copy) NSString *transmitPower;

/** 频宽 20、40、60、80、100、160 */
@property (nonatomic, copy) NSString *frequencyWidth;

@end

NS_ASSUME_NONNULL_END
