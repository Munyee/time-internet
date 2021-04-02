#import <Foundation/Foundation.h>
#import "HwResult.h"

/**
 *  
 *
 *  @brief 修改场景操作结果(scenario modification result)
 *
 *  @since 1.0
 */
@interface HwModifySceneResult : HwResult

/** 新的场景ID (New scenario ID)*/
@property(nonatomic, copy) NSString *sceneId;

@end
