#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 设置用户头像操作结果(user avatar setting result)
 *
 *  @since 1.0
 */
@interface HwSetUserHeadPortraitResult : HwResult

/** 用户头像的值 (User avatar value)*/
@property (nonatomic, copy) NSString *userHeadPortraitMd5;

@end
