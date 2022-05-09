//
//  HwSegmentTestSaveRecordParam.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/4/25.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwSegmentSpeedTestMacro.h>
#import <HwMobileSDK/HwSegmentSpeedTestSubModels.h>

NS_ASSUME_NONNULL_BEGIN

@class HwSegmentSpeedTestSaveRecordInfo;
@interface HwSegmentTestSaveRecordParam : NSObject
/** 设备 mac */
@property (nonatomic , copy) NSString *mac;
/** 开始时间 */
@property (nonatomic , strong) NSDate *createTime;
/** 记录信息 */
@property (nonatomic , strong) HwSegmentSpeedTestSaveRecordInfo *recordInfo;

@end


@class HwSegmentSpeedTestSaveSubRecordInfo;
@interface HwSegmentSpeedTestSaveRecordInfo : NSObject
/** 测试维度 */
@property (nonatomic , assign) HwSegmentSpeedTestDimension dimension;
/** 维度的设备 Mac */
@property (nonatomic , copy) NSString *dimensionDeviceId;
/** 分段测速0，一键测速1 */
@property (nonatomic , copy) NSString *testType;
/** 子记录列表 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestSaveSubRecordInfo *> *subRecordList;

@end


@interface HwSegmentSpeedTestSaveSubRecordInfo : NSObject
/** 测速时间，UTC */
@property (nonatomic , strong) NSDate *time;
/** index */
@property (nonatomic , assign) int index;
/** 测速区间 */
@property (nonatomic , assign) HwSegmentSpeedTestTestRange range;
/** 源设备 mac 或 url | eg1: STA 到 AP，填 STA 的 mac | eg2: STA 到测速服务器，填 STA 的 mac */
@property (nonatomic , copy) NSString *sourceDevice;
/** 目标设备 mac 或 url | eg1: STA 到 AP，填 AP 的 mac | eg2: STA 到测速服务器，填服务器的 url */
@property (nonatomic , copy) NSString *targetDevice;

/** 上行测速开关（从原设备到目的设备） */
@property (nonatomic , assign) BOOL uploadSpeedTestSwitch;
/** 下行测速开关（从目的设备到原设备） */
@property (nonatomic , assign) BOOL downloadSpeedTestSwitch;
/** 上行测速工具类型 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType uploadSpeedTestTool;
/** 下行测速工具类型 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType downloadSpeedTestTool;
/** 上行测速协议类型 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol uploadSpeedTestProtocol;
/** 下行测速协议类型 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol downloadSpeedTestProtocol;
/** 上行测速 URL/端口列表: */
@property (nonatomic , copy) NSString *uploadSpeedTestUrl;
/** 下行测速 URL/端口列表: */
@property (nonatomic , copy) NSString *downloadSpeedTestUrl;
/** 上行时延开关 */
@property (nonatomic , assign) BOOL uploadLatencySwitch;
/** 下行时延开关 */
@property (nonatomic , assign) BOOL downloadLatencySwitch;
/** 上行时延工具类型 */
@property (nonatomic , assign) HwSegmentSpeedTestLatencyToolType uploadLatencyTool;
/** 下行时延工具类型 */
@property (nonatomic , assign) HwSegmentSpeedTestLatencyToolType downloadLatencyTool;
/** 上行时延协议类型 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol uploadLatencyProtocol;
/** 下行时延协议类型 */
@property (nonatomic , assign) HwSegmentSpeedTestProtocol downloadLatencyProtocol;

/** 测速时长，单位秒 */
@property (nonatomic , copy) NSString *duration;
/** 下载字节数 */
@property (nonatomic , copy) NSString *downloadBytes;
/** 上传字节数 */
@property (nonatomic , copy) NSString *uploadBytes;
/** 下载总包数 */
@property (nonatomic , copy) NSString *downloadPackets;
/** 上传总包数 */
@property (nonatomic , copy) NSString *uploadPackets;
/** 下载丢失包数 */
@property (nonatomic , copy) NSString *downloadLossPackets;
/** 上传丢失包数 */
@property (nonatomic , copy) NSString *uploadLossPackets;
/** 平均下载速率，单位 Kbps */
@property (nonatomic , copy) NSString *downloadAverageSpeed;
/** 平均上传速率，单位 Kbps */
@property (nonatomic , copy) NSString *uploadAverageSpeed;
/** 下载峰值速率，单位 Kbps */
@property (nonatomic , copy) NSString *downloadPeakSpeed;
/** 上传峰值速率，单位 Kbps */
@property (nonatomic , copy) NSString *uploadPeakSpeed;
/** 上行平均返回时延，单位 ms */
@property (nonatomic , copy) NSString *downloadAverageLatency;
/** 下行平均返回时延，单位 ms */
@property (nonatomic , copy) NSString *uploadAverageLatency;

/** 上行测速结果 */
@property (nonatomic , copy) NSString *uploadSpeedTestResult;
/** 上行测速失败原因 */
@property (nonatomic , copy) NSString *uploadSpeedTestErrCode;
/** 下行测速结果 */
@property (nonatomic , copy) NSString *downloadSpeedTestResult;
/** 下行测速失败原因 */
@property (nonatomic , copy) NSString *downloadSpeedTestErrCode;
/** 上行时延测速结果 */
@property (nonatomic , copy) NSString *uploadLatencyResult;
/** 上行时延测速失败原因 */
@property (nonatomic , copy) NSString *uploadLatencyErrCode;
/** 下行时延测速结果 */
@property (nonatomic , copy) NSString *downloadLatencyResult;
/** 下行时延测速失败原因 */
@property (nonatomic , copy) NSString *downloadLatencyErrCode;

/** 附加信息列表 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestAdditionalInfo *> *additionalInfoList;

@end

NS_ASSUME_NONNULL_END
