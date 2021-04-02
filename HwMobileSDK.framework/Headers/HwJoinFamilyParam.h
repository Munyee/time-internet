//
//  HwJoinFamilyParam.h
//  MobileSDK
//
//  Created by oss on 2017/7/4.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
	kHwUserNameTypePhone = 1,
	kHwUserNameTypeEmail = 2,
	kHwUserNameTypeAccount = 3
} HwUserNameType;

@interface HwJoinFamilyParam : NSObject

//	账号
@property (nonatomic, copy) NSString *account;
//	昵称
@property (nonatomic, copy) NSString *nickName;
//	家庭id
@property (nonatomic, copy) NSString *familyId;
//	用户名类型
@property (nonatomic, assign) HwUserNameType userNameType;
//	网关管理账号
@property (nonatomic, copy) NSString *gatewayAdminAccount;
//	网关管理密码
@property (nonatomic, copy) NSString *gatewayAdminPassword;
//	本地WiFi下搜索到的设备MAC地址
@property (nonatomic, copy) NSString *deviceMac;

@end
