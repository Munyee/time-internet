#import <Foundation/Foundation.h>
#import "HwResult.h"
#import "HwTenantInfo.h"

typedef enum : NSUInteger {
    //普通租户
    kHwTenantTypeISP,
    //有代维权限的租户
    kHwTenantTypeMSP,
} HwTenantType;
/**
 Huawei
 *
 *  @brief 登录操作结果(login operation result)
 *
 *  @since 1.0
 */
@interface HwLoginResult : HwResult

@property (nonatomic , strong) HwTenantInfo *tenantInfo;

/** MSP/ISP */
@property (nonatomic, assign) HwTenantType tenantType;

/** 域名 (domain)*/
@property (nonatomic, copy) NSString *domain;

/** 备机ip*/
@property(nonatomic, copy) NSString *backupServerIp;
@end
