

#import <Foundation/Foundation.h>
#import "HwParam.h"
#import "HwSceneMeta.h"


@interface HwModifySceneParam : HwParam

/** 网关id */
@property(nonatomic, copy) NSString *deviceId;


/** 场景名称 */
@property(nonatomic, copy) NSString *sceneName;


/** 场景数据 */
@property(nonatomic, strong) HwSceneMeta *sceneMeta;

@end