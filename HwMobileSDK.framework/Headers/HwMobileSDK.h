////
////  Huawei NetOpen HwMobileSDK
////
////  Version 1.7.13
////
////  Copyright © 2016年 Huawei. All rights reserved.(Copyright © 2016 Huawei. All rights reserved.)
////
#ifndef HwMobileSDK_h
#define HwMobileSDK_h 1

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double MobileSDKVersionNumber;

FOUNDATION_EXPORT const unsigned char MobileSDKVersionString[];

#import <HwMobileSDK/HwActionException.h>
#import <HwMobileSDK/HwAppAuthInitParam.h>
#import <HwMobileSDK/HwAppAuthInitResult.h>
#import <HwMobileSDK/HwAppDetail.h>
#import <HwMobileSDK/HwAppImageInfo.h>
#import <HwMobileSDK/HwAppInfo.h>
#import <HwMobileSDK/HwApplicationService.h>
#import <HwMobileSDK/HwApplicationServiceSave.h>
#import <HwMobileSDK/HwAppMeta.h>
#import <HwMobileSDK/HwAppViewInterface.h>
#import <HwMobileSDK/HwAuthInitParam.h>
#import <HwMobileSDK/HwAuthInitResult.h>
#import <HwMobileSDK/HwBindGatewayParam.h>
#import <HwMobileSDK/HwBindUserInfoParam.h>
#import <HwMobileSDK/HwBindUserInfoResult.h>
#import <HwMobileSDK/HwCallback.h>
#import <HwMobileSDK/HwCallbackAdapter.h>
#import <HwMobileSDK/HwCommonDefine.h>
#import <HwMobileSDK/HwEnumType.h>
#import <HwMobileSDK/HwFeedbackInfo.h>
#import <HwMobileSDK/HwFeedbackResult.h>
#import <HwMobileSDK/HwFindPasswordParam.h>
#import <HwMobileSDK/HwFindPasswordResult.h>
#import <HwMobileSDK/HwGatewayInfo.h>
#import <HwMobileSDK/HwGetVerifyCodeParam.h>
#import <HwMobileSDK/HwIsLoginedResult.h>
#import <HwMobileSDK/HwIsNeededUpgradeResult.h>
#import <HwMobileSDK/HwJoinFamilyParam.h>
#import <HwMobileSDK/HwLoginInfo.h>
#import <HwMobileSDK/HwLoginParam.h>
#import <HwMobileSDK/HwLoginResult.h>
#import <HwMobileSDK/HwLogoutResult.h>
#import <HwMobileSDK/HwClosingResult.h>
#import <HwMobileSDK/HwManufacturerMeta.h>
#import <HwMobileSDK/HwMemberInfo.h>
#import <HwMobileSDK/HwModifyPasswordParam.h>
#import <HwMobileSDK/HwModifyPasswordResult.h>
#import <HwMobileSDK/HwNetopenMobileSDK.h>
#import <HwMobileSDK/HwNotificationConfig.h>
#import <HwMobileSDK/HwONTRegisterStatus.h>
#import <HwMobileSDK/HwFamilyRegisterInfo.h>
#import <HwMobileSDK/HwParam.h>
#import <HwMobileSDK/HwPluginUpgradeProgressInfo.h>
#import <HwMobileSDK/HwProductMeta.h>
#import <HwMobileSDK/HwQuitShareGatewayResult.h>
#import <HwMobileSDK/HwRegisterUserResult.h>
#import <HwMobileSDK/HwReplaceGatewayParam.h>
#import <HwMobileSDK/HwReplaceGatewayResult.h>
#import <HwMobileSDK/HwResult.h>
#import <HwMobileSDK/HwScannerResult.h>
#import <HwMobileSDK/HwSearchedUserGateway.h>
#import <HwMobileSDK/HwSetUserHeadPortraitResult.h>
#import <HwMobileSDK/HwSetUserNicknameResult.h>
#import <HwMobileSDK/HwShareGatewayAccount.h>
#import <HwMobileSDK/HwShareGatewayAccountResult.h>
#import <HwMobileSDK/HwShareGatewayParam.h>
#import <HwMobileSDK/HwShareGatewayResult.h>
#import <HwMobileSDK/HwTriggerMeta.h>
#import <HwMobileSDK/HwUnbindGatewayResult.h>
#import <HwMobileSDK/HwTransferAdminRightsResult.h>
#import <HwMobileSDK/HwVerifyCodeForTransferAdminParam.h>
#import <HwMobileSDK/HwUnregisterMessageResult.h>
#import <HwMobileSDK/HwUnshareGatewayParam.h>
#import <HwMobileSDK/HwUnshareGatewayResult.h>
#import <HwMobileSDK/HwUserBindedGateway.h>
#import <HwMobileSDK/HwUserHeadPortraitInfo.h>
#import <HwMobileSDK/HwUserInfo.h>
#import <HwMobileSDK/HwUserService.h>
#import <HwMobileSDK/HwUserServiceSave.h>
#import <HwMobileSDK/HwVerifyCode.h>
#import <HwMobileSDK/HwVerifyCodeForBindParam.h>
#import <HwMobileSDK/HwVerifyCodeForFindpwdParam.h>

