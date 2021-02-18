//
//  HwFamilyRegisterInfo.h
//  MobileSDK
//

//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwFamilyRegisterInfo : NSObject

/** 是否已加入家庭*/
@property (nonatomic, assign) BOOL isJoinFamily;
/** 家庭名称*/
@property (nonatomic, copy) NSString *familyName;
/** 家庭id*/
@property (nonatomic, copy) NSString *familyId;
/** 家庭创建者账号*/
@property (nonatomic, copy) NSString *creatorAccount;

@end
