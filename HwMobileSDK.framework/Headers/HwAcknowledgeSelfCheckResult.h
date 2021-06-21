#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief  确认一键体检的结果 (acknowledge result)
 *
 *  @since
 */
@interface HwAcknowledgeSelfCheckResult : HwResult

/** 确认返回() */
@property (nonatomic, assign)BOOL isSuccess;


@end
