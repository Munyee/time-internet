#import <Foundation/Foundation.h>

/**
 PON注册状态 (PON registration status)
 */
typedef enum
{
    kHwPonStatusNoRegNoAuth = 1,  // 未注册未授权 (Not registered or authorized)
    kHwPonStatusRegNoAuth,    // 已注册未授权 (Already registered but not authorized)
    kHwPonStatusRegAuth   // 已注册已授权 (Already registered and authorized)
} HwPonStatus;

/**
 *  
 *
 *  @brief PON口注册状态 (PON port registration status)
 *
 *  @since 1.0
 */
@interface HwPonStatusInfo : NSObject

/** PON口注册状态 (PON port registration status)*/
@property (nonatomic) HwPonStatus ponStatus;

@end
