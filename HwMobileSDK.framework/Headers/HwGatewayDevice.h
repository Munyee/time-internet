#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 网关设备
 *
 *  @since 1.0
 */
@interface HwGatewayDevice : NSObject

/** 网关的设备ID */
@property(nonatomic,copy) NSString *deviceId;

/** MAC */
@property(nonatomic,copy) NSString *mac;

/** SN */
@property(nonatomic,copy) NSString *sn;

/** loid */
@property(nonatomic,copy) NSString *loid;

/** pppoeAccount */
@property(nonatomic,copy) NSString *pppoeAccount;

/** managedType EMS or PLUGIN */
@property(nonatomic,copy) NSString *manageType;

@end
