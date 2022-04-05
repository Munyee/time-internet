//
//  HwSimpleBindGatewayParam.h
//  HwMobileSDK
//
//  Created by guozheng on 2019/5/15.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwSimpleBindGatewayParam : NSObject
/** 网关 mac */
@property (nonatomic , copy) NSString *mac;
/** 网关登陆账号 */
@property (nonatomic , copy) NSString *gatewayAdminAccount;
/** 网关登陆密码 */
@property (nonatomic , copy) NSString *gatewayAdminPsw;
@end

NS_ASSUME_NONNULL_END
