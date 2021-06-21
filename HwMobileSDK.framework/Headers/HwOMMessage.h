//
//  HwOMMessage.h
//  HwMobileSDK
//
//  Created by ios on 2019/10/10.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwOMMessage : NSObject

/**
 消息ID
 */
@property (nonatomic, copy) NSString *planId;

/**
 消息内容
 */
@property (nonatomic, copy) NSString *content;

/**
 SDK版本号最小值
 */
@property (nonatomic, copy) NSString *minIosSdkVersion;

/**
 SDK版本号最大值
 */
@property (nonatomic, copy) NSString *maxIosSdkVersion;

/**
 截止有效期。UTC时间
 */
@property (nonatomic, assign) NSTimeInterval endTime;

@end

NS_ASSUME_NONNULL_END
