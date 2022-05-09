//
//  HwONUserInfo.h
//  MobileSDK
//
//  Created by wuwenhao on 17/12/27.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwOMUserInfo : NSObject

@property (nonatomic , copy) NSString *nickname;
@property (nonatomic , copy) NSString *account;
@property (nonatomic , copy) NSString *phoneNumber;

- (NSDictionary *) toDic;
- (id) initWithDic:(NSDictionary *)dic;

@end
