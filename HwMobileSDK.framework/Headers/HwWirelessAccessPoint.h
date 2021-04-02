
#import <Foundation/Foundation.h>

/** 信号强度(signal strength) */
typedef NS_ENUM(NSInteger, HwSignalIntensity)
{
    kHwSignalIntensityHigh = 1,
    kHwSignalIntensityMedium,
    kHwSignalIntensityLow,
    kHwSignalIntensityNone
};

/** AP类型(AP type) */
typedef NS_ENUM(NSInteger, HwApType)
{
    kHwApTypePLC = 1,
    kHwApTypeWIFI,
    kHwApTypeETH,
    kHwApTypeUnknow = 999
};

/**
 *  
 *
 *  @brief AP信息(AP information)
 *
 *  @since 1.7
 */
@interface HwWirelessAccessPoint : NSObject

/** 设备序列号(device SN) */
@property(nonatomic, copy) NSString *uuid;

/** 设备类型(device type) */
@property(nonatomic, copy) NSString *deviceType;

/** 设备制造商OUI(device manufacturer OUI) */
@property(nonatomic, copy) NSString *manufacturerOUI;

/** 设备SN(device SN) */
@property(nonatomic, copy) NSString *serialNumber;

/** 硬件版本(hardware version) */
@property(nonatomic, copy) NSString *hardwareVersion;

/** 软件版本(software version) */
@property(nonatomic, copy) NSString *softwareVersion;

/** 设备状态(device status) */
@property(nonatomic, copy) NSString *deviceStatus;

/** 设备启动时间，设备的上线时间（以秒为单位）(device startup time, device access time (in the unit of second)) */
@property(nonatomic, copy) NSString *upTime;

/** 信号强度(signal strength) */
@property(nonatomic) HwSignalIntensity signalIntensity;

/** 当前信道(current channel) */
@property(nonatomic, copy) NSString *currentChannel;
/** 2.4g频段开关状态 */
@property (nonatomic , assign) BOOL radioType24gSwitch;
@property (nonatomic , copy) NSString *p24gCurrentChannel;
/** 5g频段开关状态 */
@property (nonatomic , assign) BOOL radioType5gSwitch;
@property (nonatomic , copy) NSString *p5gCurrentChannel;

/** AP MAC */
@property(nonatomic, copy) NSString *mac;

/** AP类型(AP type) */
@property(nonatomic) HwApType apType;

/** pclApMac(当AP接入类型ApType为PLC时，plcApMac为与该AP近端配对的AP MAC) */
@property(nonatomic, copy) NSString *plcApMac;

/** 父节点APMac(如果为空或者是ONT MAC,则认为该AP直连ONT，非空则认为下挂到对应的AP下) */
@property(nonatomic, copy) NSString *parentApMac;

/**协商的下行速率 Mbps */
@property (nonatomic , assign) int downlinkNegotiationRate;
/**协商的上行速率 Mbps */
@property (nonatomic , assign) int uplinkNegotiationRate;

/** 设备是否在线 */
@property (nonatomic , assign) BOOL onLineState;

@end

