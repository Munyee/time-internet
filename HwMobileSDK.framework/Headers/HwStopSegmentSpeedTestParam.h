//
//  HwStopSegmentSpeedTestParam.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2019/4/17.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwStopSegmentSpeedTestParam : NSObject
/** 测速任务 id */
@property (nonatomic , copy) NSString *taskId;
/** 分段索引，如果为 nil 或者为空数组，则表示停止整个任务 */
@property (nonatomic , strong) NSArray<NSString *> *indexList;

@end

NS_ASSUME_NONNULL_END
