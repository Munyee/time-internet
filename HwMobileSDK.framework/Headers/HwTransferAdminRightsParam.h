//
//  HwTransferAdminRightsParam.h
//  MobileSDK
//
//  Created by oss on 2017/6/26.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwTransferAdminRightsParam : NSObject

//	获取到的验证码的sessionId
@property (nonatomic, copy) NSString *sessionId;

//	验证码
@property (nonatomic, copy) NSString *verifyCode;

//	新管理员的accountId
@property (nonatomic, copy) NSString *accountId;

@end