#import <HwMobileSDK/HwWidgetMeta.h>
#import <HwMobileSDK/HwLogoutGatewayResult.h>
#import <HwMobileSDK/HwCheckGatewayPasswordParam.h>
#import <HwMobileSDK/HwCheckGatewayPasswordResult.h>
#import <HwMobileSDK/HwSendMessageData.h>
#import <HwMobileSDK/HwSendMessageResult.h>
#import <HwMobileSDK/HwUploadSuccessData.h>
#import <HwMobileSDK/HwUploadSuccessResult.h>
#import <HwMobileSDK/HwJudgeAccountExistResult.h>
#import <HwMobileSDK/HwGetFeedbackParam.h>
#import <HwMobileSDK/HwUserFeedBack.h>
#import <HwMobileSDK/HwGetFeedbackDetailParam.h>
#import <HwMobileSDK/HwGetUserFeedbacksResult.h>
#import <HwMobileSDK/HwOMUserInfo.h>
#import <HwMobileSDK/HwTenantInfo.h>
#import <HwMobileSDK/HwSendChatMessageResult.h>
#import <HwMobileSDK/HwMobileSDKNotifications.h>
#import <HwMobileSDK/HwCertificate.h>
#import <HwMobileSDK/HwServerTrustService.h>
#import <HwMobileSDK/HwRegisterUserParam.h>
#import <HwMobileSDK/HwRegisterUserResult.h>
#import <HwMobileSDK/HwVerifyPasswordParam.h>
#import <HwMobileSDK/HwVerifyPasswordResult.h>
#import <HwMobileSDK/HwKeyChain.h>
#import <HwMobileSDK/HwSegmentTestSpeedService.h>

#import <HwMobileSDK/HwDeleteFeedbackParam.h>


/* UserService */
#import <HwMobileSDK/HwModifySubAccountPwdParam.h>
#import <HwMobileSDK/HwModifySubAccountPwdResult.h>
#import <HwMobileSDK/HwCreateSubAccountResult.h>
#import <HwMobileSDK/HwCreateSubAccountParam.h>
#import <HwMobileSDK/HwJudgeAccountExistParam.h>
#import <HwMobileSDK/HwSetUserCommentParam.h>
#import <HwMobileSDK/HwSetUserCommentResult.h>
#import <HwMobileSDK/HwUserAnonymousBindInfo.h>
#import <HwMobileSDK/HwSetGatewayNicknameResult.h>
#import <HwMobileSDK/HwTransferAdminRightsParam.h>
#import <HwMobileSDK/HwSimpleBindGatewayResult.h>
#import <HwMobileSDK/HwSimpleBindGatewayParam.h>
#import <HwMobileSDK/HwLoginParam.h>
#import <HwMobileSDK/HwIsLoginParam.h>
#import <HwMobileSDK/HwIsNeedAppForceUpdateResult.h>
/* UserService */

