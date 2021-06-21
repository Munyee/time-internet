#import <Foundation/Foundation.h>
#import "HwResult.h"

@class HwShareGatewayAccountResult;

/**
 *  
 *
 *  @brief 管理员分享网关给其他用户操作结果
 *
 *  @since 1.7
 */
@interface HwShareGatewayResult : HwResult

/** 成功列表 */
@property(nonatomic , strong) NSMutableArray<HwShareGatewayAccountResult *> *successList; // 20170911 1418 (nonatomic) -> (nonatomic , strong)

/** 失败列表 */
@property(nonatomic , strong) NSMutableArray<HwShareGatewayAccountResult *> *failList; // 20170911 1418 (nonatomic) -> (nonatomic , strong)

@end
