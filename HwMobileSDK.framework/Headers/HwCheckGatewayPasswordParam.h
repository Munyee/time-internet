//
//  HwCheckGatewayPasswordParam.h
//  MobileSDK
//
//  Created by oss on 17/4/11.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwCheckGatewayPasswordParam : NSObject

/** 网关管理账号(gateway account) */
@property(nonatomic, copy)NSString *gatewayAdminAccount;

/** 网关管理密码(gateway password) */
@property(nonatomic, copy)NSString *gatewayAdminPassword;

@end
