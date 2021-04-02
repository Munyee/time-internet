//
//  HwCheckVerifyCodeParam.h
//  MobileSDK
//
//  Created by oss on 17/3/16.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwParam.h"

typedef NS_ENUM(NSInteger, kHwSecurityCodeType)
{
	kHwSecurityCodeTypeREGISTERBYACCOUNT = 1,
    kHwSecurityCodeTypeREGISTERBYPHONE = 2,
    kHwSecurityCodeTypeFINDPWBYACCOUNT = 3,
    kHwSecurityCodeTypeFINDPWBYPHONE = 12,
    kHwSecurityCodeTypeFINDPWBYEMAIL = 13
};


@interface HwCheckVerifyCodeParam : HwParam

/** 验证码会话标识 */
@property (nonatomic, copy)NSString *sessionId;

/** 校验码的类型 */
@property (nonatomic, assign)kHwSecurityCodeType securityCodeType;

/** 账号 */
@property (nonatomic, copy)NSString *account;

/** 验证码 */
@property (nonatomic, copy)NSString *securityCode;

@end
