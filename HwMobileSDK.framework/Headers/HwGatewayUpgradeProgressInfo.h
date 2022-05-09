#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 升级过程信息(upgrade process information)
 *
 *  @since 1.0
 */
@interface HwGatewayUpgradeProgressInfo : NSObject

/** 升级过程状态 (Upgrade process status)*/
typedef enum
{
    /** 升级成功 (Upgrade succeeded)*/
    kHwUpgradeStatusSucessed,
    /** 升级失败 (Upgrade failed)*/
    kHwUpgradeStatusFailed,
    /** 升级中 (Upgrading...)*/
    kHwUpgradeStatusProcessing
} HwUpgradeStatus;

/** 网关升级状态 (Gateway upgrade status)*/
@property(nonatomic) HwUpgradeStatus upgradeStatus;

/** 网关升级进度 (Gateway upgrade progress)*/
@property(nonatomic) double process;


@end
