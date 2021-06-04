#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 下挂设备带宽信息(bandwidth information of a connected device)
 *
 *  @since 1.0
 */
@interface HwLanDeviceBandWidth : NSObject 
	
/** 网关下挂的设备MAC信息(最长64字节) (MAC address of a device connected to the gateway (64 bytes at most))*/
@property(nonatomic,strong) NSString * mac;

/** 表示下挂设备上行最大带宽，0表示不限 (Maximum uplink bandwidth of a connected device, value 0 representing no limit)*/
@property(nonatomic,assign) long usBandwidth;

/** 表示下挂设备下行最大带宽，0表示不限 (Maximum downlink bandwidth of a connected device, value 0 representing no limit)*/
@property(nonatomic,assign) long dsBandwidth;
	
@end
