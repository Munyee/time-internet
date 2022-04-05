//
//  HwFamilyInfo.h
//  HwMobileSDK
//
//  Created by ios on 2021/7/19.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwMemberInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwFamilyInfo : NSObject

/// familyID
@property (nonatomic, copy) NSString *familyID;

/// 家庭名称
@property (nonatomic, copy) NSString *familyName;

/// 创建者账号
@property (nonatomic, copy) NSString *createAccount;

/// 创建者id
@property (nonatomic, copy) NSString *createAccountId;

/// 管理员账号
@property (nonatomic, copy) NSString *adminAccount;

/// 网关状态
@property (nonatomic, copy) NSString *state;

/// 网关mac
@property (nonatomic, copy) NSString *mac;

/// 网关型号
@property (nonatomic, copy) NSString *model;

/// ap数量
@property (nonatomic, copy) NSString *apCount;

/// ap在线数量
@property (nonatomic, copy) NSString *apOnlineCount;

/// sta数量
@property (nonatomic, copy) NSString *staCount;

/// sta在线数量
@property (nonatomic, copy) NSString *staOnlineCount;

/// 家庭成员列表
@property (nonatomic, strong) NSArray <HwMemberInfo *>*memberInfoList;

- (id)initWithDic:(NSDictionary *)dic;

- (BOOL)isOnline;
@end

NS_ASSUME_NONNULL_END
