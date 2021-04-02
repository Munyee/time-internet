//
//  HwWlanRadioInfo.h
//  HwMobileSDK
//
//  Created by ios on 2019/8/7.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwGetWlanRadioInfoParam.h"
#import "HwSsidInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 实际频宽

 - kHwCurrentChannelWidthHT20_40: HT20/40
 - kHwCurrentChannelWidthHT20: HT20
 - kHwCurrentChannelWidthHT40: HT40
 - kHwCurrentChannelWidthHT80: HT80
 - kHwCurrentChannelWidthHT160: HT160
 - kHwCurrentChannelWidthHT80_80: HT80+80
 - kHwCurrentChannelWidthUnknown: 未知
 */
typedef NS_ENUM(NSInteger,HwCurrentChannelWidthType) {
    kHwCurrentChannelWidthHT20_40=0,
    kHwCurrentChannelWidthHT20,
    kHwCurrentChannelWidthHT40,
    kHwCurrentChannelWidthHT80,
    kHwCurrentChannelWidthHT160,
    kHwCurrentChannelWidthHT80_80,
    kHwCurrentChannelWidthUnknown=999,
};

typedef NS_ENUM(NSInteger,HwAcsModeType) {
    kHwAcsModeAutoWithDFS,
    kHwAcsModeAutoWithoutDFS,
    kHwAcsModeUnknown=999,
};

@interface HwWlanRadioInfo : NSObject

/** 频段类型,"G2P4"代表2.4G，"G5"代表5G，"ALL"代表所有频段*/
@property (nonatomic, assign) HwWlanRadioInfoType radioType;

/** 此频段是否开启*/
@property (nonatomic, assign) BOOL enable;

/** 使用的802.11标准，取值11a/11b/11g/11n/11ac(in-use 802.11 standard: 11a, 11b, 11g, 11n, or 11ac) */
@property (nonatomic, copy) NSString *standard;

/** 当前使用的信道(currently used channel) */
@property (nonatomic) int channel;

/** 是否能自动选择信道*/
@property (nonatomic, assign) BOOL autoChannelEnable;

/**
    kHwAcsModeAutoWithoutDFS为自动选择并且避让雷达信道
    kHwAcsModeAutoWithDFS为自动选择并且不避让雷达信道
 */
@property (nonatomic, assign) HwAcsModeType acsMode;

/** 可供选择的信道列表*/
@property (nonatomic, strong) NSArray <NSString *>*channelsInUse;

/** 发射功率 */
@property (nonatomic, copy) NSString *transmitPower;

/** 频宽 */
@property (nonatomic, copy) NSString *frequencyWidth;

/** 实际频宽 0:HT20/40 1:HT20 2:HT40 3:HT80 4:HT160 5:HT80+80*/
@property (nonatomic, assign) HwCurrentChannelWidthType currentChannelWidth;

/** 底噪 */
@property (nonatomic, copy) NSString *noise;

/** 干扰占空比 */
@property (nonatomic, copy) NSString *interferencePercent;

/** 空闲占空比 */
@property (nonatomic, copy) NSString *idelPercent;

/** 接收报文数 */
@property (nonatomic, copy) NSString *recvPackets;

/** 发送报文数 */
@property (nonatomic, copy) NSString *sendPackets;

/** 发送失败的次数 */
@property (nonatomic, copy) NSString *beaconFails;

/** 支持的ssid列表*/
@property (nonatomic, strong) NSArray <HwSsidInfo *>*ssidList;

@end

NS_ASSUME_NONNULL_END
