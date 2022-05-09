#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 用户的匿名绑定信息(anonymous binding information of a user)
 *
 *  @since 1.7
 */
@interface HwUserAnonymousBindInfo : NSObject

/** 用户手机 (User mobile)*/
@property(nonatomic, copy) NSString *phone;

/** 用户Email (User email)*/
@property(nonatomic, copy) NSString *email;

@end
