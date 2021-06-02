#import <Foundation/Foundation.h>
#import "HwParam.h"

/**
 *  
 *
 *  @brief 修改密码请求参数(password change request parameters)
 *
 *  @since 1.0
 */
@interface HwModifyPasswordParam : HwParam

/** 账号 (Account) */
@property(nonatomic, copy) NSString *account;

/** 用户新密码 (New password)*/
@property(nonatomic, copy) NSString *password;

/** 原密码 (Old password)*/
@property(nonatomic, copy) NSString *oldPassword;

@end
