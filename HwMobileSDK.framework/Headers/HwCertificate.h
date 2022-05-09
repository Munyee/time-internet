//
//  HwCertificate.h
//  HwMobileSDK
//

//  Copyright © 2018年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwCertificate : NSObject
/** 服务器ip */
@property (nonatomic, copy) NSString *serverIp;
/** 国家/地区 */
@property (nonatomic, copy) NSString *countryName;
/** 组织 */
@property (nonatomic, copy) NSString *organizationName;
/** 省/市/自治区 */
@property (nonatomic, copy) NSString *stateOrProvinceName;
/** 组织单位 */
@property (nonatomic, copy) NSString *organizationalUnitName;
/** 电子邮件地址 */
@property (nonatomic, copy) NSString *emailAddress;
/** 颁发者 */
@property (nonatomic, copy) NSString *commonName;
/** 使用者 */
@property (nonatomic, copy) NSString *subjectName;
/** 过期时间 */
@property (nonatomic, strong) NSDate *expiryDate;
/** 生效时间 */
@property (nonatomic, strong) NSDate *signDate;
/** sha1 */
@property (nonatomic, copy) NSString *sha1;
/** 二进制流 */
@property (nonatomic, strong) NSData *data;

@end
