#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwPluginUpgradeProgressInfo.h>
#import <HwMobileSDK/HwResult.h>

/**
 *  
 *
 *  @brief 插件是否需要升级操作结果(plug-in upgrade need or not)
 *
 *  @since 1.0
 */
@interface HwIsNeededUpgradeResult : HwResult

/** 升级类型 (Upgrade type)*/
@property(nonatomic) kHwPluginUpgradeType upgradeType;

@end
