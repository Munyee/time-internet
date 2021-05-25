//
//  HwGetGatewayNetQualityParam.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/25.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HwGetGatewayNetQualityFilter;
@class HwGetGatewayNetQualityShowOption;
NS_ASSUME_NONNULL_BEGIN

@interface HwGetGatewayNetQualityParam : NSObject
/** 网关mac */
@property (nonatomic, copy) NSString *mac;
/** 过滤条件 */
@property (nonatomic, strong) HwGetGatewayNetQualityFilter *filter;
/** 查询字段列表 */
@property (nonatomic, strong) HwGetGatewayNetQualityShowOption *showOption;
@end

/**
 统计周期

 - HwGetGatewayNetQualityFilterCycleFiveMin: 5min
 - HwGetGatewayNetQualityFilterCycleOneHour: 1hour
 - HwGetGatewayNetQualityFilterCycleOneDay: 1day
 */
typedef NS_ENUM(NSInteger , HwGetGatewayNetQualityFilterCycle) {
    HwGetGatewayNetQualityFilterCycleFiveMin,
    HwGetGatewayNetQualityFilterCycleOneHour,
    HwGetGatewayNetQualityFilterCycleOneDay,
};
@interface HwGetGatewayNetQualityFilter : NSObject
/** 统计周期 */
@property (nonatomic, assign) HwGetGatewayNetQualityFilterCycle cycle;
/** 开始时间 */
@property (nonatomic, strong) NSDate *startDate;
/** 结束时间 */
@property (nonatomic, strong) NSDate *endDate;
@end

@interface HwGetGatewayNetQualityShowOption : NSObject
/** 时间点(固定返回,不需要传参)*/
//@property (nonatomic, assign) BOOL timePoint;

/** 网关mac(固定返回,不需要传参)*/
//@property (nonatomic, assign) BOOL gatewayMac;
/** 上行字节数*/
@property (nonatomic, assign) BOOL txBytes;
/** 下行字节数*/
@property (nonatomic, assign) BOOL rxBytes;
/** 上行流量周期均值*/
@property (nonatomic, assign) BOOL averTxRate;
/** 上行峰值速率*/
//@property (nonatomic, assign) BOOL maxTxRate;
/** 下行流量周期均值*/
@property (nonatomic, assign) BOOL averRxRate;
/** 下行峰值速率*/
//@property (nonatomic, assign) BOOL maxRxRate;
/** 数据统计时长*/
@property (nonatomic, assign) BOOL onlineTime;
/** 字段拓展列表*/
@property (nonatomic, strong) NSArray<NSString *> *moreOptionList;
/** 整体网络体验评分*/
//@property (nonatomic, assign) BOOL expScore;
/** 整体网络体验评级*/
//@property (nonatomic, assign) BOOL expGrade;
/** 干扰百分比*/
//@property (nonatomic, assign) BOOL interferencePercent;
/** PING时延*/
//@property (nonatomic, assign) BOOL pingRtt;
/** PING丢包率*/
//@property (nonatomic, assign) BOOL pingLossRate;
/** 2.4G信道*/
//@property (nonatomic, assign) BOOL channel;
/** 5G信道*/
//@property (nonatomic, assign) BOOL channel5g;
/** STA WIFI协商的接收速率最大值*/
//@property (nonatomic, assign) BOOL negotiationRxRateMax;
/** WIFI协商的接收速率平均值*/
//@property (nonatomic, assign) BOOL negotiationRxRateAvg;
/** WIFI协商的接收速率最小值*/
//@property (nonatomic, assign) BOOL negotiationRxRateMin;
/** WIFI协商的发送速率最大值*/
//@property (nonatomic, assign) BOOL negotiationTxRateMax;
/** WIFI协商的发送速率平均值*/
//@property (nonatomic, assign) BOOL negotiationTxRateAvg;
/** WIFI协商的发送速率最小值*/
//@property (nonatomic, assign) BOOL negotiationTxRateMin;

@end

NS_ASSUME_NONNULL_END
