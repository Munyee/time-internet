#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief 场景动作(scenario action)
 *
 *  @since 1.0
 */
@interface HwSceneAction : NSObject

/** 动作名称(最长64字节)(Action name (bytes at most))*/
@property(nonatomic,copy) NSString *actionName;

/** 设备SN(最长128字节)(Device SN (128 bytes at most))*/
@property(nonatomic,copy) NSString *deviceSn;

/** parameter参数*/
@property(nonatomic,strong) NSMutableDictionary *parameterDic;

//@property(nonatomic,copy) NSString *hw_description;

/** 是否执行成功*/
@property (nonatomic) BOOL isSuccess;


@end
