//
//  HwInitFunctionSDKData.h
//  FunctionSDK
//  初始化存储SDK参数对象

//  Copyright © 2016年 Huawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HwInitFunctionSDKData : NSObject

/** 云平台登录Token*/
@property(nonatomic,copy) NSString *netOpenToken;      

/** 云平台地址夹*/
@property(nonatomic,copy) NSString *netOpenIP;

/** 云平台登录ClientID*/
@property(nonatomic,copy) NSString *netOpenClientID;

/** 智能ONTMAC地址*/
@property(nonatomic,copy) NSString *netOpenOntMac;

/** 家庭ID*/
@property(nonatomic,copy) NSString *netOpenFamilyID;

/** 云平台登录账户*/
@property(nonatomic,copy) NSString *netOpenAccount;

/** 云平台端口*/
@property int  netOpenPort;
@end
