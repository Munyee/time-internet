//
//  HwGetApOrSTANetQualityResult.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/26.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwGetApOrSTANetQualityResult : NSObject
/** 接入方式 */
//@property (nonatomic, copy) NSString *accessMode;
//@property (nonatomic, copy) NSString *accessPoint;
/** 设备名称 */
@property (nonatomic, copy) NSString *deviceName;
/** 整体网络体验评级 */
//@property (nonatomic, copy) NSString *expGrade;
//@property (nonatomic, copy) NSString *expGrade24g;
//@property (nonatomic, copy) NSString *expGrade5g;
//@property (nonatomic, copy) NSString *firstOnlineTime;
@property (nonatomic, copy) NSString *gatewayMac;
@property (nonatomic, copy) NSString *isAP;
//@property (nonatomic, copy) NSString *lastStatusChangeTime;
@property (nonatomic, copy) NSString *mac;
/** WIFI协商的接收速率平均值 */
//@property (nonatomic, copy) NSString *negotiationRxRateAvg;
//@property (nonatomic, copy) NSString *negotiationRxRateAvg24g;
/** STA WIFI协商的接收速率最大值 */
//@property (nonatomic, copy) NSString *negotiationRxRateMax;
//@property (nonatomic, copy) NSString *negotiationRxRateMax24g;
/** WIFI协商的接收速率最小值 */
//@property (nonatomic, copy) NSString *negotiationRxRateMin;
//@property (nonatomic, copy) NSString *negotiationRxRateMin24g;
/** WIFI协商的发送速率平均值 */
//@property (nonatomic, copy) NSString *negotiationTxRateAvg;
//@property (nonatomic, copy) NSString *negotiationTxRateAvg24g;
/** WIFI协商的发送速率最大值 */
//@property (nonatomic, copy) NSString *negotiationTxRateMax;
//@property (nonatomic, copy) NSString *negotiationTxRateMax24g;
/** 在线时长 */
@property (nonatomic, copy) NSString *onlineTime;
/** 收包字节数 */
@property (nonatomic, copy) NSString *rBytes;
/** 收包速率最大值 */
//@property (nonatomic, copy) NSString *rMaxRate;
/** 收包平均速率 */
@property (nonatomic, copy) NSString *rRate;
/** WLAN频段 */
//@property (nonatomic, copy) NSString *radioType;
/** 发包字节数 */
@property (nonatomic, copy) NSString *sBytes;
/** 发包速率最大值 */
//@property (nonatomic, copy) NSString *sMaxRate;
/** 发包平均速率 */
@property (nonatomic, copy) NSString *sRate;
//@property (nonatomic, copy) NSString *ssidIndex;
//@property (nonatomic, copy) NSString *ssidName;
@property (nonatomic, copy) NSString *status;
/** 时间点 */
@property (nonatomic, copy) NSString *timePoint;
/** 返回的全部信息 */
@property (nonatomic, strong) NSDictionary *allNetworkEQ;
//@property (nonatomic, copy) NSString *wiFiBands;
@end

NS_ASSUME_NONNULL_END
