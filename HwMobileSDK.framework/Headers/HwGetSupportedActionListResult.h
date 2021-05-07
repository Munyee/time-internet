

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwGetSupportedActionListResult : HwResult


/**  支持的动作列表 */
@property(nonatomic, strong) NSMutableArray *actionList;

@end
