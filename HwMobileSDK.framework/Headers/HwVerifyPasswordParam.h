//
//  HwVerifyPasswordParam.h
//  MobileSDK
//
//  Created by huangxiaogang on 17/6/22.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>
#import <HwMobileSDK/HwCommonDefine.h>

/**
 *   17-06-22 14:06:00
 *
 *  @brief 校验密码请求的参数
 *
 *  @since
 */
@interface HwVerifyPasswordParam : HwParam


/** 注册账号 (Account) */
@property(nonatomic, copy) NSString *registerAccount;

/** 密码 */
@property(nonatomic, copy) NSString *password;

/**  绑定类型 */
@property(nonatomic, assign) HwBindType bindType;

@end
