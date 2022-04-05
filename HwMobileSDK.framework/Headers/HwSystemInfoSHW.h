#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 网关基本信息 (basic gateway information)
 *
 *  @since 1.0
 */
@interface HwSystemInfoSHW : NSObject

/** 软件版本 (Software version)*/
@property(nonatomic ,copy) NSString *swVersion;

/** 硬件版本 (Hardware version)*/
@property(nonatomic ,copy) NSString *hdVersion;

/** 产品类别 (Product category)*/
@property(nonatomic ,copy) NSString *productClass;

/** CPU类别 (CPU category)*/
@property(nonatomic,copy) NSString *cpuClass;

/** 设备型号 (Device model)*/
@property(nonatomic,copy) NSString *devType;

/** 设备类型 (Device type)*/
@property(nonatomic,copy) NSString *devType1;

/** 设备能力 (Device capability)*/
@property(nonatomic,copy) NSString *capability;

/** 是否卡机分离网关 (Whether the gateway has its card and machine separate)*/
@property(nonatomic,copy) NSString *card;

/** 上行方式 (Uplink mode)*/
@property(nonatomic,copy) NSString *upLink;

/** 卡序列号 (Card sequence number)*/
@property(nonatomic,copy) NSString *cardno;

/** 0：不支持IPv6；1：支持IPv6;2:支持IPv6及DS-lite (0: IPv6 not supported; 1: IPv6 supported; 2: IPv6 and DS-lite supported)*/
@property(nonatomic,assign) int ipv6;

/** 是否支持VLAN绑定能力 0：不支持；1：支持 (Whether to support VLAN binding 0: not support; 1: support)*/
@property(nonatomic,copy) NSString *vlanBind;

/** 0：不支持;1:支持软开关;2：支持硬开关；3：同时支持软硬开关 (0: not supported; 1: soft switch supported; 2: hard switch supported; 3: soft switch and hard switch supported)*/
@property(nonatomic,assign) int led;

/** Flash大小，单位字节 (Flash memory size, in KB)*/
@property(nonatomic,copy) NSString *flashSize;

/** Ram大小，单位字节 (RAM size, in KB)*/
@property(nonatomic,copy) NSString *ramSize;

/** 设备类型 (Device type)*/
@property(nonatomic,copy) NSString *devName;

/** wifi模式 (Wi-Fi mode)*/
@property(nonatomic,copy) NSString *wifiMode;

/** FC能力及当前状态，0：不支持；1：支持 (FC capability and current status, 0: not supported; 1: supported)*/
@property BOOL nfc;

/** WAN侧IP地址 (WAN-side IP address)*/
@property(nonatomic,copy) NSString *wanIPAddr;

/** LAN侧IP地址 (LAN-side IP address)*/
@property(nonatomic,copy) NSString *lanIPAddr;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