/* ControllerService */
#import <HwMobileSDK/HwControllerService.h>
#import <HwMobileSDK/HwControllerService+Wifi.h>
#import <HwMobileSDK/HwControllerService+ParentControl.h>
#import <HwMobileSDK/HwControllerService+Device.h>
#import <HwMobileSDK/HwApDeviceUpgradeInfo.h>
#import <HwMobileSDK/HwApDeviceUpgradeParam.h>
#import <HwMobileSDK/HwApDeviceUpgradeResult.h>
#import <HwMobileSDK/HwIsApDeviceNeededUpgradeParam.h>
#import <HwMobileSDK/HwGetLanDeviceSpeedStateResult.h>
#import <HwMobileSDK/HwQueryLanDeviceCountParam.h>
#import <HwMobileSDK/HwQueryLanDeviceCountResult.h>
#import <HwMobileSDK/HwQueryLanDeviceListParam.h>
#import <HwMobileSDK/HwQueryLanDeviceListResult.h>
#import <HwMobileSDK/HwRenameLanDeviceResult.h>
#import <HwMobileSDK/HwSetLanDeviceBandWidthLimitResult.h>
#import <HwMobileSDK/HwDisableDeviceIncludeResult.h>
#import <HwMobileSDK/HwAcknowledgeSelfCheckResult.h>
#import <HwMobileSDK/HwFactoryResetResult.h>
#import <HwMobileSDK/HwGatewayBasicParam.h>
#import <HwMobileSDK/HwLoginGatewayParam.h>
#import <HwMobileSDK/HwLoginGatewayResult.h>
#import <HwMobileSDK/HwModifyGatewayPasswordParam.h>
#import <HwMobileSDK/HwModifyGatewayPasswordResult.h>
#import <HwMobileSDK/HwQueryGatewayHistoryTrafficConditionParam.h>
#import <HwMobileSDK/HwRebootGatewayResult.h>
#import <HwMobileSDK/HwRefreshTopoResult.h>
#import <HwMobileSDK/HwRenameGatewayParam.h>
#import <HwMobileSDK/HwRenameGatewayResult.h>
#import <HwMobileSDK/HwSelfCheckItem.h>
#import <HwMobileSDK/HwSelfCheckResult.h>
#import <HwMobileSDK/HwSetApChannelAutoResult.h>
#import <HwMobileSDK/HwSetGatewayAcsStartParam.h>
#import <HwMobileSDK/HwSetLedStatusResult.h>
#import <HwMobileSDK/HwSetPPPoEAccountResult.h>
#import <HwMobileSDK/HwSetDhcpPoolSettingResult.h>
#import <HwMobileSDK/HwAddLanDeviceToBlackListResult.h>
#import <HwMobileSDK/HwDeleteAttachParentControlResult.h>
#import <HwMobileSDK/HwDeleteAttachParentControlTemplateResult.h>
#import <HwMobileSDK/HwDeleteLanDeviceFromBlackListResult.h>
#import <HwMobileSDK/HwSetAttachParentControlResult.h>
#import <HwMobileSDK/HwSetAttachParentControlTemplateResult.h>
#import <HwMobileSDK/HwDisableWifiResult.h>
#import <HwMobileSDK/HwEnableWifiResult.h>
#import <HwMobileSDK/HwEnableWifiWpsResult.h>
#import <HwMobileSDK/HwGetWifiStatusResult.h>
#import <HwMobileSDK/HwGuestWifiInfoParam.h>
#import <HwMobileSDK/HwSetGuestWifiInfoResult.h>
#import <HwMobileSDK/HwSetSyncWifiSwitchToApResult.h>
#import <HwMobileSDK/HwSetWifiHideStatusResult.h>
#import <HwMobileSDK/HwSetWifiInfoResult.h>
#import <HwMobileSDK/HwSetWifiTimerResult.h>
#import <HwMobileSDK/HwSetWifiTransmitPowerLevelResult.h>
#import <HwMobileSDK/HwTriggerWholeNetworkTuningResult.h>
#import <HwMobileSDK/HwApChannelInfo.h>
#import <HwMobileSDK/HwApTrafficInfo.h>
#import <HwMobileSDK/HwApWlanNeighborInfo.h>
#import <HwMobileSDK/HwSyncWifiSwitchInfo.h>
#import <HwMobileSDK/HwTrafficInfo.h>
#import <HwMobileSDK/HwWirelessAccessPoint.h>
#import <HwMobileSDK/HwAttachParentControl.h>
#import <HwMobileSDK/HwAttachParentControlTemplate.h>
#import <HwMobileSDK/HwCloudStatusInfo.h>
#import <HwMobileSDK/HwControlSegment.h>
#import <HwMobileSDK/HwCpuInfo.h>
#import <HwMobileSDK/HwDhcpPoolSetting.h>
#import <HwMobileSDK/HwGatewayHistoryTraffic.h>
#import <HwMobileSDK/HwGatewayHistoryTrafficInfo.h>
#import <HwMobileSDK/HwGatewaySpeed.h>
#import <HwMobileSDK/HwGatewayTimeDurationInfo.h>
#import <HwMobileSDK/HwGatewayTraffic.h>
#import <HwMobileSDK/HwGatewayUpgradeInfo.h>
#import <HwMobileSDK/HwGatewayUpgradeProgressInfo.h>
#import <HwMobileSDK/HwGuestWifiInfo.h>
#import <HwMobileSDK/HwLanDevice.h>
#import <HwMobileSDK/HwLanDeviceBandWidth.h>
#import <HwMobileSDK/HwLanDeviceName.h>
#import <HwMobileSDK/HwLanDeviceTraffic.h>
#import <HwMobileSDK/HwLedInfo.h>
#import <HwMobileSDK/HwLocalNetworkInfo.h>
#import <HwMobileSDK/HwMemoryInfo.h>
#import <HwMobileSDK/HwOfflineNotification.h>
#import <HwMobileSDK/HwOfflineNotificationOption.h>
#import <HwMobileSDK/HwPonInformation.h>
#import <HwMobileSDK/HwPonStatusInfo.h>
#import <HwMobileSDK/HwPPPoEAccount.h>
#import <HwMobileSDK/HwPPPoEDialStatus.h>
#import <HwMobileSDK/HwRmsRegStatusInfo.h>
#import <HwMobileSDK/HwSystemInfo.h>
#import <HwMobileSDK/HwVoipRegStatus.h>
#import <HwMobileSDK/HwWanBasicInfo.h>
#import <HwMobileSDK/HwWanDetailInfo.h>
#import <HwMobileSDK/HwWifiAdvancedInfo.h>
#import <HwMobileSDK/HwDeviceTypeInfo.h>
#import <HwMobileSDK/HwWifiHideInfo.h>
#import <HwMobileSDK/HwWifiInfo.h>
#import <HwMobileSDK/HwWifiInterfaceInfo.h>
#import <HwMobileSDK/HwWifiTimer.h>
#import <HwMobileSDK/HwWifiTransmitPowerLevelInfo.h>
#import <HwMobileSDK/HwVoiceConfigInfo.h>
#import <HwMobileSDK/HwSystemInfoSHW.h>
#import <HwMobileSDK/HwAllWifiInfo.h>
#import <HwMobileSDK/HwSuspectedRubbingLanDevice.h>
#import <HwMobileSDK/HwWifiDevice.h>
#import <HwMobileSDK/HwWlanNeighborInfo.h>
#import <HwMobileSDK/HwRebootApResult.h>
#import <HwMobileSDK/HwWifiInfoAll.h>
#import <HwMobileSDK/HwUpLinkInfo.h>
#import <HwMobileSDK/HwWANInfo.h>
#import <HwMobileSDK/HwDeleteParentControlTemplateListResult.h>
#import <HwMobileSDK/HwSetWiFiRadioSwtichResult.h>
#import <HwMobileSDK/HwOkcDevice.h>
#import <HwMobileSDK/HwOKCWhiteInfo.h>
#import <HwMobileSDK/HwGetWlanHardwareSwitchParam.h>
#import <HwMobileSDK/HwSetWlanHardwareSwitchParam.h>
#import <HwMobileSDK/HwWlanHardwareSwitchInfo.h>
#import <HwMobileSDK/HwSetWlanHardwareSwitchResult.h>
#import <HwMobileSDK/HwGetWlanRadioInfoParam.h>
#import <HwMobileSDK/HwWlanRadioInfo.h>
#import <HwMobileSDK/HwSetWlanRadioInfoParam.h>
#import <HwMobileSDK/HwSsidInfo.h>
#import <HwMobileSDK/HwIpPingDiagnosticsInfo.h>
#import <HwMobileSDK/HwIpPingDiagnosticsResult.h>
#import <HwMobileSDK/HwStartIpPingDiagnosticsResult.h>
#import <HwMobileSDK/HwGetWlanWpsStatusResult.h>
#import <HwMobileSDK/HwLanEdgeOntInfo.h>
#import <HwMobileSDK/HwAPSystemInfo.h>
/* ControllerService */

