//
//  HwGetSegmentSpeedResult.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2019/4/17.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwSegmentSpeedTestMacro.h"
#import "HwSegmentSpeedTestSubModels.h"

NS_ASSUME_NONNULL_BEGIN

// 相关定义可以在开始测速的数据模型中找到
@interface HwGetSegmentSpeedResult : NSObject
/** 分段索引 */
@property (nonatomic , assign) NSInteger index;
/** 测速区间 */
@property (nonatomic , assign) HwSegmentSpeedTestTestRange testRange;
/** 测速任务结束时间 */
@property (nonatomic , strong) NSDate *reportDate;

/** 下行测速开关 */
@property (nonatomic , assign) BOOL downloadSwitch;
/** 下行测速工具 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType downloadTool;
/** 下行测速地址 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestRemoteAddrInfo *> *downloadRemoteAddr;
/** 下行测速状态 */
@property (nonatomic , assign) HwSegmentSpeedTestState downloadStatus;
/** 下行测速状错误码，只有发生错误（即 status 失败），才返回 */
@property (nonatomic , copy) NSString *downloadErrCode;
/** 平均下载速率 */
@property (nonatomic , assign) NSInteger downloadSpeed;
/** 下载字节数 */
@property (nonatomic , assign) NSInteger downloadBytes;
/** 下载总包数 */
@property (nonatomic , assign) NSInteger downloadPackets;
/** 下载丢包数 */
@property (nonatomic , assign) NSInteger downloadLossPackets;

/** 上行测速开关 */
@property (nonatomic , assign) BOOL uploadSwitch;
/** 上行测速工具 */
@property (nonatomic , assign) HwSegmentSpeedTestToolType uploadTool;
/** 上行测速地址 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestRemoteAddrInfo *> *uploadRemoteAddr;
/** 上行测速状态 */
@property (nonatomic , assign) HwSegmentSpeedTestState uploadStatus;
/** 上行测速状错误码，只有发生错误（即 status 失败），才返回 */
@property (nonatomic , copy) NSString *uploadErrCode;
/** 平均上传速率 */
@property (nonatomic , assign) NSInteger uploadSpeed;
/** 上传字节数 */
@property (nonatomic , assign) NSInteger uploadBytes;
/** 上传总包数 */
@property (nonatomic , assign) NSInteger uploadPackets;
/** 上传丢包数 */
@property (nonatomic , assign) NSInteger uploadLossPackets;

/** 下行时延开关 */
@property (nonatomic , assign) BOOL downloadLatencySwitch;
/** 下行时延工具 */
@property (nonatomic , assign) HwSegmentSpeedTestLatencyToolType downloadLatencyTool;
/** 下行时延协议 */
@property (nonatomic , copy) NSString *downloadLatencyProtocol;
/** 下行时延状态 */
@property (nonatomic , assign) HwSegmentSpeedTestState downloadLatencyStatus;
/** 下行时延错误码，只有发生错误（即 status 失败），才返回 */
@property (nonatomic , copy) NSString *downloadLatencyErrCode;
/** 下行时延结果 */
@property (nonatomic , assign) NSInteger downloadLatency;

/** 上行时延开关 */
@property (nonatomic , assign) BOOL uploadLatencySwitch;
/** 上行时延工具 */
@property (nonatomic , assign) HwSegmentSpeedTestLatencyToolType uploadLatencyTool;
/** 上行时延协议 */
@property (nonatomic , copy) NSString *uploadLatencyProtocol;
/** 上行时延状态 */
@property (nonatomic , assign) HwSegmentSpeedTestState uploadLatencyStatus;
/** 上行时延错误码，只有发生错误（即 status 失败），才返回 */
@property (nonatomic , copy) NSString *uploadLatencyErrCode;
/** 上行时延结果 */
@property (nonatomic , assign) NSInteger uploadLatency;

/** 附加信息列表 */
@property (nonatomic , strong) NSArray<HwSegmentSpeedTestAdditionalInfo *> *additionalInfoList;

@end

NS_ASSUME_NONNULL_END
