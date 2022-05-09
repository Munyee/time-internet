#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>

/**
 *  
 *
 *  @brief 设置其他用户备注请求参数
 *
 *  @since 1.7
 */
@interface HwSetUserCommentParam : HwParam

/** 账号 (Account) */
@property(nonatomic, copy) NSString *account;

/** 备注 (Comment) */
@property(nonatomic, copy) NSString *comment;

@end
