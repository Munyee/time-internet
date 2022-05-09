//
//  HwEvaluateParam.h
//  HwMobileSDK
//
//  Created by zhangwenjie on 2017/12/12.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kHwEvaluateTypeUnResolved = 2,//未解决
    kHwEvaluateTypeResolved//解决
} HwEvaluateType;

@interface HwEvaluateParam : NSObject
/** 意见反馈 */
@property (nonatomic ,copy) NSString *feedbackId;
/** 评价类型 */
@property (nonatomic ,assign) HwEvaluateType evaluateType;
@end
