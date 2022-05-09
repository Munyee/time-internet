//
//  HwSegmentSpeedTestSubModels.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/5/18.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwSegmentSpeedTestMacro.h>
#import <HwMobileSDK/HwSegmentSpeedTestSubModels.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSegmentSpeedTestSubModels : NSObject

@end

@interface HwSegmentSpeedTestRemoteAddrInfo : NSObject
/** 远端地址，支持 IPv4 地址或者域名 */
@property (nonatomic , copy) NSString *remoteAddr;
/** 指定目的端口，可选 */
@property (nonatomic , copy) NSString *remotePort;
/** PROXY/NON_PROXY，可选 */
@property (nonatomic , copy) NSString *remoteAddrType;

@end


@interface HwSegmentSpeedTestInternetUrlInfo : NSObject
/** 测速服务器的 url */
@property (nonatomic , copy) NSString *downloadUrl;
/** 测速服务器的端口 */
@property (nonatomic , copy) NSString *downloadPort;
/** 用于获取测试服务器信息的 url */
@property (nonatomic , copy) NSString *uploadUrl;
/** 用于获取测试服务器信息的端口 */
@property (nonatomic , copy) NSString *uploadPort;
/** PROXY/NON_PROXY */
@property (nonatomic , copy) NSString *urlType;
@end



@interface HwSegmentSpeedTestWifiInfo : NSObject
/** 频段 */
@property (nonatomic , assign) HwSegmentSpeedTestDeviceRadioType radioType;
/** 下挂设备数 */
@property (nonatomic , assign) NSInteger subDeviceNum;
/** 干扰占空比 */
@property (nonatomic , copy) NSString *interferencePercent;
/** 空闲占空比 */
@property (nonatomic , copy) NSString *idlePercent;
/** 干扰指数 */
@property (nonatomic , copy) NSString *interference;
/** 丢包 */
@property (nonatomic , copy) NSString *loss;

@end

@interface HwSegmentTestLinkInfo : NSObject
/** 上行接入方式 */
@property (nonatomic , assign) HwSegmentSpeedTestDeviceLinkType upLinkType;
/** 信号强度 */
@property (nonatomic , copy) NSString *rssi;
/** 上行协商速率 */
@property (nonatomic , copy) NSString *uploadLinkSpeed;
/** 下行协商速率 */
@property (nonatomic , copy) NSString *downloadLinkSpeed;

@end

@interface HwSegmentSpeedTestAdditionalInfo : NSObject
/** 设备 mac */
@property (nonatomic , copy) NSString *mac;
/** 设备类型 */
@property (nonatomic , assign) HwSegmentSpeedTestDeviceType deviceType;

@end

@interface HwSegmentSpeedTestGateway : HwSegmentSpeedTestAdditionalInfo
/** wifi 信息列表 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestWifiInfo *> *wifiInfoList;
@end

@interface HwSegmentSpeedTestAP : HwSegmentSpeedTestAdditionalInfo
/** 上行信息 */
@property (nonatomic , strong) HwSegmentTestLinkInfo *upLinkInfo;
/** wifi 信息列表 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestWifiInfo *> *wifiInfoList;
@end

@interface HwSegmentSpeedTestSTA : HwSegmentSpeedTestAdditionalInfo
/** 上行接入方式 */
@property (nonatomic , assign) HwSegmentSpeedTestDeviceLinkType upLinkType;
/** 频段 */
@property (nonatomic , assign) HwSegmentSpeedTestDeviceRadioType radioType;
/** 信号强度 */
@property (nonatomic , copy) NSString *rssi;
/** 上行协商速率 */
@property (nonatomic , copy) NSString *uploadLinkSpeed;
/** 下行协商速率 */
@property (nonatomic , copy) NSString *downloadLinkSpeed;
@end

NS_ASSUME_NONNULL_END
