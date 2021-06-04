
#import <Foundation/Foundation.h>


// 场景类型(scenario type)
typedef enum : NSUInteger {
    kHwSceneTypeGoHome = 1,
    kHwSceneTypeLeaveHome,
    kHwSceneTypeUnknow,
} kHwSceneType;


@class HwSceneCondition;
@class HwSceneDate;

/**
 *  
 *
 *  @brief 场景数据(scenario data)
 *
 *  @since 1.0
 */
@interface HwSceneMeta : NSObject

/** 场景ID(最长64字节)(Scenario ID (64 bytes at most))*/
@property(nonatomic,copy) NSString *sceneId;

/** 场景名称(最长64字节)(Scenario name (64 bytes at most))*/
@property(nonatomic,copy) NSString *name;

/** 场景是否生效(Scenario enabled)*/
@property(nonatomic) BOOL enable;

/** 场景触发条件 (Scenario trigger condition)*/
@property(nonatomic,strong) HwSceneCondition *sceneCondition;

/** 动作列表 (Action list)*/
@property(nonatomic,strong) NSMutableArray *sceneActionList;

/** 消息类型 MESSAGE SMS EMAIL (Message type MESSAGE SMS EMAIL)*/
@property (nonatomic,strong) NSMutableArray *messageType;

/** 场景类型(scenario type) */
@property (nonatomic, copy) NSString *sceneType;

/** 场景类型(scenario type) 建议使用*/
@property (nonatomic, assign) kHwSceneType smartSceneType;

/** 执行时间(implementation time) */
@property (nonatomic, copy) NSString *time;

/** 执行时间与当前时间的时间差(difference between the implementation time and current time) */
@property (nonatomic, copy) NSString *timeDifference;

/** 触发条件列表 (Condition list)*/
@property (nonatomic, strong) NSMutableArray<HwSceneCondition *> *sceneConditionList;

/** 场景生效时间 */
@property (nonatomic, strong) HwSceneDate *periodTime;
/** 任意条件或全部条件(All Any)*/
@property (nonatomic, copy) NSString *triggerMode;

@end
