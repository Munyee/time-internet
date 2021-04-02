/**
 *  
 *
 *  @brief 场景生效时间段
 *
 *  @since 1.0
 */

#import <Foundation/Foundation.h>

@interface HwSceneDate : NSObject

/** 生效开始时间*/
@property (nonatomic, copy) NSString *startTime;

/** 生效结束时间*/
@property (nonatomic, copy) NSString *stopTime;

/** 生效周期*/
@property (nonatomic, strong) NSSet *weekDays;

@end
