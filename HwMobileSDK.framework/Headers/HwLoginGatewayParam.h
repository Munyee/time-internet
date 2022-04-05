
#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>

/**
 *  
 *
 *  @brief 近端登录网关请求参数 (near-end gateway login request parameters)
 *
 *  @since 1.6.0
 */
@interface HwLoginGatewayParam : HwParam

/** 网关管理帐号 (Gateway management account)*/
@property (nonatomic, copy) NSString *gatewayAdminAccount;

/** 网关管理密码 (Gateway management password)*/
@property (nonatomic, copy) NSString *gatewayAdminPassword;


@end
