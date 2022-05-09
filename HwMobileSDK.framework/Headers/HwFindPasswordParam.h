#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>
#import <HwMobileSDK/HwCommonDefine.h>

/**
 *  
 *
 *  @brief 找回密码请求参数(password retrieval request parameters)
 *
 *  @since 1.0
 */
@interface HwFindPasswordParam : HwParam

/** 找回方式 (Retrieval mode)*/
@property(nonatomic) HwFindpwdFindType findType;

/** 账号 (Account) */
@property(nonatomic, copy) NSString *account;

/** 用户密码 (User password) */
@property(nonatomic, copy) NSString *password;

/** 验证码 (Verification code)*/
@property(nonatomic, copy) NSString *securityCode;

/** Session ID */
@property(nonatomic, copy) NSString *sessionID;

@end
