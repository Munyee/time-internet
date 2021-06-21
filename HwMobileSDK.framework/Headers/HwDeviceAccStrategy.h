//
//  HwDeviceAccStrategy.h
//  HwMobileSDK
//
//  Created by ios on 2020/10/14.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#pragma mark 设置网络加速
@interface HwDeviceAccStrategy : NSObject

/// GAME、EDUCATION、OFFICE
@property (nonatomic, copy) NSString *accApp;

/// enable
@property (nonatomic, assign) BOOL enable;

@end

NS_ASSUME_NONNULL_END
