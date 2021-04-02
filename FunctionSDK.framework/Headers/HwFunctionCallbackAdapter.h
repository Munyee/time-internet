#import <Foundation/Foundation.h>

#import "HwFunctionSDKCallback.h"
#import "HwFunctionSDKActionException.h"

typedef void(^HwFunctionSDKCallbackHandle)(id value);
typedef void(^HwFunctionSDKCallbackException)(HwFunctionSDKActionException * exception);

/**
 *  
 *
 *  @brief SDK回调处理器
 *
 *  @since 1.0
 */
@interface HwFunctionCallbackAdapter : NSObject<HwFunctionSDKCallback>

	//正常回调句柄
    @property(nonatomic,copy) HwFunctionSDKCallbackHandle handle;

	//异常回调句柄
    @property(nonatomic,copy) HwFunctionSDKCallbackException exception;

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
