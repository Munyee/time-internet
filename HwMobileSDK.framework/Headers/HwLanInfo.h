//
//  HwLanInfo.h
//  HwMobileSDK
//
//  Created by ios on 2020/8/31.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwLanInfo : NSObject

/// 以太端口号
@property (nonatomic, assign) int portIndex;

/// 启用/未启用
@property (nonatomic, assign) BOOL enable;

/// Up、NoLink、Error、Disabled
@property (nonatomic, copy) NSString *status;

/// 10、100、1000、10000
@property (nonatomic, assign) int bitRate;

/// Half、Full、Auto
@property (nonatomic, copy) NSString *duplexMode;

/// 10、100、1000、10000
@property (nonatomic, assign) int maxBitRate;

@end

NS_ASSUME_NONNULL_END
