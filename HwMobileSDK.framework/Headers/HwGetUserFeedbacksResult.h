//
//  HwGetUserFeedbacksResult.h
//  HwMobileSDK
//
//  Created by zhangwenjie on 2017/12/12.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HwUserFeedBack.h"

@interface HwGetUserFeedbacksResult : NSObject
/** 未处理意见反馈数 */
@property (nonatomic ,assign) NSInteger initialCount;
/** 已处理意见反馈数 */
@property (nonatomic, assign) NSInteger processedCount;
/** 反馈列表 */
@property (nonatomic, strong) NSArray<HwUserFeedBack *>* userFeedbackList;
@end
