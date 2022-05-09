//
//  HwLanEdgeOntInfo.h
//  HwMobileSDK
//
//  Created by ios1 on 2020/5/13.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 运行状态
 
 - HwLanEdgeOntInfoRunStateTypeOffline: 开启
 - HwLanEdgeOntInfoRunStateTypeOnline: 关闭
 - HwLanEdgeOntInfoRunStateTypeUNKNOWN: 未知
 */
typedef NS_ENUM(NSInteger , HwLanEdgeOntInfoRunStateType) {
    HwLanEdgeOntInfoRunStateTypeOffline,
    HwLanEdgeOntInfoRunStateTypeOnline,
    HwLanEdgeOntInfoRunStateTypeUNKNOWN = 999
};

/**
 配置状态
 
 - HwLanEdgeOntInfoConfigStateTypeInitial: 初始态
 - HwLanEdgeOntInfoConfigStateTypeConfig: 配置中
 - HwLanEdgeOntInfoConfigStateTypeNormal: 正常态
 - HwLanEdgeOntInfoConfigStateTypeFailed: 配置失败
 - HwLanEdgeOntInfoConfigStateTypeUNKNOWN: 未知
 */
typedef NS_ENUM(NSInteger , HwLanEdgeOntInfoConfigStateType) {
    HwLanEdgeOntInfoConfigStateTypeInitial,
    HwLanEdgeOntInfoConfigStateTypeConfig,
    HwLanEdgeOntInfoConfigStateTypeNormal,
    HwLanEdgeOntInfoConfigStateTypeFailed,
    HwLanEdgeOntInfoConfigStateTypeUNKNOWN = 999
};

/**
 匹配状态
 
 - HwLanEdgeOntInfoMatchStateTypeInitial: 初始态
 - HwLanEdgeOntInfoMatchStateTypeMismatch: 不匹配
 - HwLanEdgeOntInfoMatchStateTypeMatch: 匹配
 - HwLanEdgeOntInfoConfigStateTypeUNKNOWN: 未知
 */
typedef NS_ENUM(NSInteger , HwLanEdgeOntInfoMatchStateType) {
    HwLanEdgeOntInfoMatchStateTypeInitial,
    HwLanEdgeOntInfoMatchStateTypeMismatch,
    HwLanEdgeOntInfoMatchStateTypeMatch,
    HwLanEdgeOntInfoMatchStateTypeUNKNOWN = 999
};

NS_ASSUME_NONNULL_BEGIN

@interface HwLanEdgeOntInfo : NSObject

/** PON口索引 */
@property(nonatomic,copy) NSString * portIndex;

/** Edge ONT编号 */
@property(nonatomic,copy) NSString * ontId;

/** Edge ONT SN */
@property(nonatomic,copy) NSString * sn;

/** Edge ONT MAC地址 */
@property(nonatomic,copy) NSString * mac;

/** Edge ONT主机名信息 */
@property(nonatomic,copy) NSString * hostName;

/** 运行状态  取值：offline/online */
@property(nonatomic,assign) HwLanEdgeOntInfoRunStateType runState;

/** 配置状态 取值：初始态（initial），配置中（config），正常态（normal）和配置失败（failed） */
@property(nonatomic,assign) HwLanEdgeOntInfoConfigStateType configState;

/** 匹配状态  初始态(initial)，不匹配(mismatch)，匹配(match) */
@property(nonatomic,assign) HwLanEdgeOntInfoMatchStateType matchState;

/** Edge ONT测试距离，单位米 */
@property(nonatomic,copy) NSString * ontDistance;

/** Edge ONT上次上线的测试距离，单位米 */
@property(nonatomic,copy) NSString * ontLastDistance;

/** Edge ONT 最后一次下线原因 */
@property(nonatomic,copy) NSString * lastDownCause;

/** Edge ONT最后一次上线时间  UTC时间字符串 */
@property(nonatomic,copy) NSString * lastUpTime;

/** Edge ONT最后一次下线时间   UTC时间字符串 */
@property(nonatomic,copy) NSString * lastDownTime;

/** Edge ONT最后一次掉电时间  UTC时间字符串 */
@property(nonatomic,copy) NSString * lastDyingGaspTime;

/** Edge ONT在线的累计时长，单位秒 */
@property(nonatomic,copy) NSString * ontOnlineDuration;

/** Edge ONT系统启动后的累计时长，单位秒 */
@property(nonatomic,copy) NSString * ontSystemUpDuration;

/** Edge ONT内存使用率，百分比 */
@property(nonatomic,copy) NSString * memoryOccupation;

/** Edge ONT的cpu使用率，百分比   */
@property(nonatomic,copy) NSString * cpuOccupation;

/** Edge ONT CPU的温度，单位摄氏度   */
@property(nonatomic,copy) NSString * cpuTemperature;

/** Edge ONT PON口的发射光功率(单位：dbm)   */
@property(nonatomic,copy) NSString * txPower;

/** TXPower 表示发送光功率min；(单位：dBm) (Transmit optical power (dBm))*/
@property(nonatomic, copy) NSString *txPowerMin;

/** TXPower 表示发送光功率max；(单位：dBm) (Transmit optical power (dBm))*/
@property(nonatomic, copy) NSString *txPowerMax;

/**Edge ONT PON口的接收光功率(单位：dbm)   */
@property(nonatomic,copy) NSString * rxPower;

/** PON口的接收光功率Min(单位：dbm) */
@property(nonatomic,copy) NSString * rxPowerMin;

/** PON口的接收光功率Max(单位：dbm) */
@property(nonatomic,copy) NSString * rxPowerMax;

/** 主网关收到该Edge ONT 上行定帧错误 */
@property(nonatomic,assign) int miniOltDelimiter;

/** 主网关收到该Edge ONT 上行BIP错误 */
@property(nonatomic,assign) int miniOltBip;

/** 主网关收到该Edge ONT 上行HEC错误 */
@property(nonatomic,assign) int miniOltHec;

/** Edge ONT收到的下行BIP错误 */
@property(nonatomic,assign) int bip;

/** 从网关接收到网关的光功率 */
@property(nonatomic,copy) NSString *miniOltRxPower;

/** 从网关接收到网关的光功率最小值 */
@property(nonatomic,copy) NSString *miniOltRxPowerMin;

/** 从网关接收到网关的光功率最大值 */
@property(nonatomic,copy) NSString *miniOltRxPowerMax;
@end

NS_ASSUME_NONNULL_END
