#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwUserInfo.h>

@class HwGatewayInfo;

@interface HwMultiFactor : NSObject

/** 多因素开关 */
@property (nonatomic, copy) NSString *enable;
/** 多因素类型 SMS */
@property (nonatomic, copy) NSString *type;
/** 多因素类型对应的取值 */
@property (nonatomic, copy) NSString *value;

@end

@interface HwAccountInfo : NSObject

/** 用户ID */
@property (nonatomic, copy) NSString *accountId;
/** 账号类型 */
@property (nonatomic, copy) NSString *accountType;
/** 昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 用户账号 */
@property (nonatomic, copy) NSString *userAccount;
/** 用户手机号 */
@property (nonatomic, copy) NSString *email;
/** 用户邮箱 */
@property (nonatomic, copy) NSString *phone;

@end

/**
 *  
 *
 *  @brief  用户登录信息(user login information)
 *
 *  @since 1.7
 */
@interface HwLoginInfo : HwUserInfo

/** 用户可管理的网关列表 (List of gateways that can be managed by users) */
@property(nonatomic, strong) NSMutableArray<HwGatewayInfo *> *gatewayInfoList;

/** 新域名 (domain)*/
@property(nonatomic,copy) NSString *domain;

/** 密码有效日*/
@property(nonatomic, copy) NSString *pwdRemainValidDays;

/** 密码距离过期时间*/
@property(nonatomic, copy) NSString *warnBeforePwdInvalidDays;

/** 账号到期时间 （天）*/
@property(nonatomic, copy) NSString *accountExpiredTime;

/** 账号剩余到期时间（天）*/
@property(nonatomic, copy) NSString *accountRemainTime;

/** 备机ip*/
@property(nonatomic, copy) NSString *backupServerIp;

/** 多因素认证*/
@property(nonatomic, strong) HwMultiFactor *multiFactorAuthentication;

/** 三方账号头像*/
@property(nonatomic, copy) NSString *headImgUrl;

/** 三方账号信息*/
@property(nonatomic, strong) NSArray <HwAccountInfo *>*accountInfo;
@end
