//
//  HwAPSystemInfo.h
//  HwMobileSDK
//
//  Created by IOS2 on 2020/5/26.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwAPSystemInfo : NSObject
/**
* Converts the first character to its lowe case version
*
* APmac
* */
@property (nonatomic, copy) NSString *mac;
/**
* Converts the first character to its lowe case version
*
* AP上一次离线原因
* */
@property (nonatomic, copy) NSString *lastOfflineReason;
/**
* Converts the first character to its lowe case version
*
* AP上一次重启原因
* */
@property (nonatomic, copy) NSString *lastResetReason;
/**
* Converts the first character to its lowe case version
*
* AP上一次重启来源
* */
@property (nonatomic, copy) NSString *lastResetTerminal;
@end

NS_ASSUME_NONNULL_END
