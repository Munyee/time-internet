//
//  HwStartSegmentSpeedTestParam.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2019/4/17.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwSegmentSpeedTestMacro.h>
#import <HwMobileSDK/HwSegmentSpeedTestSubModels.h>

NS_ASSUME_NONNULL_BEGIN


@interface HwStartSegmentSpeedTestParam : NSObject

/** 分段索引(>0) */
@property (nonatomic , assign) NSInteger index;
/** 测速区间 */
@property (nonatomic , assign) HwSegmentSpeedTestTestRange testRange;
/** 数据发送方设备 mac，如果配置为空则是指数据发送设备为网关，否则是指 AP 或者 STA */
@property (nonatomic , copy) NSString *sendDevMac;
/** 数据接收方设备 mac，如果配置为空则是指数据发送设备为网关，否则是指 AP 或者 STA */
@property (nonatomic , copy) NSString *recvDevMac;
/** 上行开关 默认NO */
@property (nonatomic , assign) BOOL uploadSwitch;
/** 上行测速工具 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType uploadTestTool;
/** 上行测速工具的传输层协议 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol uploadTestProtocol;
/** 下行开关 默认NO */
@property (nonatomic , assign) BOOL downloadSwitch;
/** 下行测速工具 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType downloadTestTool;
/** 下行测速工具的传输层协议 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol downloadTestProtocol;
/** 上行时延测速开关 默认NO */
@property (nonatomic , assign) BOOL uploadLatencySwitch;
/** 上行时延测速工具 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType uploadLatencyTestTool;
/** 上行时延测速传输层协议 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol uploadLatencyProtocol;
/** 上行时延 */
@property (nonatomic , copy) NSString *uploadLatency;
/** 下行时延测速开关 默认NO */
@property (nonatomic , assign) BOOL downloadLatencySwitch;
/** 下行时延测速工具 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType downloadLatencyTestTool;
/** 下行时延测速传输层协议 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol downloadLatencyProtocol;
/** 下行时延 */
@property (nonatomic , copy) NSString *downloadLatency;
/** 云平台随机选取一个，插件只处理一个，如果插件侧收到一个 lsit，只会随机选择一个 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestRemoteAddrInfo *> *uploadRemoteAddrList;
/** 云平台随机选取一个，插件只处理一个，如果插件侧收到一个 lsit，只会随机选择一个 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestRemoteAddrInfo *> *downloadRemoteAddrList;
/** 测速时长，单位（秒），默认 10 秒，范围 [3-60s] */
@property (nonatomic , assign) NSInteger duration;

@end
NS_ASSUME_NONNULL_END
