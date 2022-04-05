//
//  HwServerTrustService.h
//  HwMobileSDK
//

//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HwMobileSDK/HwCertificate.h>

typedef void(^HwServerTrustServiceCallback)(HwCertificate *certInfo);

extern NSString * const HLCAFNetworkingTrustServerCertificateKey;

@interface HwServerTrustService : NSObject

/**
 收到不受信任的证书的回调
 */
@property (nonatomic, copy) void (^serviceDidReceiveUnsafeChallengeBlock)(HwCertificate *certInfo);
/**
 收到被吊销的证书的回调
 */
@property (nonatomic, copy) void (^serviceDidReceiveRevokedChallengeBlock)(HwCertificate *certInfo);
/**
 是否信任不受信任的证书
 */
@property (nonatomic, assign) BOOL trustServerCertificate;
/**
 是否信任被吊销的证书
 */
@property (nonatomic, assign) BOOL trustRevokedCertificate;
/**
 默认证书路径
 */
@property (nonatomic, copy) NSSet <NSString *>*defaultCertPaths;

/**
 单例初始化

 @return 单例对象
 */
+ (HwServerTrustService *)sharedService;

/**
 注册不受信任的证书回调

 @param callback
 */
- (void)registerUntrustServerNotifyCallback:(void (^)(HwCertificate *certInfo))callback;
/**
 注册吊销证书的回调

 @param callback
 */
- (void)registerRevokedServerCallback:(void (^)(HwCertificate *certInfo))callback;

//ONT近端用(NCE)
/** 是否信任ONT证书 */
+ (BOOL)shouldTrustONTCert:(SecTrustRef)trust;
/**
 获取证书信息

 @param certificate 证书
 @return 证书信息
 */
+ (HwCertificate *)getCertInfoFromCertificateRef:(SecCertificateRef)certificate;
/**
 判断证书是否被吊销

 @param certificate 证书
 @param isLocal 是否是近端
 @return 是否吊销
 */
+ (BOOL)isCertRevoked:(SecCertificateRef)certificate isLocal:(BOOL)isLocal;

/**
 当前是否需要做CRL校验

 @return true需要做RCRL验证，false不需要做CRL验证
 */
- (BOOL)getNeedCRLRevokedVerifyIsLocal:(BOOL)isLocal;

/**
信任指定证书

@param cert 证书对象
*/
+ (void)trustCertificate:(HwCertificate *)cert;
@end
