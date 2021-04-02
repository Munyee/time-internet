#import <Foundation/Foundation.h>
#import "HwUserFeedBack.h"

/**
 *  
 *
 *  @brief 意见反馈信息(feedback)
 *
 *  @since 1.7
 */
@interface HwFeedbackInfo : NSObject

/** 意见描述(feedback description) */
@property(nonatomic, copy) NSString *feedbackDescription;

/** 接受系统反馈的邮箱(Email account that receives system feedback) */
@property(nonatomic, copy) NSString *email;

/** 用户电话 */
@property(nonatomic, copy) NSString *phone;

/** 日志文件zip包路径(path of the log file .zip package) */
@property(nonatomic, copy) NSString *logFileUrl;

/** 界面截图zip包路径(path of the screenshot .zip package) */
@property(nonatomic, copy) NSString *screenshotFileUrl;

/** 是否启用故障重现 */
@property(nonatomic,assign) BOOL reproduce;

/** 是否上传网关日志 */
@property(nonatomic,assign) BOOL uploadOntLog;

/** 需要上报日志的网关MAC地址*/
@property(nonatomic,copy) NSString *deviceId;

/** 问题类型 */
@property(nonatomic, assign) HwUserFeedbackGategory feedbackGategory;
@end
