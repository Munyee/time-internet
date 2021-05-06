#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 用户头像信息(user avatar information)
 *
 *  @since  1.0
 */
@interface HwUserHeadPortraitInfo : NSObject

/** 用户账号 (User account) */
@property(nonatomic, copy) NSString *userAccount;

/** 用户头像 (User portrait)*/
@property(nonatomic, copy) NSString *userHeadPortraitMd5;

/** 用户头像图片 (User avatar picture)*/
@property(nonatomic, strong) UIImage *userHeadPortrait;

/** 失败原因，成功则为空 */
@property(nonatomic, copy) NSString *failedReason;

@end
