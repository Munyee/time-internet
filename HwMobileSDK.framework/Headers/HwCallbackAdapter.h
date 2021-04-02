#import <Foundation/Foundation.h>

#import "HwCallback.h"
#import "HwActionException.h"

typedef void(^HwCallbackHandle)(id value);
typedef void(^HwCallbackException)(HwActionException * exception);

/**
 *  
 *
 *  @brief SDK回调处理器(SDK callback handler)
 *
 *  @since 1.0
 */
@interface HwCallbackAdapter : NSObject<HwCallback>

/** 正常回调句柄 (Normal callback handle)*/
@property(nonatomic,copy) HwCallbackHandle handle;

/** 异常回调句柄 (Exception callback handle)*/
@property(nonatomic,copy) HwCallbackException exception;

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

+ (void)successCallback:(id <HwCallback>)callback handle:(id)arg;
+ (void)failCallback:(id <HwCallback>)callback exception:(HwActionException *)exp;
@end
