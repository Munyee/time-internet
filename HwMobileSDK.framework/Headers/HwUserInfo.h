#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 用户信息(user information)
 *
 *  @since 1.0
 */
@interface HwUserInfo : NSObject

/** 用户账号 (User account) */
@property(nonatomic, copy) NSString *userAccount;

/** 用户头像 (User avatar)*/
@property(nonatomic, copy) NSString *headPortraitMd5;

/** 用户昵称 (User nickname)*/
@property(nonatomic, copy) NSString *nickname;

/** 用户手机 (User mobile)*/
@property(nonatomic, copy) NSString *phone;

/** 用户Email (User email)*/
@property(nonatomic, copy) NSString *email;

/** 是否为系统默认生成的账号 (Whether the account is generated by the system by default)*/
@property(nonatomic,assign) BOOL isDefaultAccount;

/** 用户ID (User accountID)*/
@property(nonatomic,copy) NSString *accountId;

/** 是否为开发者 (is Developer) */
@property(nonatomic,assign) BOOL isDeveloper;

/** 是否是默认密码*/
@property(nonatomic, copy) NSString *isDefaultPwd;

@end
