//
//  HwSteeringSensitivity.h
//  HwMobileSDK
//
//  Created by ios on 2021/10/27.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHwSensitivityLow = 0,
    kHwSensitivityMedium,
    kHwSensitivityHigh,
} kHwSensitivityType;

NS_ASSUME_NONNULL_BEGIN

@interface HwSteeringSensitivity : NSObject

/** 漫游灵敏度 */
@property(nonatomic, assign) kHwSensitivityType steeringSensitivity;

@end

NS_ASSUME_NONNULL_END
