#import <Foundation/Foundation.h>
#import "HwGatewayBasicParam.h"

/**
 *  
 *
 *  @brief 重命名网关请求参数 (gateway renaming request parameters)
 *
 *  @since 1.6.0
 */
@interface HwRenameGatewayParam : HwGatewayBasicParam

/** 网关名称 (Gateway name)*/
@property(nonatomic, copy) NSString *gatewayName;

@end
