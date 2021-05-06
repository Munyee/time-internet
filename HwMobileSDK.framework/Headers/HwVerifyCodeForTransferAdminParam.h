//
//  HwVerifyCodeForTransferAdminParam.h
//  MobileSDK
//

//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwVerifyCodeForTransferAdminParam : NSObject

/**	原管理员账号(Original administrator account)*/
@property (nonatomic, copy) NSString *account;
/**	新管理员账号(New administrator account)*/
@property (nonatomic, copy) NSString *accountNew;
/**	发送手机号(The phone should receive)*/
@property (nonatomic, copy) NSString *receivePhone;

@end
