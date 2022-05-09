//
//  HwPingInfo.h
//  HwMobileSDK
//
//  Created by ios on 2021/4/15.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwPingInfo : NSObject

/// 标志
@property (nonatomic, assign) int sequenceNumber;

/// ip地址
@property (nonatomic, copy) NSString *ip;

/// ttl
@property (nonatomic, assign) int timeToLive;

/// 耗时（毫秒）
@property (nonatomic, assign) double useTime;

/// 长度
@property (nonatomic, assign) NSUInteger dateBytesLength;

/// 原始地址
@property (nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
