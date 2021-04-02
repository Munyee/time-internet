#import <Foundation/Foundation.h>
#import "HwParam.h"
#import "HwCommonDefine.h"

/**
 *  
 *
 *  @brief 获取验证码请求参数(verification code acquisition request parameters)
 *
 *  @since 1.0
 */
@interface HwGetVerifyCodeParam : HwParam

/** 账号:手机号或Email (Account: mobile number or email)*/
@property(nonatomic, copy) NSString *account;

/** 账户类型 (Account type) */
@property(nonatomic) HwAccountType accountType;

/** 网关mac (Gateway mac) */
@property(nonatomic, copy) NSString *mac;

@end
