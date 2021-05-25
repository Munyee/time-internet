//
//  HwIsNeedAppForceUpdateResult.h
//  HwMobileSDK
//
//  Created by ios on 2019/10/22.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwIsNeedAppForceUpdateResult : NSObject

/**
 需要强制升级的SDK版本号
 */
@property (nonatomic, copy) NSString *appForceUpgradeSdkVersion;

/**
 需要强制升级的APP版本号
 */
@property (nonatomic, copy) NSString *appForceUpgradeAppVersion;

/**
 是否需要强制升级标识
 */
@property (nonatomic, copy) NSString *appForceUpgradeFlag;

/**
 是否需要强制升级
 */
@property (nonatomic, assign) BOOL isNeedUpdate;

@end

NS_ASSUME_NONNULL_END
