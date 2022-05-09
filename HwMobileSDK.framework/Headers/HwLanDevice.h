#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HwblackCause)
{
    kHwblackCauseManual = 0,
    kHwblackCauseParentControl
};
/**
 *  
 *
 *  @brief 下挂设备信息(information about a connected device)
 *
 *  @since 1.0
 */
@interface HwLanDevice : NSObject

/** 设备名称(最长256字节) (Device name (256 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 设备类型 (Device type)*/
@property(nonatomic,copy) NSString *type;

/** ap设备类型 (AP Device type)*/
@property(nonatomic,copy) NSString *apType;

/** 设备IP (Device IP address)*/
@property(nonatomic,copy) NSString *ip;

/** 设备MAC地址(最长64字节) (Device MAC address (64 bytes at most))*/
@property(nonatomic,copy) NSString *mac;

/** 下挂设备对应的端口 (Port corresponding to a connected device)*/
@property(nonatomic,copy) NSString *connectInterface;

/** wifi下挂设备的信号强度，LAN口的设备用0表示 (Signal strength of a device connected to the Wi-Fi network, value 0 representing a device providing a LAN port)*/
@property(nonatomic,assign) long powerLevel;

/** 下挂设备在线时间，(需终端支持)单位为秒 (Online period of a connected device (need to be supported by the terminal), in seconds)*/
@property(nonatomic,assign) long onlineTime;

/** 设备加速状态 (Device speed-up status)*/
@property BOOL speedupState;

/** 对应AP的MAC(最长64字节) (MAC address of the corresponding AP (64 bytes at most))*/
@property(nonatomic,copy) NSString *apMAC;

/** 上行设备实时速率,Kbps */
@property(nonatomic,assign)int upSpeed;

/** 下行设备实时速率,Kbps */
@property(nonatomic,assign)int downSpeed;

/** 黑名单标志 */
@property(nonatomic,assign)BOOL isBlackList;

/** 上行设备限速,Kbps */
@property(nonatomic,assign)int upLimitSpeed;

/** 下行设备限速,Kbps */
@property(nonatomic,assign)int downLimitSpeed;

/** 是否在线标记 */
@property(nonatomic,assign) BOOL onLine;

/**协商的下行速率 Mbps */
@property(nonatomic,assign) int downlinkNegotiationRate;

/**协商的上行速率 Mbps */
@property(nonatomic,assign) int uplinkNegotiationRate;

/** 是否是AP*/
@property(nonatomic,assign) BOOL isAp;

/** 上次在线时间*/
@property(nonatomic,assign) int lastOnlineTime;

/** 上次断线时间*/
@property(nonatomic,assign) int lastOfflineTime;

/** lanMac(WPS对码特有) */
@property(nonatomic,copy) NSString *lanMac;  //21

/** AP设备类型 */
@property(nonatomic,copy) NSString *apDeviceType;

/** 加入黑名单原因 */
@property(nonatomic , assign) HwblackCause blackCause;

/** 天线数量 */
@property(nonatomic,copy) NSString *antennaNumber;

/** radioType */
@property (nonatomic, copy) NSString *radioType;

/** 设备接入的WiFi名称 */
@property (nonatomic, copy) NSString *ssid;

//-(id)initWithString:(NSString*)devStr;

@end

@interface HwLanDeviceLevel : NSObject

/// 设备mac
@property (nonatomic, copy) NSString *mac;

/// 上级设备mac
@property (nonatomic, copy) NSString *parentMac;

/// 设备类型，AP、PLCM、device
@property (nonatomic, copy) NSString *nodeType;

/// 设备接入方式，Wireless、Ethernet、PLC、PON
@property (nonatomic, copy) NSString *accessMode;

@end
