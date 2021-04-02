#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 应用插件操作命令透传接口操作结果
 *
 *  @since 1.0
 */
@interface HwApplicationDoActionResult : HwResult

/** 透传操作返回 */
@property(nonatomic, copy) NSString *result;

@end
