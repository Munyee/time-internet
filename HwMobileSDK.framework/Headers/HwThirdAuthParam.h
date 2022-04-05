//
//  HwThirdAuthParam.h
//  HwMobileSDK
//
//  Created by ios on 2021/7/23.
//  Copyright © 2021 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, kHwThirdPlatformType) {
    kHwThirdPlatformWechat = 4,         //微信
    kHwThirdPlatformHuawei,             //华为（暂不支持）
};

NS_ASSUME_NONNULL_BEGIN

@interface HwThirdAuthParam : NSObject

@property (nonatomic, copy) NSString *appId;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *signedVersion;

@property (nonatomic, copy) NSString *appVersion;

@property (nonatomic, copy) NSString *lang;

@property (nonatomic, assign) kHwThirdPlatformType thirdPlatformAppType;

@end

NS_ASSUME_NONNULL_END
