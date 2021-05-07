/**
 *  
 *
 *  @brief 判断AP升级()
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwIsApDeviceNeededUpgradeParam : HwResult

/** AP的MAC */
@property (nonatomic, copy)NSArray<NSString *> *apMacList;

@end
