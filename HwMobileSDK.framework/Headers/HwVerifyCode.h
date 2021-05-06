#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 验证码信息(verification code information)
 *
 *  @since 1.0
 */
@interface HwVerifyCode : NSObject

/** 验证码图片 (Verification code picture)*/
@property(nonatomic, strong) UIImage *verifyCodeImage;

/** 会话ID (Session ID)*/
@property(nonatomic, copy) NSString *sessionID;
    
@end
