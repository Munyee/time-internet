

#import <Foundation/Foundation.h>
#import "HwParam.h"

@interface HwGetSupportedAlarmListParam : HwParam



/** 厂商 */
@property(nonatomic, copy) NSString *manufacture;



/** 产品名称 */
@property(nonatomic, copy) NSString *productName;

@end
