#import <Foundation/Foundation.h>
#import "HwTenantInfo.h"
/**
 业务开通状态(Service activation status)
 */
typedef enum
{
    /** 激活 (Activated) */
    kHwGatewayServiceStateActive,
    /** 去激活 (Deactivated)*/
    kHwGatewayServiceStateDeactive,
    /** 已超期 (Expired)*/
    kHwGatewayServiceStateOverdue
} HwGatewayServiceState;

/**
 *  
 *
 *  @brief 用户管理的网关(gateway managed by a user)
 *
 *  @since 1.7
 */
@interface HwGatewayInfo : NSObject

/** 绑定网关的MAC地址(最长128字节，UTF-8编码) *(Bound gateway MAC address (128 bytes at most in UTF-8 code))*/
@property (nonatomic, copy) NSString *deviceId;

/** 网关的别名 (Gateway alias)*/
@property(nonatomic, copy) NSString *gatewayNickname;

/** 管理员账号 (Administrator account)*/
@property(nonatomic, copy) NSString *managerAccount;

/** 业务开通状态 (Service activation status)*/
@property (nonatomic) HwGatewayServiceState serviceState;

/** 网关所属的租户信息 */
@property (nonatomic, strong) HwTenantInfo *tenantInfo;

@end



