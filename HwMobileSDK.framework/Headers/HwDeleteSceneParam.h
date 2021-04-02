

#import <Foundation/Foundation.h>
#import "HwParam.h"

@interface HwDeleteSceneParam : HwParam

/** 网关id */
@property(nonatomic, copy) NSString *deviceId;



/** 场景id */
@property(nonatomic, copy) NSString *sceneId;

@end
