/**
 *  
 *
 *  @brief 升级网关(Upgrade the gateway.)
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>
#import "HwResult.h"

typedef NS_ENUM(NSInteger, kHwApUpgradeState)
{
    kHwApUpgradeStateNONE = -1,
    kHwApUpgradeStateWAITING,
    kHwApUpgradeStateDOWNLOADING,
    kHwApUpgradeStateDOWNLOADED,
    kHwApUpgradeStateSUCCESS,
    kHwApUpgradeStateFAILURE,
    kHwApUpgradeStateRETRY
};

@interface HwApDeviceUpgradeInfo : HwResult

/** 目标版本 */
@property (nonatomic, copy)NSString *targetVersion;

/** 当前版本 */
@property (nonatomic, copy)NSString *currentVersion;

/** ap升级状态 */
@property (nonatomic, assign)kHwApUpgradeState apUpgradeState;

/** 版本更新说明 */
@property (nonatomic, copy)NSString *upgradeDesc;

/** AP是否需要升级 */
@property (nonatomic, assign)BOOL isNeedUpgrade;

/** apMac */
@property (nonatomic, copy)NSString *apMac;

@end
