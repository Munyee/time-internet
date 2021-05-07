#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 内存信息 (memory information)
 *
 *  @since 1.6.0
 */
@interface HwMemoryInfo : NSObject

/** 内存占用率 (Memory usage)*/
@property(nonatomic, copy) NSString *percent;

@end
