#import <Foundation/Foundation.h>
#import "HwUserInfo.h"

@class HwGatewayInfo;

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
@end
