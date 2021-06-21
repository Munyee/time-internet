#import <Foundation/Foundation.h>
#import "HwParam.h"

/**
 *  
 *
 *  @brief 取消分享网关请求参数
 *
 *  @since 1.7
 */
@interface HwUnshareGatewayParam : HwParam

/** 账号列表 */
@property(nonatomic, strong) NSMutableArray *accountList;

@end
