/**
 *  
 *
 *  @brief 创建子账号参数类(create sub account param)
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>

@interface HwCreateSubAccountParam : NSObject
/** 子账号 (sub account)*/
@property(nonatomic,copy) NSString *account;

/** 子账号的密码 (sub account password)*/
@property(nonatomic,copy) NSString *password;

/** 子账号绑定的手机号，可选 (sub account phone,optional)*/
@property(nonatomic,copy) NSString *phone;

/** 子账号绑定的邮箱,可选 (sub account email,optional)*/
@property(nonatomic,copy) NSString *email;
@end
