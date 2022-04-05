#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCommonDefine.h>
/**
 *
 *
 *  @brief 访客WIFI信息(guest Wi-Fi information)
 *
 *  @since 1.0
 */


typedef NS_ENUM(NSInteger, HwGuestWifiInfoEncryptMode)
{
    kHwGuestWifiInfoEncryptModeOPEN=1,
    kHwGuestWifiInfoEncryptModeSHARED=2,
    kHwGuestWifiInfoEncryptModeWPAPSK=3,
    kHwGuestWifiInfoEncryptModeWPAPSK2=4,
    kHwGuestWifiInfoEncryptModeMixdWPA2WPAPSK=5,
    kHwGuestWifiInfoEncryptModeWpaEnterprise=6,
    kHwGuestWifiInfoEncryptModeWpa2Enterprise=7,
    kHwGuestWifiInfoEncryptModeWpaWpa2Enterprise=8,
    kHwGuestWifiInfoEncryptModeWPASAE3=9,
    kHwGuestWifiInfoEncryptModeMixedWPASAE3 =10,
    kHwGuestWifiInfoEncryptModeWpa3Enterprise=11,
    kHwGuestWifiInfoEncryptModeWpa2Wpa3Enterprise =12,
};

@interface HwGuestWifiInfo : NSObject

/** 是否 启用 (Enabled or not)*/
@property(nonatomic) BOOL enabled;

/**服务是否开通 */
@property (nonatomic , assign) BOOL serviceEnable;

/** 客户网络WIFI SSID (Wi-Fi SSID of a guest network)*/
@property(nonatomic, copy) NSString *ssid;

/** 客户网络WIFI SSID序号 (Wi-Fi sequence number of a guest network)*/
@property(nonatomic) int ssidIndex;

/** 客户网络WIFI 密码 (Wi-Fi password of a guest network)*/
@property(nonatomic, copy) NSString *password;

/** 客户网络生效时长 (Guest network validity period)*/
@property(nonatomic) int duration;

/** 客户网络剩余时长(分钟) (Guest network remaining period)(min)*/
@property(nonatomic) int remaining;

/** 客户网络剩余时长（秒） (Guest network remaining period)(seconds)*/
@property(nonatomic) int remainSec;

/** 加密方式 */
@property(nonatomic, assign)HwGuestWifiInfoEncryptMode encrypt;

/** 是否支持根据频道设置不同的访客网络*/
@property(nonatomic) BOOL isRaidoTypeEnable;

/** 5G访客网络ssid */
@property(nonatomic) int ssidIndex5G;

/** 是否支持删除访客网络wifi*/
@property(nonatomic) BOOL isSupportDelGuestWiFi;

/** 频段类型，“G2P4”代表2.4G “G5“代表5G (Frequency band type. "G2P4" indicates 2.4G, and "G5" indicates 5G.)*/
@property (nonatomic, assign) HwRadioType radioType;

@end
