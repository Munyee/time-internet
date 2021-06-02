

#import <Foundation/Foundation.h>

/**
 *  
 *
 *  @brief APP应用类信息(Application type information)
 *
 *  @since 1.0
 */
@interface HwAppMeta : NSObject

/** 应用名称 (Application name)*/
@property (nonatomic, copy) NSString *name;

/** 应用国际化名称 (International name of an application)*/
@property (nonatomic, copy) NSString *title;

/** 应用入口 (Application entry)*/
@property (nonatomic, copy) NSString *entry;

/** 应用图标 (Application icon)*/
@property (nonatomic, copy) NSString *icon;

/** 资源文件路径 */
@property (nonatomic, copy) NSString *resourcePath;


/** 应用是否需要ONT的近端鉴权(Whether the app requires local authentication by the ONT.) */
@property BOOL isNeedONTAuthentication;

/** 标记扩展标记 (extend tag)*/
@property (readwrite,nonatomic,strong) NSString * extend;

/** 配置应用的角色名，平台上需要配置相同的角色名，由APP进行获取和校验 */
@property (nonatomic , strong) NSArray *roles;
/** 自定义应用属性配置节点，SDK只负责解析，如何使用由APP决定 */
@property (nonatomic , strong) NSDictionary *properties;

/** 应用配置信息，SDK只负责解析，如何使用由APP决定 */
@property(nonatomic,strong) NSDictionary *manifestInfos;

/** 是否具备网关特性(has gateway features) */
-(void)hasGatewayFeatures:(NSString *)deviceId
             withCallback:(void(^)(BOOL hasGatewayFeatures))callback;
@end
