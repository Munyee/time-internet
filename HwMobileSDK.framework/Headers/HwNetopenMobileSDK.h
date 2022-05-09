
#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCertificate.h>

@protocol HwCallback;
@class HwLoginParam;
@class HwAuthInitParam;
@class HwAppAuthInitParam;
@class HwIsLoginParam;

/**
 Huawei SDK入口(Huawei SDK entry)
 */
@interface HwNetopenMobileSDK : NSObject
/**
 *  
 *
 *  @brief 是否是hosting模式
 *
 *  @since 1.0
 */
+ (BOOL)isHostingMode;

/**
 *  
 *
 *  @brief 使能Debug日志(enable the Debug log)
 *
 *  @since 1.0
 */
+ (void)enableDebugLog;

/**
 获取SDK版本号

 @return 版本号
 */
+ (NSString *)SDKVersion;

/// 设置备机ip 未登录时使用此备机ip，登陆后使用平台返回的备机ip
/// @param backupIp 备机ip
+ (void)setBackupServerIP:(NSString *)backupIp;

/// 获取当前使用的备机ip
+ (NSString *)getBackupServerIP;

/// 获取当前使用的ip
+ (NSString *)getUsingServerIP;

/**
 *  
 *
 *  @brief 初始化SDK(华为云平台鉴权方式)(SDK initialization (Huawei cloud platform authentication mode))
 *
 *  @param initParam 初始化参数(initialization parameters)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)initWithHwAuth:(HwAuthInitParam *)initParam
          withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 初始化SDK(第三方鉴权方式)
 *
 *  @param initParam 初始化参数(initialization parameters)
 *  @param callback  返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)initWithAppAuth:(HwAppAuthInitParam *)initParam
           withCallback:(id<HwCallback>)callback;

/// 切换当前网关
/// @param deviceId 网关mac
/// @param isLocal true：近端，false：远端
+ (void)changeCurrentOnt:(NSString *)deviceId isLocal:(BOOL)isLocal;

/// 获取当前网关
+ (NSString *)getCurrentOnt;
		  
/**
 *
 *
 *  @brief 用户是否已经登录(仅华为云平台方式有效)(user already logged in or not (valid only in Huawei cloud platform))
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)isLogined:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 用户是否已经登录(仅华为云平台方式有效)(user already logged in or not (valid only in Huawei cloud platform))
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)isLogined:(HwIsLoginParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 用户登录(华为云平台鉴权方式)(user login (Huawei cloud platform authentication mode))
 *
 *  @param loginParam 登录参数(login parameters)
 *  @param callback   返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)login:(HwLoginParam *)loginParam withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 用户登出(user logout)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)logout:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 用户注销(user clear)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
+ (void)closing:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 得到服务对象(service objects obtained)
 *
 *  @param clazz 服务对象class(service object class)
 *
 *  @return 相应的服务对象(service objects)
 *
 *  @since 1.0
 */
+ (id)getService:(Class)clazz;

+ (void)setMessageBase64Switch:(BOOL)isBase64On;

+ (void)setNetopenHost:(NSString *)ipStr port:(int)port;

/**
 *  
 *
 *  @brief 注册检测到不受信任证书的回调
 *
 *  @HwCertificate *certificateInfo 证书信息
 *
 *  @return 相应的服务对象(service objects)
 */
+ (void)registerUntrustServerNotifyCallback:(void (^)(HwCertificate *certificateInfo))callback;

/**
 *  
 *
 *  @brief 信任所有服务器证书
 *
 *  @param trust YES or NO
 *
 */
+ (void)trustAllServerCertificate:(BOOL)trust;

/**
*
*
*  @brief 设置本地证书路径
*
*  @param 证书路径集合
*
*/
+ (void)setDefaultCertificate:(NSSet<NSString *> *)paths;

/**
 是否需要强制升级

 @param callback 回调 | HwIsNeedAppForceUpdateResult
 */
+ (void)isNeedAppForceUpdate:(id<HwCallback>)callback;
@end
