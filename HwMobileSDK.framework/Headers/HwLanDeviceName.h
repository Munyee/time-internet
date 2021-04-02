#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 下挂设备名称信息(name of a connected device)
 *
 *  @since 1.0
 */
@interface HwLanDeviceName : NSObject

/** 下挂设备名称(最长256字节) (Name of a connected device 256 bytes at most))*/
@property(nonatomic, copy) NSString *name;

@end
