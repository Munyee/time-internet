#import <Foundation/Foundation.h>
#import "HwUserServiceSave.h"
#import "HwVerifyCode.h"
#import "HwCheckVerifyCodeParam.h"
#import "HwJudgeAccountExistParam.h"
#import "HwAppInfoParam.h"
#import "HwQueryOMMessageParam.h"

@protocol HwCallback;
@class HwRegisterUserParam;
@class HwModifyPasswordParam;
@class HwGetVerifyCodeParam;
@class HwFindPasswordParam;
@class HwBindUserInfoParam;
@class HwBindGatewayParam;
@class HwVerifyCodeForFindpwdParam;
@class HwVerifyCodeForBindParam;
@class HwShareGatewayParam;
@class HwUnshareGatewayParam;
@class HwSetUserCommentParam;
@class HwReplaceGatewayParam;
@class HwCreateSubAccountParam;
@class HwModifySubAccountPwdParam;
@class HwVerifyPasswordParam;
@class HwTransferAdminRightsParam;
@class HwTransferAdminRightsResult;
@class HwVerifyCodeForTransferAdminParam;
@class HwJoinFamilyParam;
@class HwSimpleBindGatewayParam;

/**
 *
 *
 *  @brief 用户服务(User service)
 *
 *  @since 1.7
 */
@interface HwUserService : HwUserServiceSave

#pragma mark - Gateway Manage

/**
 *
 *
 *  @brief 在当前WIFI下搜索网关(search for a gateway in the current Wi-Fi network)
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)searchGateway:(id<HwCallback>)callback;


/**
 在当前 WIFI 下搜索网关（只支持 27998）
 
 @param callback 返回回调
 */
- (void) searchGatewayForNear:(id<HwCallback>)callback;

