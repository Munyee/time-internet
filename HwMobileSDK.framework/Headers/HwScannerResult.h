#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 二维码扫描结果(QR code scanning results)
 *
 *  @since 1.0
 */
@interface HwScannerResult : NSObject

/** 扫描内容 (Scanning content)*/
@property(nonatomic,copy) NSString *content;

/** 扫描的格式 (Scanning format)*/
@property(nonatomic,copy) NSString *format;

@end
