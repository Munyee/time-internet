#import <Foundation/Foundation.h>
#import "HwParam.h"

/**
 *  
 *
 *  @brief 登录参数(login parameters)
 *
 *  @since 1.0
 */
@interface HwLoginParam : HwParam

/** 账号 (Account) */
@property(nonatomic, copy) NSString *account;

/** 用户密码 (User password)*/
@property(nonatomic, copy) NSString *password;

/** APP版本号*/
@property(nonatomic, copy) NSString *appVersion;
@end
