#import "HwParam.h"

/**
 *  
 *
 *  @brief 绑定网关请求参数(gateway binding request parameters)
 *
 *  @since 1.0
 */
@interface HwBindGatewayParam : HwParam

/** 网关MAC(最长128字节) (Gateway MAC address (128 bytes at most))*/
@property(nonatomic, copy) NSString *deviceMAC;

/** 网关管理账户(最长32字节) (Gateway management account (32 bytes at most))*/
@property(nonatomic, copy) NSString *adminAccount;

/** 网关管理密码(最长32字节) (Gateway management password (32 bytes at most))*/
@property(nonatomic, copy) NSString *adminPassword;

/** 网关的别名 (Gateway alias)*/
@property(nonatomic, copy) NSString *gatewayNickName;

/** 业务发放的账号，可选 (Service provisioning account, optional)*/
@property(nonatomic, copy) NSString *serviceAccount;

/** 是否允许绑定一个网关 (is only bind once)*/
@property(nonatomic,assign) BOOL onlyBindOnce;

@end
