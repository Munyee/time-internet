
#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCallback.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  
 *
 *  @brief 用户服务(ConsumerApp Service)
 *
 *  @since 1.7
 */
@interface HwConsumerAppService : NSObject

/**
 消费者用户签署隐私申明
 
 @param statementVersion 隐私声明的版本号

 */
- (void) signPrivacyStatement:(NSString *)deviceId
         withStatementVersion:(NSString *)statementVersion
                     callback:(id<HwCallback>)callback;
/**
 消费者查询最新版本的通用隐私申明
 
 @param appVersion app版本号
 @param callback     callback|HwCommonSignPrivacyStatementResult
 
 */
- (void) getCommonPrivacyStatement:(NSString *)appVersion
                          callback:(id<HwCallback>)callback;
/**
 消费者查询租户隐私申明
 
 @param appVersion app版本号
 @param callback     callback|HwCommonSignPrivacyStatementResult
 
 */
- (void) getCommonPrivacyStatement:(NSString *)appVersion
                          deviceId:(nullable NSString *)deviceId
                          callback:(id<HwCallback>)callback;
/**
 消费者查询隐私申明信息与签署情况
 
 @param callback     callback|HwSignedPrivacyStatementInfo
 
 */
- (void) getPrivacyStatement:(NSString *)appVersion
                    callback:(id<HwCallback>)callback;
/**
 消费者用户签署隐私申明
 
 @param version app版本号
 @param callback     callback|HwResult
 
 */
- (void) consumerSignPrivacyStatement:(NSString *)version
                             callback:(id<HwCallback>)callback;

@end


NS_ASSUME_NONNULL_END
