#import <Foundation/Foundation.h>
/**
 WIFI隐藏状态 (Wi-Fi hidden status)
 */
typedef enum
{
    HwWifiHideStatusON = 0,
    HwWifiHideStatusOFF
}HwWifiHideStatus;

/**
 *  
 *
 *  @brief wifi隐藏状态 (Wi-Fi hiding status)
 *
 *  @since 1.0
 */
@interface HwWifiHideInfo : NSObject

/** wifi隐藏状态(wifi hide status)*/
@property (nonatomic) HwWifiHideStatus wifiHideStatus;

/** wifi ssid index(wifi ssid index)*/
@property(nonatomic,assign) NSInteger ssidIndex;

@end
