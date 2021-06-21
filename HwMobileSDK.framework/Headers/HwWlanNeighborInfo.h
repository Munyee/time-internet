#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 周边WIFI信息(Wi-Fi networks nearby)
 *
 *  @since 1.7
 */
@interface HwWlanNeighborInfo : NSObject

/** SSID名称(SSID name) */
@property(nonatomic, copy) NSString *ssidName;

/** MAC地址(MAC address) */
@property(nonatomic, copy) NSString *bssId;

/** 网络类型，取值"Ad-Hoc","AP"(Network type, "Ad-Hoc" or "AP") */
@property(nonatomic, copy) NSString *networkType;

/** 当前使用的信道(currently used channel) */
@property(nonatomic) int channel;

/** 信号强度(signal strength) */
@property(nonatomic) int rssi;

/** 使用的802.11标准，取值11a/11b/11g/11n/11ac(in-use 802.11 standard: 11a, 11b, 11g, 11n, or 11ac) */
@property(nonatomic, copy) NSString *standard;

@end
