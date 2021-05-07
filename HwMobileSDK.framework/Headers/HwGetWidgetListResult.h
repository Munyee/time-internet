

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwGetWidgetListResult : HwResult

/**  系统支持的卡片列表 */
@property(nonatomic, strong) NSMutableArray *widgetList;

@end
