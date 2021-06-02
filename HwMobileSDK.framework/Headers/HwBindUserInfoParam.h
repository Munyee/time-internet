#import <Foundation/Foundation.h>
#import "HwParam.h"
#import "HwUserService.h"
#import "HwCommonDefine.h"

/**
 *  
 *
 *  @brief 绑定用户信息请求参数(bound user information request parameters)
 *
 *  @since 1.0
 */
@interface HwBindUserInfoParam : HwParam

/** 绑定的手机号或邮箱 (Bound mobile number or email)*/
@property(nonatomic, copy) NSString *account;

/** 绑定类型 (Binding type)*/
@property(nonatomic) HwBindType bindType;

/** 验证码 (Verification code)*/
@property(nonatomic, copy) NSString *securityCode;

/** Session ID */
@property(nonatomic, copy) NSString *sessionID;

@end