/* SceneService */
#import <HwMobileSDK/HwSceneService.h>
#import <HwMobileSDK/HwSceneAction.h>
#import <HwMobileSDK/HwSceneCondition.h>
#import <HwMobileSDK/HwSceneConditionAlarm.h>
#import <HwMobileSDK/HwSceneConditionCron.h>
#import <HwMobileSDK/HwSceneDate.h>
#import <HwMobileSDK/HwSceneMeta.h>
#import <HwMobileSDK/HwTriggerMeta.h>
#import <HwMobileSDK/HwCreateSceneParam.h>
#import <HwMobileSDK/HwCreateSceneResult.h>
#import <HwMobileSDK/HwDeleteSceneParam.h>
#import <HwMobileSDK/HwDeleteSceneResult.h>
#import <HwMobileSDK/HwExecuteSceneParam.h>
#import <HwMobileSDK/HwExecuteSceneResult.h>
#import <HwMobileSDK/HwGetSceneListParam.h>
#import <HwMobileSDK/HwGetSceneListResult.h>
#import <HwMobileSDK/HwModifySceneParam.h>
#import <HwMobileSDK/HwModifySceneResult.h>
/* SceneService */

/* SystemService */
#import <HwMobileSDK/HwSystemServiceSave.h>
#import <HwMobileSDK/HwEvaluateParam.h>
#import <HwMobileSDK/HwSystemService.h>
#import <HwMobileSDK/HwSetNotificationConfigResult.h>
#import <HwMobileSDK/HwGetCloudFeatureParam.h>
/* SystemService */

