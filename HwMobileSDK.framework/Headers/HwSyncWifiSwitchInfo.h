#import <Foundation/Foundation.h>

/**
 同步WiFi开关到外置AP开关(Switch for synchronizing Wi-Fi switch setting to an external AP)
 */
typedef enum
{
    /** 同步WiFi开关到外置AP开关：开 (Switch for synchronizing Wi-Fi switch setting to an external AP: On)*/
    kHwSyncWifiSwitchEnable = 1,
    /** 同步WiFi开关到外置AP开关：关 (Switch for synchronizing Wi-Fi switch setting to an external AP: Off)*/
    kHwSyncWifiSwitchDisable
}HwSyncWifiSwitch;

/**
 *  
 *
 *  @brief 同步WiFi开关到外置AP的配置信息(configuration for synchronizing Wi-Fi switch setting to an external AP )
 *
 *  @since 1.6
 */
@interface HwSyncWifiSwitchInfo : NSObject

/** 同步WiFi开关到外置AP开关 (Switch for synchronizing Wi-Fi switch setting to an external AP)*/
@property (nonatomic) HwSyncWifiSwitch wifiSwitch;

@end
