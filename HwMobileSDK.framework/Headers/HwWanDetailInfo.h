#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief WAN详细信息( @brief WAN details)
 *
 *  @since 1.0
 */
@interface HwWanDetailInfo : NSObject

/** WAN的序号 (WAN number)*/
@property(nonatomic) int index;

/** 接口名称 (Interface name)*/
@property(nonatomic, copy) NSString *ifName;

/** 接口描述，取值同WAN口的TR069节点ServiceList定义 (Interface description, same value as ServiceList for the TR069 node of the WAN port)*/
@property(nonatomic, copy) NSString *serviceList;

/** 表示连接类型，取值同WAN口的TR069节点ConnectionType定义 (Connection type, same value as ConnectionType for the TR069 node of the WAN port)*/
@property(nonatomic, copy) NSString *connctionType;

/** VLANID(NaN表示未使能) (VLAN ID (value NaN for disabled VLAN))*/
@property(nonatomic, copy) NSString *vlanId;

/** 表示是802.1p优先级；(8021p优先级)(802.1p priority (8021p priority))*/
@property(nonatomic, copy) NSString *ieee8021p;

/** 表示连接状态，取值同WAN口的TR069节点 (Connection status, same value as the TR069 node of the WAN port)*/
@property(nonatomic, copy) NSString *connctionStatus;

/** 表示IP地址 (IP address)*/
@property(nonatomic, copy) NSString *ipAddress;

/** 表示子网掩码 (Subnet mask)*/
@property(nonatomic, copy) NSString *subNetMask;

/** 表示网关地址 (Gateway address)*/
@property(nonatomic, copy) NSString *gateWay;

/** 首选DNS (Preferred DNS)*/
@property(nonatomic, copy) NSString *dns1;

/** 备选DNS (Alternative DNS)*/
@property(nonatomic, copy) NSString *dns2;

/** 表示IPV6连接状态 (IPv6 connection status)*/
@property(nonatomic, copy) NSString *ipv6ConnectionStatus;

/** 表示IPV6的IP地址 (IP address of the IPv6)*/
@property(nonatomic, copy) NSString *ipv6IpAddress;

/** 表示IPV6的前缀长度 (IPv6 prefix length)*/
@property(nonatomic, copy) NSString *ipv6PrefixLength;

/** 表示IPV6的网关地址 (IPv6 gateway address)*/
@property(nonatomic, copy) NSString *ipv6Gateway;

/** 表示IPV6的首选DNS (Preferred IPv6 DNS)*/
@property(nonatomic, copy) NSString *ipv6Dns1;

/** 表示IPV6的备选DNS (Alternative IPv6 DNS)*/
@property(nonatomic, copy) NSString *ipv6Dns2;

/** 表示IPV6协商前缀 (IPv6 negotiation prefix)*/
@property(nonatomic, copy) NSString *ipv6Prifix;

/** 协议类型1(ipv4)、2(ipv6)、 3(ipv4+ipv6)*/
@property(nonatomic, copy) NSString *ipProtocol;

@end


