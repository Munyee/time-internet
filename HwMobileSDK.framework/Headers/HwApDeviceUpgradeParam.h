/**
 *  
 *
 *  @brief 升级网关(Upgrade the gateway.)
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwResult.h>

@interface HwApDeviceUpgradeParam : HwResult

/** AP的MAC */
@property(nonatomic, copy)NSString *apMac;

@end
