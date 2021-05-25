/**
 *  
 *
 *  @brief 近端登录网关请求参数 (near-end gateway modify gateway password request parameters)
 *
 *  @since
 */

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwModifyGatewayPasswordParam : HwResult

/** 网关管理旧密码 (Gateway management old password)*/
@property (nonatomic, copy) NSString *oldPassword;

///** 网关管理新密码 (Gateway management new password)*/
@property (nonatomic, copy) NSString *password;

@end
