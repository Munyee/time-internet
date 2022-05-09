#import <Foundation/Foundation.h>


/**
    网关在云平台的注册状态 (Registration status of the gateway on the cloud platform)
 */
typedef enum
{
    kHwCloudRegStatusNotConnect = 0,   // 未连接 (Not connected)
    kHwCloudRegStatusConnecting,   // 正在尝试连接 (Attempting to connect...)
    kHwCloudRegStatusRegisting,    // 注册中(Registering...)
    kHwCloudRegStatusHeartbeating, // 心跳保持中 (Heartbeat keeping...)
    kHwCloudRegStatusHeartbeated,  // 等待下次心跳中(Waiting for the next heartbeat...)
    kHwCloudRegStatusRegisterError, // 注册失败 (Failed to register)
    kHwCloudRegStatusUnknow = 999,
} HwCloudStatusType;

/**
 *  
 *
 *  @brief 云平台注册状态 (Cloud platform registration status)
 *
 *  @since 1.6.0
 */
@interface HwCloudStatusInfo : NSObject

/** 网关在云平台的注册状态 (Registration status of the gateway on the cloud platform)*/
@property (nonatomic, assign) HwCloudStatusType cloudStatusType;

@end
