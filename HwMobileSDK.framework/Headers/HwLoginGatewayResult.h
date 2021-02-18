#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 近端登录网关操作结果 (near-end gateway login result)
 *
 *  @since 1.6.0
 */
@interface HwLoginGatewayResult : HwResult

/** 近端登录的结果 (Near-end login result)*/
@property (nonatomic, assign) BOOL isSuccess;

/** 网关ID(gateway ID) */
@property (nonatomic, copy) NSString *deviceId;

@end
