//
//  HwSegmentSpeedTestMacro.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/5/18.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 测速区间
 
 - HwSegmentSpeedTestTestRangeSTA2AP: "STA_AP"
 - HwSegmentSpeedTestTestRangeSTA2GATEWAY: "STA_GATEWAY"
 - HwSegmentSpeedTestTestRangeSTA2SERVER: "STA_SERVER"
 - HwSegmentSpeedTestTestRangeAP2AP: "AP_AP"
 - HwSegmentSpeedTestTestRangeAP2GATEWAY: "AP_GATEWAY"
 - HwSegmentSpeedTestTestRangeAP2SERVER: "AP_SERVER"
 - HwSegmentSpeedTestTestRangeGATEWAY2SERVER: "GATEWAY_SERVER"
 - HwSegmentSpeedTestTestRangeUNKNOWN: 异常
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestTestRange) {
    HwSegmentSpeedTestTestRangeSTA2AP,
    HwSegmentSpeedTestTestRangeSTA2GATEWAY,
    HwSegmentSpeedTestTestRangeSTA2SERVER,
    HwSegmentSpeedTestTestRangeAP2AP,
    HwSegmentSpeedTestTestRangeAP2GATEWAY,
    HwSegmentSpeedTestTestRangeAP2SERVER,
    HwSegmentSpeedTestTestRangeGATEWAY2SERVER,
    HwSegmentSpeedTestTestRangeUNKNOWN = 999,
};

/**
 分段测试使用工具类型
 
 - HwSegmentSpeedTestToolTypeIPERF: "iperf"
 - HwSegmentSpeedTestToolTypePKTGEN: "pktgen"
 - HwSegmentSpeedTestToolTypeHTTP: "http"
 - HwSegmentSpeedTestToolTypeUNKNOWN: 异常
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestToolType) {
    HwSegmentSpeedTestToolTypeIPERF,
    HwSegmentSpeedTestToolTypePKTGEN,
    HwSegmentSpeedTestToolTypeHTTP,
    HwSegmentSpeedTestToolTypeUNKNOWN = 999,
};

/**
 分段测试使用协议类型
 
 - HwSegmentSpeedTestProtocolTCP: "TCP"
 - HwSegmentSpeedTestProtocolUDP: "UDP"
 - HwSegmentSpeedTestProtocolUNKNOWN: 异常
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestProtocol) {
    HwSegmentSpeedTestProtocolTCP,
    HwSegmentSpeedTestProtocolUDP,
    HwSegmentSpeedTestProtocolUNKNOWN = 999,
};


/**
 internet 测速激活状态
 
 - HwSegmentSpeedTestConfigStateENABLE: 使能
 - HwSegmentSpeedTestConfigStateDISABLE: 去使能
 - HwSegmentSpeedTestConfigStateUNKNOWN: unknow
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestConfigState) {
    HwSegmentSpeedTestConfigStateENABLE,
    HwSegmentSpeedTestConfigStateDISABLE,
    HwSegmentSpeedTestConfigStateUNKNOWN = 999,
};

/**
 internet 测速协议
 
 - HwSegmentSpeedTestConfigProtocolHTTPGENERAL: unknown
 - HwSegmentSpeedTestConfigProtocolUNKNOWN: HTTP_GENERAL
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestConfigProtocol) {
    HwSegmentSpeedTestConfigProtocolHTTPGENERAL,
    HwSegmentSpeedTestConfigProtocolUNKNOWN = 999,
};

/**
 测速维度
 
 - HwSegmentSpeedTestDimensionALL: 查询所有
 - HwSegmentSpeedTestDimensionFAMILY: "FAMILY"
 - HwSegmentSpeedTestDimensionSTA: "STA"
 - HwSegmentSpeedTestDimensionUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestDimension) {
    HwSegmentSpeedTestDimensionALL,
    HwSegmentSpeedTestDimensionFAMILY,
    HwSegmentSpeedTestDimensionSTA,
    HwSegmentSpeedTestDimensionUNKNOWN = 999,
};


/**
 时延工具类型
 
 - HwSegmentSpeedTestLatencyToolTypeIPERF: "IPERF"
 - HwSegmentSpeedTestLatencyToolTypePING: "PING"
 - HwSegmentSpeedTestLatencyToolTypeUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestLatencyToolType) {
    HwSegmentSpeedTestLatencyToolTypeIPERF,
    HwSegmentSpeedTestLatencyToolTypePING,
    HwSegmentSpeedTestLatencyToolTypeUNKNOWN = 999,
};


/**
 设备类型
 
 - HwSegmentSpeedTestDeviceTypeSTA: STA
 - HwSegmentSpeedTestDeviceTypeAP: AP
 - HwSegmentSpeedTestDeviceTypeGATEWAY: GATEWAY
 - HwSegmentSpeedTestDeviceTypeUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestDeviceType) {
    HwSegmentSpeedTestDeviceTypeSTA,
    HwSegmentSpeedTestDeviceTypeAP,
    HwSegmentSpeedTestDeviceTypeGATEWAY,
    HwSegmentSpeedTestDeviceTypeUNKNOWN = 999,
};


/**
 设备接入方式
 
 - HwSegmentSpeedTestDeviceLinkTypeETH: ETH
 - HwSegmentSpeedTestDeviceLinkTypeWIFI: WIFI
 - HwSegmentSpeedTestDeviceLinkTypePLC: PLC
 - HwSegmentSpeedTestDeviceLinkTypeUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestDeviceLinkType) {
    HwSegmentSpeedTestDeviceLinkTypeETH,
    HwSegmentSpeedTestDeviceLinkTypeWIFI,
    HwSegmentSpeedTestDeviceLinkTypePLC,
    HwSegmentSpeedTestDeviceLinkTypeUNKNOWN = 999,
};

/**
 设备频段类型
 
 - HwSegmentSpeedTestDeviceRadioTypeG2P4: 2.4G
 - HwSegmentSpeedTestDeviceRadioTypeG5: 5G
 - HwSegmentSpeedTestDeviceRadioTypeUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestDeviceRadioType) {
    HwSegmentSpeedTestDeviceRadioTypeG2P4,
    HwSegmentSpeedTestDeviceRadioTypeG5,
    HwSegmentSpeedTestDeviceRadioTypeUNKNOWN = 999,
};


/**
 测速任务状态
 
 - HwSegmentSpeedTestStateNOTSTARTED: "NOTSTARTED"
 - HwSegmentSpeedTestStateTESTING: "TESTING"
 - HwSegmentSpeedTestStateFINISHED: "FINISHED"
 - HwSegmentSpeedTestStateFAILED: "FAILED"
 - HwSegmentSpeedTestStateUNKNOWN: unknown
 */
typedef NS_ENUM(NSInteger , HwSegmentSpeedTestState) {
    HwSegmentSpeedTestStateNOTSTARTED,
    HwSegmentSpeedTestStateTESTING,
    HwSegmentSpeedTestStateFINISHED,
    HwSegmentSpeedTestStateFAILED,
    HwSegmentSpeedTestStateUNKNOWN,
};



@interface HwSegmentSpeedTestMacro : NSObject

@end

NS_ASSUME_NONNULL_END
