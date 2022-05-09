#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief WIFI下挂设备(mounted device)
 *
 *  @since 1.6.0
 */
@interface HwWifiDevice : NSObject

/** 下挂设备MAC地址 (MAC address of the mounted device)*/
@property(nonatomic, copy) NSString *mac;

/** 下挂设备IP (IP address of the mounted device)*/
@property(nonatomic, copy) NSString *ip;

/** 此终端所连接到的SSID名称 (AP of the SSID to which this terminal is connected)*/
@property(nonatomic, copy) NSString *ssid;

/** wifi下挂设备的信号强度 (Wi-Fi signal strength of the mounted device) */
@property(nonatomic) long powerLevel;

/** 上行设备实时速率,Kbps */
@property(nonatomic,assign)int upSpeed;

/** 下行设备实时速率,Kbps */
@property(nonatomic,assign)int downSpeed;


@end
