#import <Foundation/Foundation.h>
#import "HwParam.h"

/**
 *  
 *
 *  @brief 更换网关请求参数
 *
 *  @since 1.7
 */
@interface HwReplaceGatewayParam : HwParam

/** 在本地WIFI下搜索到的新网关设备MAC */
@property(nonatomic, copy) NSString *deviceMAC;

/** 网关管理账户(最长32字节) (Gateway management account (32 bytes at most))*/
@property(nonatomic, copy) NSString *gatewayAdminAccount;

/** 网关管理密码(最长32字节) (Gateway management password (32 bytes at most))*/
@property(nonatomic, copy) NSString *gatewayAdminPassword;

@end
