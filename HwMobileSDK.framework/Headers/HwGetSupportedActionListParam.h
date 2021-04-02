

#import <Foundation/Foundation.h>
#import "HwParam.h"

@interface HwGetSupportedActionListParam : HwParam

/** 厂商 */
@property(nonatomic, copy) NSString *manufacturer;



/** 产品名称 */
@property(nonatomic, copy) NSString *productName;


@end
