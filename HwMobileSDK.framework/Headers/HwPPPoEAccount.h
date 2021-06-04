#import <Foundation/Foundation.h>
#import "HwControllerService.h"

/**
 *  
 *
 *  @brief PPPoE账户信息 (PPPoE account information)
 *
 *  @since 1.0
 */
@interface HwPPPoEAccount : NSObject

@property (nonatomic, copy) NSString *wanName;

/**
 *  
 *
 *  @brief 账户 (account)
 *
 *  @since 1.0
 */
@property (nonatomic, copy) NSString *account;

/**
 *  
 *
 *  @brief PPPoE密码 (PPPoE password)
 *
 *  @since 1.0
 */
@property (nonatomic, copy) NSString *password;

/**
 *  
 *
 *  @brief 拨号模式 (dialing mode)
 *
 *  @since 1.0
 */
@property (nonatomic) HwDialMode dialMode;

/**
 *  
 *
 *  @brief 空闲时间 (idle time)
 *
 *  @since 1.0
 */
@property (nonatomic, assign) int idleTime;

/**
 *  
 *
 *  @brief 初始化方法 (initialization method)
 *
 *  @param wanName
 *  @param account  账户名称 (account name)
 *  @param psw      账户密码 (account password)
 *  @param dialMode
 *
 *  @return 返回初始化后的自身实例 (return a self instance after initialization)
 *
 *  @since 1.0
 */
-(instancetype)initWithWanName:(NSString *)wanName
                       account:(NSString *)account
                      passWord:(NSString *)psw
                      dialMode:(HwDialMode)dialMode
                      idleTime:(int)idleTime;

/**
 *  
 *
 *  @brief 根据模式获取对应的字符串 (obtain a corresponding character string according to the mode)
 *
 *  @param dialModeType 模式的枚举信息 (enumerated mode information)
 *
 *  @return 返回的字符串 (returned character string)
 *
 *  @since 1.0
 */
- (NSString *)getDialModeStr:(HwDialMode)dialModeType;

@end
