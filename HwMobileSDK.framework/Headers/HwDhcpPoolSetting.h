#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief DHCP池设置信息 (DHCP pool settings)
 *
 *  @since 1.0
 */
@interface HwDhcpPoolSetting : NSObject

/** IP */
@property(nonatomic,strong) NSString *localIp;

/** 子网掩码 (Subnet mask)*/
@property(nonatomic,strong) NSString *submask;

/** 是否启用DHCP服务 (Whether to enable the DHCP service)*/
@property(nonatomic) BOOL enableDhcpServer;

/** DHCP地址池开始ip (Start IP address of the DHCP address pool)*/
@property(nonatomic,strong) NSString *dhcpStartIp;

/** DHCP地址池结束ip (End IP address of the DHCP address pool)*/
@property(nonatomic,strong) NSString *dhcpEndIp;

/** DHCP地址有效时长 (DHCP address validity period)*/
@property(nonatomic) int dhcpDuration;


@end
