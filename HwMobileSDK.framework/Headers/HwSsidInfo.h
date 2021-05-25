//
//  HwSsidInfo.h
//  HwMobileSDK
//
//  Created by ios on 2019/8/7.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSsidInfo : NSObject

/** ssidIndex */
@property (nonatomic, copy) NSString *ssidIndex;

/** ssid名称 */
@property (nonatomic, copy) NSString *ssidName;

@end

NS_ASSUME_NONNULL_END
