#import <Foundation/Foundation.h>
@class HwLoginInfo;

/**
 *  
 *
 *  @brief 是否已经登录操作结果( @brief login result)
 *
 *  @since 1.0
 */
@interface HwIsLoginedResult : NSObject

/** 是否已经登录 (logged in or not)*/
@property(nonatomic) BOOL isLogined;

/** 登录信息 (Login information)*/
@property (nonatomic, strong) HwLoginInfo *loginInfo;

@end
