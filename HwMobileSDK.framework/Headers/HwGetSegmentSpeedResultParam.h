//
//  HwGetSegmentSpeedResultParam.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2019/4/17.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwGetSegmentSpeedResultParam : NSObject
/** 测试任务 id */
@property (nonatomic , copy) NSString *taskId;
@end

@interface HwQuerySegmentSpeedProcessParam : NSObject

/** 测试任务 id */
@property (nonatomic , copy) NSString *taskId;

/** 查询索引 */
@property (nonatomic , copy) NSArray <NSString *>*indexList;

@end
NS_ASSUME_NONNULL_END
