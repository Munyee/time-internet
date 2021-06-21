#import <Foundation/Foundation.h>

/**
 WIFI信号强度模式(Wi-Fi signal strength mode)
 */
typedef enum
{
    /** 很弱 (Very weak)*/
    kHwWifiTransmitPowerLevelSleep = 1,
    /** 弱 (Weak)*/
    kHwWifiTransmitPowerLevelConservation = 2,
    /** 标准 (Standard)*/
    kHwWifiTransmitPowerLevelStandard = 3,
    /** 超强 (Strong)*/
    kHwWifiTransmitPowerLevelSuperstrong = 4
} HwWifiTransmitPowerLevel;

/**
 *  
 *
 *  @brief WIFI信号强度信息(Wi-Fi signal strength information)
 *
 *  @since 1.0
 */
@interface HwWifiTransmitPowerLevelInfo : NSObject

/** wifi信号强度 (Wi-Fi signal strength)*/
@property (nonatomic) HwWifiTransmitPowerLevel powerLevel;

@end
