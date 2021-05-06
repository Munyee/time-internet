#import <Foundation/Foundation.h>

#import "HwFunctionSDKActionException.h"

/**
 *
 *  @brief SDK通用回调
 *
 *  @since 1.0
 */
@protocol HwFunctionSDKCallback<NSObject>

	/**
     * 回调句柄
     * 
     * @param value
     */
	-(void) handle:(id) value;
	
	 /**
     * 异常处理
     * 
     * @param exception 具体的异常信息
     */
	-(void) exception:(HwFunctionSDKActionException *) exception;

@end
