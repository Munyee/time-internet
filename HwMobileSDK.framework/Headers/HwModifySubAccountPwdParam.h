/**
 *  
 *
 *  @brief 修改子账号密码类(modify sub account param)
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>

@interface HwModifySubAccountPwdParam : NSObject

/** 子账号 (sub account)*/
@property(nonatomic,copy) NSString *account;

/** 子账号的密码 (sub account password)*/
@property(nonatomic,copy) NSString *password;
@end
