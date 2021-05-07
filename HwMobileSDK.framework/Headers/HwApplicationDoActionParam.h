#import <Foundation/Foundation.h>
#import "HwParam.h"

/**
 *  
 *
 *  @brief 应用插件操作命令透传接口请求参数
 *
 *  @since 1.0
 */
@interface HwApplicationDoActionParam : HwParam

/** 应用名称 */
@property(nonatomic, copy) NSString *applicationName;

/** 服务名称 */
@property(nonatomic, copy) NSString *serviceName;

/** 执行动作 */
@property(nonatomic, copy) NSString *action;

/** 附加参数，JSON字符串 */
@property(nonatomic, copy) NSString *parameters;

@end
