

#import <Foundation/Foundation.h>
#import "HwParam.h"

@interface HwGetProductMetaParam : HwParam


/** 厂商 */
@property(nonatomic, copy) NSString *manufactor;


/** 产品名称 */
@property(nonatomic, copy) NSString *productName;

@end
