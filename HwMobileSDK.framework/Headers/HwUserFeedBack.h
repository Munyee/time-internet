//
//  HwUserFeedBack.h
//  HwMobileSDK
//
//  Created by zhangwenjie on 2017/12/11.
//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    kHwUserFeedbackGategoryDevice,//设备问题
    kHwUserFeedbackGategoryNetwork,//网络问题
    kHwUserFeedbackGategoryApp,//App体验问题
    kHwUserFeedbackGategoryOther//其它问题
} HwUserFeedbackGategory;

typedef enum{
    kHwUserFeedbackStatusUnReply,//未回复
    kHwUserFeedbackStatusReply,//回复
    kHwUserFeedbackStatusUnSolved,//未解决
    kHwUserFeedbackStatusSovled//已解决
} HwUserFeedbackStatus;

typedef enum{
    kHwUserFeedbackReplyUnSolved,
    kHwUserFeedbackReplySolved
} HwUserFeedbackReply;

@interface HwUserFeedBack : NSObject
/** 意见反馈ID */
@property (nonatomic, copy) NSString * feedbackId;
/** 反馈人名 */
@property (nonatomic, copy) NSString * userName;
/** 反馈人联系方式 */
@property (nonatomic, copy) NSString * phone;
/** 反馈人邮箱 */
@property (nonatomic, copy) NSString * email;
/** 问题描述 */
@property (nonatomic, copy) NSString * content;
/** 问题详情 */
@property (nonatomic, copy) NSString * detail;
/** 问题类型 */
@property (nonatomic, assign) HwUserFeedbackGategory feedbackGategory;
/** 反馈时间 */
@property (nonatomic, strong) NSDate * dateTime;
/** 当前状态 */
@property (nonatomic, assign) HwUserFeedbackStatus status;
/** 对该反馈的回复 */
@property (nonatomic, assign) HwUserFeedbackReply reply;
/** 图片URL列表 */
@property (nonatomic, strong) NSArray<NSString *> * picUrlList;
/** 处理账户 */
@property (nonatomic, copy) NSString * processAccount;
/** 处理内容 */
@property (nonatomic, copy) NSString *processContent;
/** 处理时间 */
@property (nonatomic, strong) NSDate * processTime;
/** 装维人员电话 */
@property (nonatomic, copy) NSString * omUserPhone;
@end
