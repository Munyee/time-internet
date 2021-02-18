//
//  HwDeleteFeedbackParam.h
//  HwMobileSDK
//
//  Created by ios on 2019/5/23.
//  Copyright © 2019 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HwDeleteFeedbackParam : NSObject
/** 意见反馈ID */
@property (nonatomic, strong) NSArray <NSString *> *feedbackIds;
@end

NS_ASSUME_NONNULL_END
