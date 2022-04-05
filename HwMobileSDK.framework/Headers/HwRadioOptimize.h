//
//  HwRadioOptimize.h
//  HwMobileSDK
//
//  Created by ios on 2021/10/27.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwGetWlanRadioInfoParam.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwRadioOptimizeInfo : NSObject

/** 网关或者ap的mac */
@property(nonatomic, copy) NSString *mac;

/** 2.4G/5G */
@property(nonatomic, assign) HwWlanRadioInfoType radioType;

/** 信道 */
@property(nonatomic, copy) NSString *channel;

/** 调优前信道 */
@property(nonatomic, copy) NSString *originChannel;

/** 发射功率 */
@property(nonatomic, copy) NSString *transmitPower;

/** 调优前发射功率 */
@property(nonatomic, copy) NSString *originTransmitPower;

/** 频宽 */
@property(nonatomic, copy) NSString *frequencyWidth;

/** 调优前频宽 */
@property(nonatomic, copy) NSString *originFrequencyWidth;

@end

@interface HwRadioOptimize : NSObject

/** 调优状态 Completed/Failed/Optimizing */
@property(nonatomic, copy) NSString *optimizeStatus;

/** 2.4G频段总调优射频数 */
@property(nonatomic, copy) NSString *radioNum2GP4;

/** 2.4G频段调优成功射频数 */
@property(nonatomic, copy) NSString *radioSucc2GP4;

/** 2.4G频段调优失败射频数 */
@property(nonatomic, copy) NSString *radioFail2GP4;

/** 5G频段总调优射频数 */
@property(nonatomic, copy) NSString *radioNum5G;

/** 5G频段调优成功射频数 */
@property(nonatomic, copy) NSString *radioSucc5G;

/** 5G频段调优失败射频数 */
@property(nonatomic, copy) NSString *radioFail5G;

/** 调优列表 */
@property(nonatomic, copy) NSArray <HwRadioOptimizeInfo *>*list;

@end

NS_ASSUME_NONNULL_END
