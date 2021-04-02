//
//  HwSystemServiceSave.h
//  HwMobileSDK
//

//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HwCallback;

@class HwFeedbackInfo;

/**
 *  
 *
 *  @brief 系统服务(system service)
 *
 *  @since 1.7
 */
@interface HwSystemServiceSave : NSObject

/**
 *  
 *
 *  @brief 意见反馈(feedback)
 *
 *  @param deviceId     网关ID (gateway ID)
 *  @param feedbackInfo 反馈信息(feedback information)
 *  @param callback     callback
 *
 *  @since 1.7
 */
- (void)feedback:(NSString *)deviceId withFeedbackInfo:(HwFeedbackInfo *)feedbackInfo
    withCallBack:(id<HwCallback>)callback;

@end
