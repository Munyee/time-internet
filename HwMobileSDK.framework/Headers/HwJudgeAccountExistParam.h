//
//  HwJudgeAccountExistParam.h
//  MobileSDK
//
//  Created by wuwenhao on 17/10/31.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwParam.h>

/**
 待判断账号的账号类型

 - HwJudgeAccountExistTypeAccount: 账号
 - HwJudgeAccountExistTypePhone: 手机号
 - HwJudgeAccountExistTypeEmail: 电子邮箱
 */
typedef NS_ENUM(NSInteger, HwJudgeAccountExistType)
{
    HwJudgeAccountExistTypeAccount = 1,
    HwJudgeAccountExistTypePhone = 2,
    HwJudgeAccountExistTypeEmail = 3,
};

@interface HwJudgeAccountExistParam : HwParam

@property (nonatomic , assign) HwJudgeAccountExistType accountType;
@property (nonatomic , copy) NSString *account;

@end
