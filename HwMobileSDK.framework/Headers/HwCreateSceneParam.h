
#import <Foundation/Foundation.h>
#import "HwParam.h"
#import "HwSceneMeta.h"


@interface HwCreateSceneParam : HwParam

/** 网关id */
@property(nonatomic, copy) NSString *deviceId;



/** 场景数据 */
@property(nonatomic, strong)HwSceneMeta *sceneMeta;

@end