#import <Foundation/Foundation.h>
#import "HwParam.h"
#import "HwCommonDefine.h"

/**
 *  
 *
 *  @brief (请求参数)注册用户((request parameters) registering a user)
 *
 *  @since 1.0
 */
@interface HwRegisterUserParam : HwParam

/** 账户类型 (Account type) */
@property(nonatomic) HwAccountType accountType;

/** 注册的账户 (Account)*/
@property(nonatomic, copy) NSString *account;

/** 账户密码 (Account password)*/
@property(nonatomic, copy) NSString *password;

/** 校验码 (Verification code)*/
@property(nonatomic, copy) NSString *securityCode;

/** Session ID */
@property(nonatomic, copy) NSString *sessionId;

/** 邮箱，可选 (Email)*/
@property(nonatomic, copy) NSString *email;

/** 手机号，可选 (phone)*/
@property(nonatomic, copy) NSString *phone;

/** 绑定验证码，phone不为空时必填 (phone Verification code)*/
@property(nonatomic, copy) NSString *emailSecurityCode;

/** 绑定email验证码，email不为空时必填 (email Verification code)*/
@property(nonatomic, copy) NSString *phoneSecurityCode;

/** 绑定email的sessionID (session id fo email)*/
@property(nonatomic,copy) NSString *emailSessionID;

/** 绑定手机的sessionID (session id fo phone)*/
@property(nonatomic,copy) NSString *phoneSessionID;
/** 租户ID，非必填，SaaS模式下，APP为某个租户定制的app，其内部可以指定租户id，保证注册到指定租户下面 */
@property(nonatomic,copy) NSString *tenantId;

/** 网关mac */
@property(nonatomic, copy) NSString *mac;
@end

