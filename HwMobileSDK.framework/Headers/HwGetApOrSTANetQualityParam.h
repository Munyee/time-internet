//
//  HwGetApOrSTANetQualityParam.h
//  HwMobileSDK
//
//  Created by guozheng on 2018/12/26.
//  Copyright © 2018 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwGetGatewayNetQualityParam.h"

NS_ASSUME_NONNULL_BEGIN
@class HwGetApOrSTANetQualityShowOption;
@interface HwGetApOrSTANetQualityParam : NSObject
/** ap 或者 STA 设备 mac，只有在查询指定的设备时传值，查询所有的不传值【传nil 或者 空串】 */
@property (nonatomic , copy) NSString *apOrSTAMac;
/** 过滤条件 */
@property (nonatomic , strong) HwGetGatewayNetQualityFilter *filter;
/** 查询字段列表 */
@property (nonatomic , strong) HwGetApOrSTANetQualityShowOption *showOption;
@end

@interface HwGetApOrSTANetQualityShowOption : NSObject
/** 接入方式 */
//@property (nonatomic, assign) BOOL accessMode;
//@property (nonatomic, assign) BOOL accessPoint;
/** 设备名称 */
@property (nonatomic, assign) BOOL deviceName;
/** 整体网络体验评级 */
//@property (nonatomic, assign) BOOL expGrade;
//@property (nonatomic, assign) BOOL expGrade24g;
//@property (nonatomic, assign) BOOL expGrade5g;
//@property (nonatomic, assign) BOOL firstOnlineTime;
/** 网关mac(固定返回,不需要传参)*/
//@property (nonatomic, assign) BOOL gatewayMac;
@property (nonatomic, assign) BOOL isAP;
//@property (nonatomic, assign) BOOL lastStatusChangeTime;
/** 设备mac(固定返回,不需要传参)*/
//@property (nonatomic, assign) BOOL mac;
/** WIFI协商的接收速率平均值 */
//@property (nonatomic, assign) BOOL negotiationRxRateAvg;
//@property (nonatomic, assign) BOOL negotiationRxRateAvg24g;
/** STA WIFI协商的接收速率最大值 */
//@property (nonatomic, assign) BOOL negotiationRxRateMax;
//@property (nonatomic, assign) BOOL negotiationRxRateMax24g;
/** WIFI协商的接收速率最小值 */
//@property (nonatomic, assign) BOOL negotiationRxRateMin;
//@property (nonatomic, assign) BOOL negotiationRxRateMin24g;
/** WIFI协商的发送速率平均值 */
//@property (nonatomic, assign) BOOL negotiationTxRateAvg;
//@property (nonatomic, assign) BOOL negotiationTxRateAvg24g;
/** WIFI协商的发送速率最大值 */
//@property (nonatomic, assign) BOOL negotiationTxRateMax;
//@property (nonatomic, assign) BOOL negotiationTxRateMax24g;
/** 在线时长 */
@property (nonatomic, assign) BOOL onlineTime;
/** 收包字节数 */
@property (nonatomic, assign) BOOL rBytes;
/** 收包速率最大值 */
//@property (nonatomic, assign) BOOL rMaxRate;
/** 收包平均速率 */
@property (nonatomic, assign) BOOL rRate;
/** WLAN频段 */
//@property (nonatomic, assign) BOOL radioType;
/** 发包字节数 */
@property (nonatomic, assign) BOOL sBytes;
/** 发包速率最大值 */
//@property (nonatomic, assign) BOOL sMaxRate;
/** 发包平均速率 */
@property (nonatomic, assign) BOOL sRate;

//@property (nonatomic, assign) BOOL ssidIndex;
//@property (nonatomic, assign) BOOL ssidName;
@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) NSArray<NSString *> *moreOptionList;
/** 时间点(固定返回,不需要传参)*/
//@property (nonatomic, assign) BOOL timePoint;
//@property (nonatomic, assign) BOOL wiFiBands;
@end


NS_ASSUME_NONNULL_END
