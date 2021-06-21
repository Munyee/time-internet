//
//  HwUpLinkInfo.h
//  HwMobileSDK
//

//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwPonInformation.h"
#import "HwWANInfo.h"

typedef NS_ENUM(long) {
    kLedStatusUnknown = -1,
    kLedStatusOFF,
    kLedStatusON
}HwLEDStatus;

NS_ASSUME_NONNULL_BEGIN

@class HLUpLinkInfo;

@interface HwUpLinkInfo : NSObject

/** LED */
@property(nonatomic, assign) HwLEDStatus ledStatus;

@property(nonatomic, strong) HwPonInformation *opticalModule;

/** WAN */
@property(nonatomic, strong) NSArray <HwWANInfo *> *wanStatusList;

+ (HwUpLinkInfo *)modelFromInnerModel:(HLUpLinkInfo *)gatewayInner;
@end

NS_ASSUME_NONNULL_END
