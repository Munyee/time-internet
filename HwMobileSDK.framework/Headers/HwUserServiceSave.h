//
//  HwUserServiceSave.h
//  MobileSDK_Save
//
//  Created by guozheng on 18/7/3.
//  Copyright © 2018年 com.huawei. All rights reserved.
//  NCE Use

#import <Foundation/Foundation.h>

#import <HwMobileSDK/HwVerifyCode.h>

@protocol HwCallback;
@class HwModifyPasswordParam;
@class HwGetVerifyCodeParam;
@class HwFindPasswordParam;
@class HwBindUserInfoParam;
@class HwBindGatewayParam;
@class HwVerifyCodeForFindpwdParam;
@class HwVerifyCodeForBindParam;
@class HwUnshareGatewayParam;
@class HwReplaceGatewayParam;
@class HwVerifyCodeForTransferAdminParam;
@class HwJoinFamilyParam;
@class HwRegisterUserParam;
@class HwVerifyPasswordParam;
/**
 *  
 *
 *  @brief 用户服务(User service)
 *
 *  @since 1.7
 */
@interface HwUserServiceSave : NSObject

#pragma mark - Gateway Manage

/**
 *  
 *
 *  @brief 查询用户绑定网关(query a gateway that a user is bound to)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)queryUserBindGateway:(id<HwCallback>)callback;

#pragma mark - User Manage

/**
 *  
 *
 *  @brief 获取注册账户的校验码(obtain verification code for a registered account)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getVerifyCodeForRegister:(HwGetVerifyCodeParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 获取绑定用校验码(to obtain verification code for binding)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getVerifyCodeForBind:(HwVerifyCodeForBindParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 找回密码用校验码(verification code for password retrieval)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getVerifyCodeForFindpwd:(HwVerifyCodeForFindpwdParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 绑定用户信息(手机或Email)(bound user information (phone or email))
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)bindUserInfo:(HwBindUserInfoParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 已登录时修改用户密码(change current user password)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)modifyPassword:(HwModifyPasswordParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 找回密码(password retrieval)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)findPassword:(HwFindPasswordParam *)param withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 设置用户昵称(set user nickname)
 *
 *  @param nickname 昵称(nickname)
 *  @param callback 回调(callback)
 *
 *  @since 1.0
 */
- (void)setUserNickname:(NSString *)nickname withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 注册用户(registered users)
 *
 *  @param param    注册信息(registration information)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)registerUser:(HwRegisterUserParam *)param
        withCallback:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 查询用户信息(query the user information)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)getUserInfo:(id<HwCallback>)callback;

/**
 *  
 *
 *  @brief 校验密码
 *
 *  @param registerAccount 注册账号
 *  @param psw    密码
 *  @param optType   类型
 *  @param callback
 *
 *  @since 1.0
 */
- (void)verifyPassword:(HwVerifyPasswordParam *)param
          withCallBack:(id<HwCallback>)callback;

@end