/* SmarthomeEngineService */
#import <HwMobileSDK/HwSmarthomeEngineSaveService.h>
#import <HwMobileSDK/HwSmarthomeEngineService.h>
#import <HwMobileSDK/HwWebViewSave.h>
#import <HwMobileSDK/HwWebView.h>
/* SmarthomeEngineService */

/* HwDeviceService */
#import <HwMobileSDK/HwDeviceFeatureService.h>
#import <HwMobileSDK/HwFindService.h>
//Device
#import <HwMobileSDK/HwGatewayDevice.h>
#import <HwMobileSDK/HwDeviceFeature.h>
/* HwDeviceService */

/* HwDeviceMetaService */
#import <HwMobileSDK/HwDeviceMetaService.h>
#import <HwMobileSDK/HwGetProductMetaParam.h>
#import <HwMobileSDK/HwGetSupportedActionListParam.h>
#import <HwMobileSDK/HwGetSupportedActionListResult.h>
#import <HwMobileSDK/HwGetSupportedAlarmListParam.h>
#import <HwMobileSDK/HwGetSupportedAlarmListResult.h>
#import <HwMobileSDK/HwGetSupportedManufacturerListResult.h>
#import <HwMobileSDK/HwGetSupportedProductListParam.h>
#import <HwMobileSDK/HwGetSupportedProductListResult.h>
#import <HwMobileSDK/HwGetSupportedTriggerListParam.h>
#import <HwMobileSDK/HwGetSupportedTriggerListResult.h>
#import <HwMobileSDK/HwGetWidgetListResult.h>
#import <HwMobileSDK/HwGetWidgetParam.h>
#import <HwMobileSDK/HwActionMeta.h>
#import <HwMobileSDK/HwAlarmMeta.h>
/* HwDeviceMetaService */

