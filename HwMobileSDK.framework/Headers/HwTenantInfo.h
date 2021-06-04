//
//  HwTenantInfo.h
//  HwMobileSDK
//
//  Created by zhangbin on 2017/12/21.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwTenantInfo : NSObject

/** 租户信息 */
@property (nonatomic, copy)  NSString *tenantName;

/** 租户描述 */
@property (nonatomic, copy)  NSString *tenantDesc;

/** 租户自定义属性 */
@property (nonatomic, copy)  NSString *tenantAttribute;

@end
