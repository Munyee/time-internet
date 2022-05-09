//
//  HwAllWifiInfo.h
//  MobileSDK
//

//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLAllWifiInfo;
@interface HwAllWifiInfo : NSObject

@property (nonatomic, assign) BOOL isMainSwitchOn;

@property (nonatomic, assign) BOOL isG2P4SwitchOn;

@property (nonatomic, assign) BOOL isG5SwitchOn;

@property (nonatomic, strong) NSArray * allWifiInfoList;

@property (nonatomic, strong) NSArray * allG2P4WifiInfoList;

@property (nonatomic, strong) NSArray * allG5WifiInfoList;

+ (HwAllWifiInfo *)changeFormInnerModel:(HLAllWifiInfo *)hlAllWifiInfo;

@end
