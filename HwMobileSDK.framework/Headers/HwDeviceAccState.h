//
//  HwDeviceAccState.h
//  HwMobileSDK
//
//  Created by ios on 2020/10/13.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHwAccStateOff,
    kHwAccStateOn,
    kHwAccStateDisable,
} HwAccState;

NS_ASSUME_NONNULL_BEGIN

#pragma mark 查询网络加速
@interface HwDeviceAccState : NSObject

/// GAME、EDUCATION、OFFICE
@property (nonatomic, copy) NSString *accApp;

/// OFF、ON、Disable
@property (nonatomic, assign) HwAccState accState;

@end

NS_ASSUME_NONNULL_END
