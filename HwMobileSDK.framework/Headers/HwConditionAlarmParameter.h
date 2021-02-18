/**
 *  
 *
 *  @brief 场景属性变更触发条件()
 *
 *  @since 1.0
 */
#import <Foundation/Foundation.h>

@interface HwConditionAlarmParameter : NSObject
typedef enum
{
    kHwPropertyTypeUnknown = 0,
    kHwPropertyTypeFloat = 1,
    kHwPropertyTypeInt =2,
    kHwPropertyTypeEnum = 3
}kHwPropertyType;

/** 触发条件运算符 (Operator),取值范围：>,<,>=,<=,==,!= */
@property(nonatomic,copy) NSString *propertyOperator;

/** 触发条件的属性名称 (property name) */
@property(nonatomic,copy) NSString *propertyName;

/** 触发条件的属性类型 (property type) */
@property(nonatomic,assign) kHwPropertyType propertyType;

/** 触发条件的数值 (threshold) */
@property(nonatomic,copy) NSString *threshold;
@end
