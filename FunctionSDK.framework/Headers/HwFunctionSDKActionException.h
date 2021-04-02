#import <Foundation/Foundation.h>

/**
 *
 *  @brief SDK通用异常
 *
 *  @since 1.0
 */
@interface HwFunctionSDKActionException : NSObject

	//错误码	
	@property(nonatomic,copy) NSString *errorCode;

	//错误信息
	@property(nonatomic,copy)  NSString *errorMessage;
	
@end
