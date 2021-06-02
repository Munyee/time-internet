//
//  HwGetCloudFeatureParam.h
//  HwMobileSDK
//
//  Created by ios1 on 2020/5/19.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwGetCloudFeatureParam : NSObject

/** 账号 ，非必填*/
@property(nonatomic, copy) NSString *account;

/** 网关mac，非必填 */
@property(nonatomic, copy) NSString *mac;

/** 租户id，非必填 */
@property(nonatomic, copy) NSString *tenantId;

@end

NS_ASSUME_NONNULL_END
