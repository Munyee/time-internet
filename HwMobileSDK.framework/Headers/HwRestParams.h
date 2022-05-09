//
//  HwRestParams.h
//  HwMobileSDK
//
//  Created by lxp on 2022/2/23.
//  Copyright © 2022 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwRestParams : NSObject

/// HTTP Method（必须）
@property (nonatomic, strong) NSString *type;
/// HTTP Content-Type（可选） 为空使用SDK默认设置，否则会替换SDK内的设置
@property (nonatomic, strong) NSString *contentType;
/// HTTP URL（必须）
@property (nonatomic, strong) NSString *url;
/// HTTP Body（可选）
@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
