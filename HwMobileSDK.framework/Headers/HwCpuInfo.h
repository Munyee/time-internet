#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief CPU信息 (CPU information)
 *
 *  @since 1.6.0
 */
@interface HwCpuInfo : NSObject

/** CPU占用率 (CPU usage)*/
@property(nonatomic, copy) NSString *percent;

@end
