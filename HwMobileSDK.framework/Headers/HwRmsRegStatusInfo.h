#import <Foundation/Foundation.h>



typedef enum
{
    kHwRmsRegStatusDEFAULT = 1,
    kHwRmsRegStatusTIMEOUT,
    kHwRmsRegStatusOK
} HwRmsRegStatus;

/**
 *  
 *
 *  @brief 查询网关在RMS的注册状态 (query the registration status of the gateway on the RMS)
 *
 *  @since 1.0
 */
@interface HwRmsRegStatusInfo : NSObject

/** 网关在RMS的注册状态 (Registration status of the gateway on the RMS)*/
@property (nonatomic) HwRmsRegStatus rmsRegStatus ;

@end
