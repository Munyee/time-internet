//
//  HwONTRegisterStatus.h
//  MobileSDK
//

//  Copyright © 2017年 com.huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
	kHwUdpStatusNotExist	= 1001,	//	终端在服务器上不存在
	kHwUdpStatusAuthFail,		 //	在服务器上注册认证失败
	kHwUdpStatusNotRegister, 		//	终端未注册云平台
	kHwUdpStatusNormal
} HwUdpStatus;

@interface HwONTRegisterStatus : NSObject

/**	网关mac*/
@property (nonatomic, copy) NSString *mac;

/**	网关在云平台上注册状态*/
@property (nonatomic, assign) HwUdpStatus udpStatus;

@end
