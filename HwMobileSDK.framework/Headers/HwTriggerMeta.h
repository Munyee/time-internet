#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

/**
 *  
 *
 *  @brief  触发条件(trigger condition)
 *
 *  @since 1.0
 */
@interface HwTriggerMeta : NSObject

/**
 场景触发条件类型(condition type)
 */
typedef enum
{
    /** 告警触发 ( alarm trigger)*/
    kHwTriggerTypeAlarm = 1,
    /** 属性条件触发 (property trigger)*/
    kHwTriggerTypeProperty =2
    
}kHwTriggerType;

/** 触发类型 (Trigger type)*/
@property(nonatomic) kHwTriggerType type;

/** 名称(最长64字节) (Name (64 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 国际化标题 (Internationalization title)*/
@property(nonatomic,copy) NSString *title;

/** 单位 (Unit)*/
@property(nonatomic,copy) NSString *unit;

/** 最大值 (Maximum value)*/
@property(nonatomic,copy) NSString *max;

/** 最小值 (Minimum value)*/
@property(nonatomic,copy) NSString *min;

/** 值类型 (Value type)*/
@property(nonatomic) kHwValueType valueType;

/** 枚举值列表 (Enumerated value list)*/
@property(nonatomic,strong) NSMutableArray *enumTypeList;

@end
