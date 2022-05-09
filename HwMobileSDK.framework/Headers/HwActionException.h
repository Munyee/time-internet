#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief SDK通用异常(SDK common exception)
 *
 *  @since 1.0
 */
@interface HwActionException : NSObject

/** 错误码 (Error code)*/
@property(nonatomic,copy) NSString *errorCode;

/** 错误信息 (Error information)*/
@property(nonatomic,copy) NSString *errorMessage;

/** 错误详细描述信息 (Error  detail information)*/
@property(nonatomic,copy) NSString *detailArgs;

/** 错误详细描述信息 (Error  detail message)*/
@property(nonatomic,copy) NSString *detailMessage;
@end
