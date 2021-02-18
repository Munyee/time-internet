#import <Foundation/Foundation.h>

#import "HwActionException.h"

/**
 *  
 *
 *  @brief SDK通用回调(general SDK callback)
 *
 *  @since 1.0
 */
@protocol HwCallback<NSObject>

/**
 * 回调句柄(Callback handle)
 * 
 * @param value
 */
- (void)handle:(id)value;

 /**
 * 异常处理(Troubleshooting)
 * 
 * @param exception 具体的异常信息(specific exception information)
 */
- (void)exception:(HwActionException *)exception;

@end
