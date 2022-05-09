#import <Foundation/Foundation.h>

@class HwMessageData,HwActionException;

/**
 *  
 *
 *  @brief 消息回调句柄(message callback handle)
 *
 *  @since 1.0
 */
@protocol HwMessageHandle<NSObject>

/** 正常回调 (Normal callback)*/
- (void)handle:(HwMessageData *)message;

/** 异常回调 (Exception callback)*/
- (void)exception:(HwActionException *)exception;

@end
