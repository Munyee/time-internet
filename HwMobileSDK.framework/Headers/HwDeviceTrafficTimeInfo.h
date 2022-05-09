//
//  HwDeviceTrafficTimeInfo.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/17.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwDeviceOnlineTimeInfo.h>
@class HwClassTraffic;
@class HwDeviceTrafficStatistics;

NS_ASSUME_NONNULL_BEGIN

#pragma mark 流量模型最外层
@interface HwDeviceTrafficTimeInfo : NSObject

/// 设备mac
@property (nonatomic, copy) NSString *mac;

/// 在线时长集合
@property (nonatomic, strong) NSArray<HwClassTraffic *> *classTraffic;

@end

#pragma mark 流量模型第二层
@interface HwClassTraffic : NSObject

/// 统计周期
@property (nonatomic, assign) HwPeriod period;

/// 设备通信信息集合
@property (nonatomic, strong) NSArray<HwDeviceTrafficStatistics *> *list;

@end

#pragma mark 流量模型第三层
@interface HwDeviceTrafficStatistics : NSObject

/// 大类名称
@property (nonatomic, copy) NSString *className;

/// 流量（KB）
@property (nonatomic, copy) NSString *traffic;

@end

NS_ASSUME_NONNULL_END
