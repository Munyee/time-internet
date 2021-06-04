//
//  HwWifiInfoAll.h
//  HwMobileSDK
//
//  Created by ios on 2018/12/22.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwWifiInfo.h"
#import "HwWifiTimer.h"

@class HLWifiInfoAll;
NS_ASSUME_NONNULL_BEGIN

@interface HwWifiInfoAll : NSObject

/**
 2.4G频道开关
 */
@property (nonatomic,copy) NSString *hardwareSwitch2p4G;

/**
 5G频道开关
 */
@property (nonatomic,copy) NSString *hardwareSwitch5G;

/**
 下属WiFi数组
 */
@property (nonatomic,strong) NSArray <HwWifiInfo *>*infoList;

/**
 下属WiFi定时数组
 */
@property (nonatomic,strong) NSArray <HwWifiTimer *>*timerList;

/**
 双频合一状态
 */
@property (nonatomic,assign) BOOL dualbandCombine;

/**
 是否支持双频合一
 */
@property (nonatomic,assign) BOOL isSupportDualbandCombine;

+ (HwWifiInfoAll *)changeFormInnerModel:(HLWifiInfoAll *)allWifiInfo;

@end

NS_ASSUME_NONNULL_END
