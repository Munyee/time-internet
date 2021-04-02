#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"


/**
 允许上网时段(Internet availability period)
 */
@interface HwControlSegment : NSObject

/** 允许上网开始时间(HH:mm) (Start time to allow Internet surfing (HH:mm))*/
@property(nonatomic, copy) NSString *startTime;

/** 允许上网结束时间(HH:mm) (End time to allow Internet surfing (HH:mm))*/
@property(nonatomic, copy) NSString *endTime;

/** 一周中允许上网的天 (Days of a week in which Internet surfing is allowed)*/
@property(nonatomic, strong) NSMutableSet * /*<kHwDayOfWeek>*/ dayOfWeeks;


/** 是否启用 (enable or not) [json 网关接口不支持，OSGI网关支持]*/
@property(nonatomic,assign) BOOL enable;

/** 循环模式 (repeat mode) [json 网关接口不支持，OSGI网关支持]*/
@property(nonatomic,assign) HwRepeatMode repeatMode;
@end
