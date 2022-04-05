//
//  HwUserAccelerationInfo.h
//  HwMobileSDK
//
//  Created by ios on 2021/5/14.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwUserAccelerationInfo : NSObject

/// 加速开始时间
@property (nonatomic, assign) NSTimeInterval time;

/// 加速持续时间(秒)
@property (nonatomic, assign) NSInteger duration;

/// 平均时延(毫秒)
@property (nonatomic, assign) NSInteger avgDelay;

/// 设备mac
@property (nonatomic, copy) NSString *mac;

@end

@interface HwOntAccelerationInfo : NSObject

/// 加速列表
@property (nonatomic, strong) NSArray <HwUserAccelerationInfo *>*historyAccelerateRecords;

/// 加速类型：GAME、EDUCATION、OFFICE
@property (nonatomic, copy) NSString *appType;

/// 总加速时间(秒)
@property (nonatomic, assign) NSInteger totalDuration;

@end

NS_ASSUME_NONNULL_END
