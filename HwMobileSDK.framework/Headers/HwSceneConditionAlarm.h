#import <Foundation/Foundation.h>
#import "HwConditionAlarmParameter.h"
#import "HwTriggerMeta.h"

@interface HwSceneConditionAlarm : NSObject

/** 场景触发的名称(最长64字节) (Scenarios name (64 bytes at most))*/
@property(nonatomic,copy) NSString *alarmName;

/** 设备SN(最长128字节)(Device SN (128 bytes at most))*/
@property(nonatomic,copy) NSString *deviceSn;

/** 场景触发条件的类型 (trigger type)*/
@property(nonatomic,assign) kHwTriggerType triggerType;

/** 场景属性触发条件的设置参数 (condition alarm parameter)*/
@property(nonatomic,strong) HwConditionAlarmParameter *conditionAlarmParameter;
@end
