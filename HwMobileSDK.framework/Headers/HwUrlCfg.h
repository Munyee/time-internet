//
//  HwUrlCfg.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/17.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#pragma mark 每天的上网时长设置
@interface HwSingleUrlConfig : NSObject

/// 描述
@property (nonatomic, copy) NSString *name;

/// 网址
@property (nonatomic, copy) NSString *url;

@end

#pragma mark 家长控制的网址列表
@interface HwUrlCfg : NSObject

/// 下发所有的url列表，不是增量的
@property (nonatomic, strong) NSArray <HwSingleUrlConfig *>*urlList;

/// 是否使能
@property (nonatomic, copy) NSString *enabled;
 
@end

NS_ASSUME_NONNULL_END
