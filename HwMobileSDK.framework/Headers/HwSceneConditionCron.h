#import <Foundation/Foundation.h>
#import "HwCommonDefine.h"

@interface HwSceneConditionCron : NSObject

/** 时间(HH:MM) (Time (HH:MM))*/
@property(nonatomic, copy) NSString *time;

/** 一周中允许执行的天,如果为空，则只执行一次 (Days in a week in which execution is allowed (an empty value indicates that only one time is allowed))*/
@property (nonatomic, strong) NSSet *dayOfWeeks;

/** 是否每周重复执行 (Whether to execute every week)*/
@property(nonatomic) BOOL isLoop;

@end
