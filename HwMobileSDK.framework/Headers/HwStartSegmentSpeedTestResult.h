//
//  HwStartSegmentSpeedTestResult.h
//  HwMobileSDK
//
//  Created by wuwenhao on 2019/4/17.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface HwStartSegmentSpeedTestResult : NSObject
/** 业务返回结果，为 0 表示成功，其它值表示异常 */
@property (nonatomic , assign) NSInteger resultCode;
/** 成功启动测速服务的任务 id，只有 resultCode 为 0 时有效 */
@property (nonatomic , copy) NSString *taskId;
@end

NS_ASSUME_NONNULL_END
