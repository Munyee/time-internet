

#import <Foundation/Foundation.h>
#import "HwParam.h"

@interface HwGetSupportedTriggerListParam : HwParam


/** 厂商 */
@property(nonatomic, copy) NSString *manufature;



/** 产品名称 */
@property(nonatomic, copy) NSString *productName;

@end
