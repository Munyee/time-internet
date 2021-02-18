#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 意见反馈操作结果(feedback operation result)
 *
 *  @since 1.7
 */
@interface HwFeedbackResult : HwResult

/** 日志上传是否成功(whether a log is uploaded successfully) */
@property (nonatomic) BOOL logResult;

/** 日志上传失败原因错误码(error code of the log uploading failure cause) */
@property(nonatomic, copy) NSString *logFailedReason;

/** 截图上传是否成功(whether screenshot upload succeeds) */
@property (nonatomic) BOOL screenshotResult;

/** 截图上传失败原因错误码(error code of the screenshot uploading failure cause) */
@property(nonatomic, copy) NSString *screenshotFailedReason;

@end