/* HwApplicationService */
#import <HwMobileSDK/HwApplicationDoActionParam.h>
#import <HwMobileSDK/HwApplicationDoActionResult.h>
#import <HwMobileSDK/HwInstallAppResult.h>
#import <HwMobileSDK/HwUnInstallAppResult.h>
#import <HwMobileSDK/HwUpgradeAppResult.h>
/* HwApplicationService */

/* HwMessageService */
#import <HwMobileSDK/HwMessageService.h>
#import <HwMobileSDK/HwMessageServiceSave.h>
#import <HwMobileSDK/HwMessageData.h>
#import <HwMobileSDK/HwMessageHandleAdapter.h>
#import <HwMobileSDK/HwMessageQueryParam.h>
#import <HwMobileSDK/HwMessageSendOption.h>
#import <HwMobileSDK/HwNotificationMessage.h>
#import <HwMobileSDK/HwUpdateAppInfoResult.h>
#import <HwMobileSDK/HwOMMessage.h>
#import <HwMobileSDK/HwAppInfoParam.h>
#import <HwMobileSDK/HwQueryOMMessageParam.h>
/* HwMessageService */

/* HwDPIService */
#import <HwMobileSDK/HwGetGatewayNetQualityParam.h>
#import <HwMobileSDK/HwGetGatewayNetQualityResult.h>
#import <HwMobileSDK/HwGetApOrSTANetQualityParam.h>
#import <HwMobileSDK/HwGetApOrSTANetQualityResult.h>
#import <HwMobileSDK/HwDPIService.h>
/* HwDPIService */

/* HwSegmentTestSpeedService */
#import <HwMobileSDK/HwSegmentTestSpeedService.h>
#import <HwMobileSDK/HwStartSegmentSpeedTestParam.h>
#import <HwMobileSDK/HwGetSegmentSpeedResultParam.h>
#import <HwMobileSDK/HwStopSegmentSpeedTestParam.h>
#import <HwMobileSDK/HwStartSegmentSpeedTestResult.h>
#import <HwMobileSDK/HwGetSegmentSpeedResult.h>
#import <HwMobileSDK/HwSegmentSpeedResult.h>
#import <HwMobileSDK/HwStopSegmentSpeedTestResult.h>
/* HwSegmentTestSpeedService */

/* HwConsumerAppService */
#import <HwMobileSDK/HwConsumerAppService.h>
#import <HwMobileSDK/HwSignPrivacyStatementResult.h>
#import <HwMobileSDK/HwSignedPrivacyStatementInfo.h>
#import <HwMobileSDK/HwCommonSignPrivacyStatementResult.h>
#import <HwMobileSDK/HwSignedStatementResult.h>
#import <HwMobileSDK/HwSignedRecord.h>

#import <HwMobileSDK/HwDownloadFeedbackPicturesParam.h>
#import <HwMobileSDK/HwDownloadFeedbackPicturesResult.h>

/* HwConsumerAppService */

/* HwSegmentTestSpeedService */

