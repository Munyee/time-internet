//
//  HwApUplinkInfo.h
//  HwMobileSDK
//
//  Created by ios on 2021/11/11.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , HwWorkingMode) {
    HwWorkingModeUndefined,
    HwWorkingModeRepeater,
    HwWorkingModeClient,
    HwWorkingModeRouter,
};

typedef NS_ENUM(NSInteger , HwDeviceLinkType) {
    HwDeviceLinkTypeUndefined,
    HwDeviceLinkTypeETH,
    HwDeviceLinkTypeWIFI,
    HwDeviceLinkTypePON,
};

NS_ASSUME_NONNULL_BEGIN

@interface HwApUplinkInfo : NSObject

/** ap的mac */
@property(nonatomic, copy) NSString *apMac;

/** 当前工作模式 */
@property(nonatomic, assign) HwWorkingMode workingMode;

/** 上行接入方式 WIFI/ETH */
@property(nonatomic, assign) HwDeviceLinkType uplinkType;

/** 上行使用的max */
@property(nonatomic, copy) NSString *macAddress;

/** 上行ssid名称 */
@property(nonatomic, copy) NSString *accessPoint;

/** 上行速率,ETH上行只看uplinkRate */
@property(nonatomic, assign) int uplinkRate;

/** 下行速率 */
@property(nonatomic, assign) int downlinkRate;

/** 上行最大支持速率，非ETH时为空 */
@property(nonatomic, assign) int maxBitRate;

/** 发送包数量 */
@property(nonatomic, copy) NSString *sendPackets;

/** 接收包数量 */
@property(nonatomic, copy) NSString *recvPackets;

/** 其他信息 */
@property(nonatomic, copy) NSString *wiFiInfo;

@end

NS_ASSUME_NONNULL_END
