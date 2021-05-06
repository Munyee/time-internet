//
//  HwDeviceTypeInfo.h
//  HwMobileSDK
//
//  Created by IOS2 on 2019/10/12.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwDeviceTypeInfo : NSObject
/** 设备MAC*/
@property(nonatomic, copy)NSString* mac;
/** 设备类型*/
@property(nonatomic, copy)NSString* deviceType;
/** 设备品牌*/
@property(nonatomic, copy)NSString* brand;
/** 操作系统*/
@property(nonatomic, copy)NSString* operatingSystem;
/** 是否为可管理的AP*/
@property(nonatomic, assign)BOOL isAp;
@end

NS_ASSUME_NONNULL_END
