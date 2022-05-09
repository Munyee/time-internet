//
//  HwLanPONPhysicalInfo.h
//  HwMobileSDK
//
//  Created by ios1 on 2020/5/13.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 端口当前的状态
 
 - HwPONPhysicalInfoPortStateTypeON: 开启
 - HwPONPhysicalInfoPortStateTypeOFF: 关闭
 - HwPONPhysicalInfoPortStateTypeUNKNOWN: 未知
 */
typedef NS_ENUM(NSInteger , HwPONPhysicalInfoPortStateType) {
    HwPONPhysicalInfoPortStateTypeON,
    HwPONPhysicalInfoPortStateTypeOFF,
    HwPONPhysicalInfoPortStateTypeUNKNOWN = 999
};

/**
 端口当前激光器状态
 
 - HwPONPhysicalInfoLaserStateTypeNormal: 正常
 - HwPONPhysicalInfoLaserStateTypeFail: 故障
 - HwPONPhysicalInfoLaserStateTypeUNKNOWN: 未知
 */
typedef NS_ENUM(NSInteger , HwPONPhysicalInfoLaserStateType) {
    HwPONPhysicalInfoLaserStateTypeNormal,
    HwPONPhysicalInfoLaserStateTypeFail,
    HwPONPhysicalInfoLaserStateTypeUNKNOWN = 999
};

@interface HwLanPONPhysicalInfo : NSObject

/** PON口索引 */
@property(nonatomic,copy) NSString * portIndex;

/** PON口的发射光功率(单位：dbm) */
@property(nonatomic,copy) NSString * txPower;

/** PON口的发射光功率Min(单位：dbm) */
@property(nonatomic,copy) NSString * txPowerMin;

/** PON口的发射光功率Max(单位：dbm) */
@property(nonatomic,copy) NSString * txPowerMax;

/** PON口的接收光功率(单位：dbm) */
@property(nonatomic,copy) NSString * rxPower;

/** PON口的接收光功率Min(单位：dbm) */
@property(nonatomic,copy) NSString * rxPowerMin;

/** PON口的接收光功率Max(单位：dbm) */
@property(nonatomic,copy) NSString * rxPowerMax;

/** 光模块的工作温度，（单位：C） */
@property(nonatomic,copy) NSString * temperature;

/** 光模块的供电电压（单位：V） */
@property(nonatomic,copy) NSString * vottage;

/** 光发送机的偏置电流（单位：mA） */
@property(nonatomic,copy) NSString * current;

/** 取值 ON/OFF 端口当前的状态。当将端口激光器关闭后，状态会变为OFF） */
@property(nonatomic,assign) HwPONPhysicalInfoPortStateType portState;

/** 取值 Normal/Fail 端口当前激光器状态。如果端口激光器故障，状态会为Fail */
@property(nonatomic,assign) HwPONPhysicalInfoLaserStateType laserState;

@end

NS_ASSUME_NONNULL_END