#import <HwMobileSDK/HwSegmentTestSpeedService.h>
#import <HwMobileSDK/HwSpeedTestConfigInfo.h>
#import <HwMobileSDK/HwSegmentTestSpeedRecordInfo.h>
#import <HwMobileSDK/HwSegmentTestGetHistoryRecordParam.h>
#import <HwMobileSDK/HwSegmentTestSaveRecordParam.h>
#import <HwMobileSDK/HwSegmentTestSaveRecordResult.h>
#import <HwMobileSDK/HwSegmentSpeedTestMacro.h>
#import <HwMobileSDK/HwSegmentSpeedTestSubModels.h>
#import <HwMobileSDK/HwStartSegmentSpeedTestParam.h>
#import <HwMobileSDK/HwStartSegmentSpeedTestResult.h>
#import <HwMobileSDK/HwGetSegmentSpeedResultParam.h>
#import <HwMobileSDK/HwGetSegmentSpeedResult.h>
#import <HwMobileSDK/HwStopSegmentSpeedTestParam.h>
#import <HwMobileSDK/HwStopSegmentSpeedTestResult.h>

/* HwSegmentTestSpeedService */

#import <HwMobileSDK/HwSetOrAddDHCPStaticIPResult.h>
#import <HwMobileSDK/HwDeleteDHCPStaticIPResult.h>
#import <HwMobileSDK/HwDHCPIpInfo.h>
#import <HwMobileSDK/HwPortMappingInfo.h>
#import <HwMobileSDK/HwAddPortMappingResult.h>
#import <HwMobileSDK/HwDeletePortMappingResult.h>
#import <HwMobileSDK/HwSetPortMappingSwitchResult.h>
#import <HwMobileSDK/HwPortMappingSwitchInfo.h>
#import <HwMobileSDK/HwSinglePortMappingInfo.h>
#import <HwMobileSDK/HwGetHomeNetworkTrafficInfoListConfig.h>
#import <HwMobileSDK/HwGetLanDeviceNameParam.h>
#import <HwMobileSDK/HwLocationResult.h>
#import <HwMobileSDK/HwSendMessageToOMUserData.h>
#import <HwMobileSDK/HwSetApChannelResult.h>
#import <HwMobileSDK/HwSetLanDeviceSpeedStateResult.h>
#import <HwMobileSDK/HwSpeedupStateInfo.h>
#import <HwMobileSDK/HwStartPPPoEDialResult.h>
#import <HwMobileSDK/HwStopPPPoEDialResult.h>
#import <HwMobileSDK/HwUpdateGatewayUpgradeInfoResult.h>
#import <HwMobileSDK/HwUpgradeGatewayResult.h>
#import <HwMobileSDK/HwSetGatewayConfigStatusParam.h>
#import <HwMobileSDK/HwSetInternetWanInfoParam.h>
#import <HwMobileSDK/HwSetWebUserPasswordParam.h>
#import <HwMobileSDK/HwGetGatewayConfigStatusResult.h>
#import <HwMobileSDK/HwInternetWanInfo.h>
#import <HwMobileSDK/HwWebPwdAndWifiInfo.h>
#import <HwMobileSDK/HwPortProperty.h>
#import <HwMobileSDK/HwApStbModel.h>
#import <HwMobileSDK/HwLanInfo.h>
#import <HwMobileSDK/HwApLanInfo.h>
#import <HwMobileSDK/HwAppList.h>
#import <HwMobileSDK/HwInternetControlConfig.h>
#import <HwMobileSDK/HwUrlCfg.h>
#import <HwMobileSDK/HwTimeDuration.h>
#import <HwMobileSDK/HwDeviceOnlineTimeInfo.h>
#import <HwMobileSDK/HwDeviceTrafficTimeInfo.h>
#import <HwMobileSDK/HwEaiInfo.h>
#import <HwMobileSDK/HwDeviceAccState.h>
#import <HwMobileSDK/HwDeviceAccStrategy.h>
#pragma mark startImport
#endif /* HwHwMobileSDK_h */
