#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwResult.h>

/**
 *  
 *
 *  @brief 分享网关操作单个账户的操作结果
 *
 *  @since 1.7
 */
@interface HwShareGatewayAccountResult : HwResult

/** 账户 */
@property(nonatomic, copy) NSString *account;

/** 失败原因，成功则为空 */
@property(nonatomic, copy) NSString *failedReason;

/** 额外信息 */
@property(nonatomic, copy) NSString *addtionalInfo;

@end
