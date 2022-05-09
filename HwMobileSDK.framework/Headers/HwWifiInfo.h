#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwWlanRadioInfo.h>

typedef enum {
    HwSyncFlagCancel = 0,
    HwSyncFlagSync,
}HwSyncFlagType;

@interface HwSyncDevice : NSObject

/** mac*/
@property(nonatomic ,copy) NSString *mac;

/** 1同步，0取消*/
@property(nonatomic ,assign) HwSyncFlagType syncFlag;

@end

/**
 *
 *
 *  @brief WIFI信息 (Wi-Fi information)
 *
 *  @since 1.0
 */
@interface HwWifiInfo : NSObject

/**
 WIFI加密类型 (Wi-Fi encryption type)
 */
typedef enum
{
    /** 1. OPEN */
    kHwWifiEncryptModeOpen = 1,
    /**  2.SHARED */
    kHwWifiEncryptModeShared,
    /**  3.WPA-PSK */
    kHwWifiEncryptModeWpaPsk,
    /**  4.WPA2-PSK */
    kHwWifiEncryptModeWpaPsk2,
    /**  5.Mixd WPA2/WPA-PSK */
    kHwWifiEncryptModeMixed,
    /**  6.WPA-Enterprise */
    kHwWifiEncryptModeWpaEnterprise,
    /**  7.WPA2-Enterprise */
    kHwWifiEncryptModeWpa2Enterprise,
    /**  8.WPA-WPA2-Enterprise */
    kHwWifiEncryptModeWpaWpa2Enterprise,
    /**  9.WPASAE3 */
    kHwWifiEncryptModeWpaSae3,
    /**  10.MIXED-WPASAE3 */
    kHwWifiEncryptModeMixedWpaSae3,
    /**  11.WPA3-Enterprise */
    kHwWifiEncryptModeWpa3Enterprise,
    /**  12.WPA2-WPA3-Enterprise */
    kHwWifiEncryptModeWpa2Wpa3Enterprise,
}HwWifiEncryptMode;

typedef enum {
    //未定义
    kHwSetDualbandCombineUndefined=-1,
    //关闭双频合一
    kHwSetDualbandCombineOff,
    //开启双频合一
    kHwSetDualbandCombineOn
}HwSetDualbandCombineType;

/** WIFI SSID*/
@property(nonatomic ,copy) NSString *ssid;

/** WIFI 密码 (Wi-Fi password)*/
@property(nonatomic, copy) NSString *password;

/** ENCRYPT 加密方式 (Encryption mode)*/
@property(nonatomic, assign)HwWifiEncryptMode encrypt;

/** PowerLevel 网络功率，取值范围0-100，0表示Auto (Network power, ranging from 0 to 100, with value 0 for Auto)*/
@property(nonatomic, copy)NSString* powerLevel;

/** channel*/
@property(nonatomic, copy)NSString* channel;

/** channelsInUse(NCE支持)*/
@property(nonatomic,copy)NSString* channelsInUse;

/** enable YES- 启用 NO --不启用 (YES:enabled NO: disabled)*/
@property BOOL enable;

/**服务是否开通 */
@property (nonatomic , assign) BOOL serviceEnable;

/** 是否使能自动选择信道 */
@property(nonatomic, assign)BOOL isAutoChannelEnable;

/** SSID名字是否广播。TRUE表示启用广播，FALSE表示禁用广播（即隐藏） */
@property(nonatomic, assign)BOOL isSsidAdvertisementEnabled;

/** 频宽 */
@property(nonatomic, copy)NSString *frequencyWidth;

/** 标准（Wifi信号模式）  11bg/11ac/11n/11bgn/11gn/11a/11na等 */
@property(nonatomic, copy)NSString *standard;

/** ssidIndex */
@property (nonatomic, assign) int ssidIndex;

/** radioType */
@property (nonatomic, copy) NSString *radioType;

/** 发射功率 */
@property (nonatomic, copy) NSString *transmitPower;

/** 双频合一 */
@property (nonatomic, assign) HwSetDualbandCombineType dualbandCombine;

/** AcsMode */
@property (nonatomic, assign) HwAcsModeType acsMode;

/** WMM是否使能*/
@property (nonatomic, copy) NSString *wmmEnable;

/** 国家码*/
@property (nonatomic, copy) NSString *regulatoryDomain;

/** 最大用户数*/
@property (nonatomic, copy) NSString *maxUsers;

/** 在线用户*/
@property (nonatomic, copy) NSString *onlineUsers;

/** 接收报文数*/
@property (nonatomic, copy) NSString *recvPackets;

/** 发送报文数*/
@property (nonatomic, copy) NSString *sendPackets;

/** vlanId*/
@property (nonatomic, copy) NSString *vlanId;

/** 上行限速 Kbps，0表示不限速*/
@property (nonatomic, copy) NSString *upSpeed;

/** 下行限速 Kbps，0表示不限速*/
@property (nonatomic, copy) NSString *downSpeed;

/** ap列表*/
@property (nonatomic, strong) NSArray <HwSyncDevice *>*syncApList;

@end
