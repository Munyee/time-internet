

#import <Foundation/Foundation.h>
#import "HwResult.h"

@interface HwGetSupportedAlarmListResult : HwResult


/**  支持的告警列表 */
@property(nonatomic, strong) NSMutableArray *alarmList;

@end
