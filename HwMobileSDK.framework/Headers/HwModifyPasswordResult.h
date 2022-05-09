#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwResult.h>

/**
 *  
 *
 *  @brief 修改密码操作结果(password change result)
 *
 *  @since 1.0
 */
@interface HwModifyPasswordResult : HwResult

/// true-需要重新登录，false-不需要重新登录
@property (nonatomic, assign) BOOL isNeedLogin;

@end
