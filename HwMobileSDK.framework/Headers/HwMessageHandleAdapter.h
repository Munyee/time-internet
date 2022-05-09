#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCallback.h>
#import <HwMobileSDK/HwActionException.h>
#import <HwMobileSDK/HwMessageHandle.h>

@class HwMessageData;

typedef void(^HwMessageHandle)(HwMessageData* message);
typedef void(^HwMessageException)(HwActionException * exception);

/**
 *  
 *
 *  @brief 消息回调适配器(message callback adapter)
 *
 *  @since 1.0
 */
@interface HwMessageHandleAdapter : NSObject<HwMessageHandle>

/** 正常回调句柄 (Normal callback handle)*/
@property(nonatomic,copy) HwMessageHandle handle;

/** 异常回调句柄 (Exception callback handle)*/
@property(nonatomic,copy) HwMessageException exception;
/**
 *  
 *
 *  @brief 处理正常回调(Process normal callback.)
 *
 *  @param message
 *
 *  @since 1.0
 */
-(void) handle:(HwMessageData*) message;

/**
 *  
 *
 *  @brief 处理异常回调(Process abnormal callback.)
 *
 *  @param exception
 *
 *  @since 1.0
 */
- (void)exception:(HwActionException *)exception;

@end
