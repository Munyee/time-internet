#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 家长控制信息(parental control information)
 *
 *  @since 1.0
 */
@interface HwAttachParentControl : NSObject

/** 下挂设备MAC(最长64字节) ( * MAC address of a connected device (64 bytes at most))*/
@property(nonatomic,copy) NSString *mac;

/** 家长控制模板名称(最长32字节,UTF-8编码) (Parental control template name (32 bytes at most in UTF-8 code))*/
@property(nonatomic,copy) NSString *templateName;

@end
