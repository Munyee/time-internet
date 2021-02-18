#import <Foundation/Foundation.h>
#import "HwControllerService.h"

/**
 *  
 *
 *  @brief PPPoE拨号状态 (PPPoE dialing status)
 *
 *  @since 1.6.0
 */
@interface HwPPPoEDialStatus : NSObject

/**
 *  
 *
 *  @brief IPV4状态 (IPv4 status)
 *
 *  @since 1.0
 */
@property(nonatomic) BOOL connectionStatus;

/**
 *  
 *
 *  @brief IPV4 WAN链接状态 (IPv4 WAN connection status)
 *
 *  @since 1.0
 */
@property(nonatomic) HwWANStatus wanStatus;

/**
 *  
 *
 *  @brief IPV4失败原因 (IPv4 failure cause)
 *
 *  @since 1.0
 */
@property(nonatomic) HwDialReason dialReason;

/**
 *  
 *
 *  @brief IPV6状态 (IPv6 cause)
 *
 *  @since 1.0
 */
@property(nonatomic) BOOL connectionStatus1;

/**
 *  
 *
 *  @brief IPV6 WAN链接状态 (IPv6 WAN connection status)
 *
 *  @since 1.0
 */
@property(nonatomic) HwWANStatus wanStatus1;

/**
 *  
 *
 *  @brief IPV6失败原因 (IPv6 failure cause)
 *
 *  @since 1.0
 */
@property(nonatomic) HwDialReason dialReason1;

/**
 *  
 *
 *  @brief 初始化参数 (initialization parameters)
 *
 *  @param ipv4Status
 *  @param ipv4WanStatus
 *  @param ipv4failReason
 *  @param ipv6Status 
 *  @param ipv6WanStatus
 *  @param ipv6failReason
 *
 *  @return 自身实例 (self instance)
 *
 *  @since 1.0
 */
- (instancetype)initWithIPV4ConnStatus:(BOOL)ipv4Status
                     withIPV4WanStatus:(HwWANStatus)ipv4WanStatus
                    withIPV4DialReason:(HwDialReason)ipv4failReason
                    withIPV6ConnStatus:(BOOL)ipv6Status
                     withIPV6WanStatus:(HwWANStatus)ipv6WanStatus
                    withIPV6DialReason:(HwDialReason)ipv6failReason;

@end
