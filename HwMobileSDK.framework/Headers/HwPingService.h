//
//  HwPingService.h
//  HwMobileSDK
//
//  Created by ios on 2021/4/15.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwPingInfo.h>
#import <HwMobileSDK/HwCallback.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwPingService : NSObject

/// 开启ping测试（可重复）
/// @param address 地址
/// @param interval 间隔时间，如果为0代表只ping一次，不重复
/// @param callback HwPingInfo
- (void)startPing:(NSString *)address interval:(CGFloat)interval callback:(id<HwCallback>)callback;

/// 停止ping，需要和开启使用同一个HwPingService
/// @param callback HwResult
- (void)stopPing:(id<HwCallback>)callback;

@end

NS_ASSUME_NONNULL_END
