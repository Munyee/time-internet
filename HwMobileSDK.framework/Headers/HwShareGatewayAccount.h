#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 分享网关的帐户信息
 *
 *  @since
 */
@interface HwShareGatewayAccount : NSObject

/** 账号，目前只支持手机号 */
@property(nonatomic, copy) NSString *account;

/** 备注 */
@property(nonatomic, copy) NSString *comment;

@end
