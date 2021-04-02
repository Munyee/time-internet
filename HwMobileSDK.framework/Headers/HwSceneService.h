#import <Foundation/Foundation.h>

@class HwSceneMeta;
@protocol HwCallback;

/**
 *  
 *
 *  @brief 智能家居场景管理服务(smart home scenario management service)
 *
 *  @since 1.0
 */
@interface HwSceneService : NSObject

/**
 *  
 *
 *  @brief 创建场景(creating a scenario)
 *
 *  @param deviceId   网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param sceneMeta  场景数据(scenario data)
 *  @param callback   返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)createScene:(NSString *)deviceId sceneMeta:(HwSceneMeta *)sceneMeta withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 修改场景(scenario modification)
 *
 *  @param deviceId   网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param sceneMeta  场景数据(scenario data)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)modifyScene:(NSString *)deviceId sceneMeta:(HwSceneMeta *)sceneMeta withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 删除场景(deleting a scenario)
 *
 *  @param deviceId  网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param sceneMeta  场景数据(scenario data)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)deleteScene:(NSString *)deviceId sceneMeta:(HwSceneMeta *)sceneMeta withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 执行场景(executing a scenario)
 *
 *  @param deviceId  网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param sceneMeta  场景数据(scenario data)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)executeScene:(NSString *)deviceId sceneMeta:(HwSceneMeta *)sceneMeta withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 获取场景列表(obtain a scenario list)
 *
 *  @param deviceId  网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getSceneList:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 支持查询最新的智能场景执行记录(Query the latest smart scenario implementation records)
 *
 *  @param deviceId 网关ID(最长128字节)(gateway ID (128 bytes at most))
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getLatestSceneExecutionRecord:(NSString *)deviceId withCallback:(id<HwCallback>)callback;
@end
