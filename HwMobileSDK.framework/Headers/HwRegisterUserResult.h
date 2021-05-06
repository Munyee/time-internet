#import <Foundation/Foundation.h>
#import "HwResult.h"
#import "HwLoginInfo.h"
/**
 *  
 *
 *  @brief 注册用户操作结果(user registration result)
 *
 *  @since 1.0
 */
@interface HwRegisterUserResult : HwResult
/** 登录信息 (Login information)*/
@property (nonatomic, strong) HwLoginInfo *loginInfo;
@end
