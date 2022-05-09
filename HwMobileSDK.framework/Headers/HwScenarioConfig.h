//
//  HwScenarioConfig.h
//  HwMobileSDK
//
//  Created by ios on 2021/10/27.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kHwScenarioUndefine = 0,
    kHwScenarioNormal,
    kHwScenarioHighDensity,
    kHwScenarioLowDensity,
    kHwScenarioSparse,
    kHwScenarioAuto,
} kHwScenarioType;

NS_ASSUME_NONNULL_BEGIN

@interface HwScenarioConfig : NSObject

/** 场景模式 */
@property(nonatomic, assign) kHwScenarioType scenarioType;

- (NSString *)getScenarioTypeString;
@end

NS_ASSUME_NONNULL_END
