#import <Foundation/Foundation.h>
#import "HwUserInfo.h"

/**
 *  
 *
 *  @brief 可管理网关的用户信息
 *
 *  @since 1.7
 */
@interface HwMemberInfo : HwUserInfo

/** 用户备注 (User comment)*/
@property(nonatomic, copy) NSString *comment;

/** 是否为管理员 */
@property(nonatomic) BOOL isAdminAccount;

/** 上次登录时间 */
@property(nonatomic, strong) NSDate *lastLoginDate;


@end
