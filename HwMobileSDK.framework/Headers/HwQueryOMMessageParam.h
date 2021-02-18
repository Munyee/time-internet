//
//  HwQueryOMMessageParam.h
//  HwMobileSDK
//
//  Created by ios on 2019/10/10.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwQueryOMMessageParam : NSObject

/**
 分页查询起始页数，从0开始
 */
@property (nonatomic, assign) NSInteger offset;

/**
 分页查询每页最大记录数
 */
@property (nonatomic, assign) NSInteger limit;

@end

NS_ASSUME_NONNULL_END