/// 快速校验网关，1s返回结果
/// @param callback 回调
- (void)checkOnt:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 绑定网关(bind a gateway)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)bindGateway:(HwBindGatewayParam *)param withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 去绑定网关(unbind a gateway)
 *
 *  @param deviceId 请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)unbindGateway:(NSString *)deviceId withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 更换网关(Replace a gateway.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param param    请求参数(request param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)replaceGateway:(NSString *)deviceId withParam:(HwReplaceGatewayParam *)param withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询可管理该网关的用户列表(Query the list of users who can manage the gateway.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)getUserInfoListByGateway:(NSString *)deviceId withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 管理员分享网关给其他用户,仅当“查询用户可管理的网关列表”接口中，当前用户账号和返回的管理员账号一致时，才可以执行该操作(An administrator shares a gateway to other users. This operation can be performed only when the current user account is consistent with the administrator account returned over the API for querying the list of gateways that can be managed by the user.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param param    请求参数(request param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)shareGateway:(NSString *)deviceId withParam:(HwShareGatewayParam *)param withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 管理员取消分享网关给其他用户,仅当“查询用户可管理的网关列表”接口中，当前用户账号和返回的管理员账号一致时，才可以执行该操作(An administrator cancels the sharing of a gateway to other users. This operation can be performed only when the current user account is consistent with the administrator account returned over the API for querying the list of gateways that can be managed by the user.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param param    请求参数(request param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)unshareGateway:(NSString *)deviceId withParam:(HwUnshareGatewayParam *)param withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 非管理员退出分享网关,当前用户账号须为“查询可管理该网关的用户列表”接口中返回的账号，并且不是管理员账号才能执行此操作(A non-administrator exits the sharing of a gateway. This operation can be performed only when the current user account is an account returned over the API for querying the list of users who can manage the gateway and is not an administrator account.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)quitShareGateway:(NSString *)deviceId withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 管理员设置网关别名(An administrator sets the gateway alias.)
 *
 *  @param deviceId        网关ID(gateway ID)
 *  @param gatewayNickname 网关别名(gateway alias)
 *  @param callback        返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)setGatewayNickname:(NSString *)deviceId
       withGatewayNickname:(NSString *)gatewayNickname
              withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置其他用户备注名(Set remarks of other users.)
 *
 *  @param deviceId 网关ID(gateway ID)
 *  @param param    请求参数(request param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.7
 */
- (void)setUserComment:(NSString *)deviceId withParam:(HwSetUserCommentParam *)param withCallBack:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 绑定网关并注册账号(bind a gateway and registered users)
 *
 *  @param param    请求参数(request parameters)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)registerAndBindGateway:(HwRegisterUserParam *)registerParam
          withBindGatewayParam:(HwBindGatewayParam *)bindGatewayParam
                  withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取移交权限校验码
 *
 *  @param deviceId     网关id
 *  @param param    校验参数
 *  @param callback 返回回调
 *
 *  @since
 */
- (void)getVerifyCodeForTransferAdminRights:(NSString *)deviceId
                     withTransferAdminParam:(HwVerifyCodeForTransferAdminParam *)param
                               withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取网关注册云平台状态
 *
 *  @param deviceId 网关ID
 *  @param callback 回调
 *
 *  @since
 */
- (void)getONTRegisterStatus:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 获取网关绑定家庭信息
 *
 *  @param deviceId 网关ID
 *  @param callback 回调
 *
 *  @since
 */
- (void)getFamilyRegisterInfoOnCloud:(NSString *)deviceId withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 加入家庭
 *
 *  @param param 加入家庭参数
 *  @param callback 回调
 *
 *  @since
 */
- (void)joinFamily:(HwJoinFamilyParam *)param withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 管理员移交权限
 *
 *  @param deviceId 网关ID
 *  @param param 移交参数
 *  @param callback 回调
 *
 *  @since
 */
- (void)tranferAdminRights:(NSString *)deviceId
withTranferAdminRightsParam:(HwTransferAdminRightsParam *)param
              withCallback:(id<HwCallback>)callback;

#pragma mark - User Manage子账号管理
/**
 *
 *
 *  @brief 创建子账号(create sub account)
 *  @param deviceId 网关ID(gateway ID)
 *  @param HwCreateSubAccountParam 子账号参数(sub account param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
-(void)createSubAccount:(NSString *)deviceId
        withCreateParam:(HwCreateSubAccountParam *)createSubAccountParam
           withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 设置用户账号
 *
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void)setUserAccount:(NSString *)newUserAccount withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 修改子账号(modify sub account password)
 *  @param deviceId 网关ID(gateway ID)
 *  @param HwModifySubAccountPwdParam 子账号参数(sub account param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
-(void)modifySubAccountPwd:(NSString *)deviceId
           withModifyParam:(HwModifySubAccountPwdParam *)modifySubAccountPwdParam
              withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 校验账号、手机号、邮箱是否存在（judge account exist）
 *  @param HwJudgeAccountExistParam 校验参数(judge account exist param)
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void) judgeAccountExist:(HwJudgeAccountExistParam *)judgeAccountExistParam withCallback:(id<HwCallback>)callback;

/**
 *
 *
 *  @brief 查询租户域下的装维用户（query omuser list）
 *  @param callback 返回回调(return callback)
 *
 *  @since 1.0
 */
- (void) getOmuserListWithCallback:(id<HwCallback>)callback;

/**
 简易绑定网关（只绑定网关，不创建家庭）
 
 @param param 参数对象
 @param callback 回调
 */
- (void) simpleBindGateway:(HwSimpleBindGatewayParam *)param withCallBack:(id<HwCallback>)callback;

/**
 更新APP版本号
 
 @param param 入参
 @param callback 回调
 */
- (void)updateAppInfo:(HwAppInfoParam *)param withCallback:(id<HwCallback>)callback;

/**
 查询OM消息
 
 @param param 入参
 @param callback 回调
 */
- (void)queryOMMessage:(HwQueryOMMessageParam *)param withCallback:(id<HwCallback>)callback;

/**
 获取多因素认证的验证码

 @param callback 回调
*/
- (void)getMultiFactorCode:(id<HwCallback>)callback;

/**
 校验多因素验证码

 @param code 验证码
 @param callback 回调
*/
- (void)checkMultiFactorCode:(NSString *)code withCallback:(id<HwCallback>)callback;
@end
