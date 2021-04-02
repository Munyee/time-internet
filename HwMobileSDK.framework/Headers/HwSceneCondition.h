#import <Foundation/Foundation.h>

@class HwSceneConditionCron;
@class HwSceneConditionAlarm;

@interface HwSceneCondition : NSObject

/**
 场景类型(Scenario type)
 */
typedef enum
{
    /** 手工执行 ( Manual execution)*/
    kHwSceneConditionTypeManul = 1,
    /** 定时执行 (Scheduled execution)*/
    kHwSceneConditionTypeCron,
    /** 触发执行 (Triggered execution)*/
    kHwSceneConditionTypeTrigger
}kHwSceneConditionType;

/** 场景类型 (Scenario type)*/
@property(nonatomic) kHwSceneConditionType type;

/** 定时场景 (Scheduled scenario)*/
@property(nonatomic,strong) HwSceneConditionCron *conditionCron;

/** 触发式场景 (Triggering scenario)*/
@property(nonatomic,strong) HwSceneConditionAlarm *conditionAlarm;

@end
