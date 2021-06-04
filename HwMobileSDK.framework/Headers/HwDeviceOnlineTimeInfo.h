//
//  HwDeviceOnlineTimeInfo.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/17.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HwClassOnlineTime;
@class HwDeviceOnlineTimeStatistics;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , HwPeriod) {
    kHwPeriodDAY,
    kHwPeriodWEEK,
    kHwPeriodYESTERDAY,
};

#pragma mark 在线时长模型最外层
@interface HwDeviceOnlineTimeInfo : NSObject

/// 设备mac
@property (nonatomic, copy) NSString *mac;

/// 在线时长集合
@property (nonatomic, strong) NSArray<HwClassOnlineTime *> *classOnlineTime;

@end

#pragma mark 在线时长模型第二层
@interface HwClassOnlineTime : NSObject

/// 统计周期
@property (nonatomic, assign) HwPeriod period;

/// 设备通信信息集合
@property (nonatomic, strong) NSArray<HwDeviceOnlineTimeStatistics *> *list;

@end

#pragma mark 在线时长模型第三层
@interface HwDeviceOnlineTimeStatistics : NSObject

/// 大类名称
@property (nonatomic, copy) NSString *className;

/// 在线时长（min）
@property (nonatomic, copy) NSString *onlineTime;

@end

NS_ASSUME_NONNULL_END
