//
//  HwTimeDuration.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/17.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark 单天时长设置
@interface HwTimeDuration : NSObject

/// 星期(Sun、Mon等)
@property (nonatomic, copy) NSString *day;

/// 时长(min)
@property (nonatomic, copy) NSString *duration;
 
@end

#pragma mark 时长设置
@interface HwTimeDurationCfg : NSObject

/// 单天的时长设置
@property (nonatomic, strong) NSArray <HwTimeDuration *>*cfg;

/// 当天剩余上网时间
@property (nonatomic, copy) NSString *todayRemains;

@end

#pragma mark 时段设置
@interface HwTimePeriodCfg : NSObject

/// 开始时间
@property (nonatomic, copy) NSString *startTime;

/// 结束时间
@property (nonatomic, copy) NSString *endTime;

/// 重复的星期天数（逗号拼接:@"Sun,Mon"）
@property (nonatomic, copy) NSString *repeatDay;

/// 是否使能
@property (nonatomic, copy) NSString *enabled;
 
@end

NS_ASSUME_NONNULL_END
