#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 厂商信息(vendor information)
 *
 *  @since 1.0
 */
@interface HwManufacturerMeta : NSObject

/** 厂商名称(最长64字节) (Vendor name (64 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 厂商国际化名称(最长64字节)(Vendor internationalization name (64 bytes at most))*/
@property(nonatomic,copy) NSString *title;

@end
