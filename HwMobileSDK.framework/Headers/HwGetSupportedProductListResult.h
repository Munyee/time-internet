

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwGetSupportedProductListResult : HwResult

/**  支持的产品列表 */
@property(nonatomic, strong) NSMutableArray *productList;

@end
