//
//  HwInternetControlConfig.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/17.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwTimeDuration.h"
#import "HwAppList.h"
#import "HwUrlCfg.h"
@class HwCustomParam;
@class HwDefaultParam;
@class HwBlockAllParam;

/// 家长控制策略
typedef NS_ENUM(NSInteger , HwPolicy) {
    kHwPolicyDEFAULT,
    kHwPolicyBLOCKALL,
    kHwPolicyALLOWALL,
    kHwPolicyCUSTOM,
};

NS_ASSUME_NONNULL_BEGIN
#pragma mark 设备控制根层模型
@interface HwInternetControlBasicConfig : NSObject

/// 设备mac
@property (nonatomic, copy) NSString *mac;

/// 家长控制策略
@property (nonatomic, assign) HwPolicy policy;
 
@end

#pragma mark 设备控制模型
@interface HwInternetControlConfig : HwInternetControlBasicConfig

/// 默认家长控制
@property (nonatomic, strong) HwDefaultParam *defaultParam;

/// 用户定义家长控制
@property (nonatomic, strong) HwCustomParam *customParam;

/// 断网剩余时间设置
@property (nonatomic, strong) HwBlockAllParam *blockAllParam;

@end

#pragma mark 默认家长控制
@interface HwDefaultParam : NSObject

/// 时段设置
@property (nonatomic, strong) NSArray <HwTimePeriodCfg *>*timePeriodCfg;

/// 家长控制的网址列表
@property (nonatomic, strong) HwUrlCfg *urlCfg;

/// 加入家长控制的大类列表
@property (nonatomic, strong) NSArray <HwClassCfg *>*classCfg;

/// 时长设置
@property (nonatomic, strong) HwTimeDurationCfg *timeDurationCfg;
 
@end

#pragma mark 用户定义家长控制
@interface HwCustomParam : NSObject

/// app设置列表
@property (nonatomic, strong) NSArray <HwClassCfg *>*classList;
 
@end

#pragma mark 断网剩余时间设置
@interface HwBlockAllParam : NSObject

/// 延时多久生效(分钟)
@property (nonatomic, copy) NSString *remainTime;

@end

NS_ASSUME_NONNULL_END
