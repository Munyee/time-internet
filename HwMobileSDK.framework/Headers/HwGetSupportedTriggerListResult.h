

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwGetSupportedTriggerListResult : HwResult

/**  告警的触发条件列表 */
@property(nonatomic, strong) NSMutableArray *triggerList;


@end
