//
//  HwGetGatewayNetQualityResult.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/26.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwGetGatewayNetQualityResult : NSObject
/** 时间点*/
@property (nonatomic, copy) NSString *timePoint;
/** 网关mac*/
@property (nonatomic, copy) NSString *gatewayMac;
/** 上行字节数*/
@property (nonatomic, copy) NSString *txBytes;
/** 下行字节数*/
@property (nonatomic, copy) NSString *rxBytes;
/** 上行流量周期均值*/
@property (nonatomic, copy) NSString *averTxRate;
/** 上行峰值速率*/
//@property (nonatomic, copy) NSString *maxTxRate;
/** 下行流量周期均值*/
@property (nonatomic, copy) NSString *averRxRate;
/** 下行峰值速率*/
//@property (nonatomic, copy) NSString *maxRxRate;
/** 数据统计时长*/
@property (nonatomic, copy) NSString *onlineTime;
/** txTraffic*/
@property (nonatomic, copy) NSString *txTraffic;
/** rxTraffic*/
@property (nonatomic, copy) NSString *rxTraffic;
/** 返回的全部数据 */
@property (nonatomic, strong) NSDictionary *allNetworkEQ;
/** 整体网络体验评分*/
//@property (nonatomic, copy) NSString *expScore;
/** 整体网络体验评级*/
//@property (nonatomic, copy) NSString *expGrade;
/** 干扰百分比*/
//@property (nonatomic, copy) NSString *interferencePercent;
/** PING时延*/
//@property (nonatomic, copy) NSString *pingRtt;
/** PING丢包率*/
//@property (nonatomic, copy) NSString *pingLossRate;
/** 2.4G信道*/
//@property (nonatomic, copy) NSString *channel;
/** 5G信道*/
//@property (nonatomic, copy) NSString *channel5g;
/** STA WIFI协商的接收速率最大值*/
//@property (nonatomic, copy) NSString *negotiationRxRateMax;
/** WIFI协商的接收速率平均值*/
//@property (nonatomic, copy) NSString *negotiationRxRateAvg;
/** WIFI协商的接收速率最小值*/
//@property (nonatomic, copy) NSString *negotiationRxRateMin;
/** WIFI协商的发送速率最大值*/
//@property (nonatomic, copy) NSString *negotiationTxRateMax;
/** WIFI协商的发送速率平均值*/
//@property (nonatomic, copy) NSString *negotiationTxRateAvg;
/** WIFI协商的发送速率最小值*/
//@property (nonatomic, copy) NSString *negotiationTxRateMin;

@end

NS_ASSUME_NONNULL_END
