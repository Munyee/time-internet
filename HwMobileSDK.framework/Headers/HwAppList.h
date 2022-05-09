//
//  HwAppList.h
//  HwMobileSDK
//
//  Created by ios on 2020/9/17.
//  Copyright © 2020 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark APPList
@interface HwAppList : NSObject

/// 允许的小类app列表
@property (nonatomic, strong) NSArray *enableList;

/// 禁止的小类app列表
@property (nonatomic, strong) NSArray *disableList;
 
@end

#pragma mark APP大类
@interface HwClassCfg : NSObject

/// 大类名
@property (nonatomic, copy) NSString *className;

/// 是否可用
@property (nonatomic, copy) NSString *enabled;

/// 家长控制的app列表
@property (nonatomic, strong) HwAppList *appList;
 
@end

NS_ASSUME_NONNULL_END
