#import <Foundation/Foundation.h>




/**
 *  
 *
 *  @brief 网关基本信息(basic gateway information)
 *
 *  @since 1.0
 */
@interface HwSystemInfo : NSObject

/** 网关上行口类型 (Gateway uplink port type)*/
typedef enum
{
    kHwGatewayUpLinkModeADSL2Plus = 1,
    kHwGatewayUpLinkModeLAN,
    kHwGatewayUpLinkModeVDSL,
    kHwGatewayUpLinkModeEPON,
    kHwGatewayUpLinkModeGPON,
    kHwGatewayUpLinkMode10GEOPN,
    kHwGatewayUpLinkModeXGPON
} HwGatewayUpLinkMode;

/** 软件版本 (Software version)*/
@property(nonatomic ,copy) NSString *swVersion;

/** 硬件版本 (Hardware version)*/
@property(nonatomic ,copy) NSString *hdVersion;

/** 网关型号 (Gateway model)*/
@property(nonatomic ,copy) NSString *productClass;

/** 上行口类型 (Uplink port type)*/
@property(nonatomic) HwGatewayUpLinkMode upLink;

/** 网关MAC (Gateway MAC address)*/
@property(nonatomic,copy) NSString *mac;

/** GPON OLT认证SN (GPON OLT authentication SN)*/
@property(nonatomic,copy) NSString *gponSn;

/** WAN侧IP地址*/
@property(nonatomic,copy) NSString *wanIPAddr;

/** 设备上电所经过的秒数*/
@property(nonatomic,assign) long sysDuration;

/** CPU占用*/
@property(nonatomic,assign) int cpuPercent;

/** 内存占用*/
@property(nonatomic,assign) int memPercent;

/** LAN侧IP地址*/
@property(nonatomic,copy) NSString *lanIPAddr;

/** 设备名称*/
@property(nonatomic,copy) NSString *devName;

/** wifi 频段(NCE新增)*/
@property(nonatomic,copy) NSString *wiFiBands;

/** 是否支持OKC自动对码功能(NCE新增)*/
@property (nonatomic,assign) BOOL okcCapability;

/** 最高标准模式 */
@property(nonatomic,copy) NSString *standardCapability;

/** 平台连接状态，"Failed" 或者 "Connected" */
@property(nonatomic,copy) NSString *platConnStatus;
/** 当前平台连接失败的原因 */
@property(nonatomic,copy) NSString *connFailReason;
/** 初始向导完成状态 */
@property(nonatomic,copy) NSString *configStatus;
/** 上一次网关下线原因 */
@property(nonatomic,copy) NSString *lastOfflineReason;
/** 上一次网关复位原因 */
@property(nonatomic,copy) NSString *lastResetReason;
/** 上一次网关复位来源 */
@property(nonatomic,copy) NSString *lastResetTerminal;

/** 时区移秒数，东经为正，西经为负，如东八区为8*3600=28800 */
@property(nonatomic,copy) NSString *timeZoneOffset;

@end
