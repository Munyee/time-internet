//
//  HwEaiInfo.h
//  HwMobileSDK
//
//  Created by ios on 2020/10/13.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark 设备详情
@interface HwEaiDeviceInfo : NSObject

/// mac
@property (nonatomic, copy) NSString *mac;

/// ip
@property (nonatomic, copy) NSString *ip;

/// GAME、EDUCATION、OFFICE
@property (nonatomic, strong) NSArray <NSString *>*app;

/// enable
@property (nonatomic, assign) BOOL powerSaveState;

@end

#pragma mark 查询网络加速设备
@interface HwEaiInfo : NSObject

/// on、off
@property (nonatomic, copy) NSString *runState;

/// STA MacList
@property (nonatomic, strong) NSArray <NSString *>*gameStaMacList;

/// STA IpList
@property (nonatomic, strong) NSArray <NSString *>*gameStaIpList;

/// Eai Device Info
@property (nonatomic, strong) NSArray <HwEaiDeviceInfo *>*staList;

/// Version
@property (nonatomic, copy) NSString *version;

@end

NS_ASSUME_NONNULL_END
