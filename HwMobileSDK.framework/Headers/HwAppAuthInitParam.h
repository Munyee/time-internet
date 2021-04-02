#import <Foundation/Foundation.h>
#import "HwAuthInitParam.h"

typedef NSString *(^HwCallbackAppAuthGetToken)(void);

/**
 *  
 *
 *  @brief 三方鉴权初始化请求参数(third-party authentication initialization request parameters)
 *
 *  @since 1.0
 */
@interface HwAppAuthInitParam : HwAuthInitParam

/** 用户名 (User name)*/
@property(nonatomic, copy) NSString *userName;

/** 获取鉴权Token的回调 (Obtain callback of an authentication token)*/
@property(nonatomic, copy) HwCallbackAppAuthGetToken getTokenHandle;

@end
