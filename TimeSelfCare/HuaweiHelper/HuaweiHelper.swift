//
//  HuaweiHelper.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation
import HwMobileSDK

public class HuaweiHelper {
    private static let singleton: HuaweiHelper = HuaweiHelper()
    public static var shared: HuaweiHelper {
        return HuaweiHelper.singleton
    }
}

public extension HuaweiHelper {
    func initHwSdk(completion: @escaping() -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let _ = value as? HwAuthInitResult {
                print("Init completed")
                completion()
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        let param = HwAppAuthInitParam() // swiftlint:disable:this
        param.ip = "nce.time.com.my"
        param.port = 30_110 // swiftlint:disable:this
        param.locale = NSLocale.system
        HwNetopenMobileSDK.initWithHwAuth(param, with: callBackAdapter)
    }
    
    func logout(completion: @escaping(_ result: HwLogoutResult) -> Void) {
           let callBackAdapter = HwCallbackAdapter()
           callBackAdapter.handle = {value in
               if let result = value as? HwLogoutResult {
                   completion(result)
               }
           }
           callBackAdapter.exception = {(exception: HwActionException?) in
               print(exception?.errorCode ?? "")
           }
           
           HwNetopenMobileSDK.logout(callBackAdapter)
    }
    
    func initWithAppAuth(token: String, username: String, completion: @escaping(_ result: HwAppAuthInitResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let result = value as? HwAppAuthInitResult {
                print("Init App Auth completed")
                completion(result)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            print("Init App Auth Error: \(exception?.errorCode ?? "")")
            error(exception)
        }
        
        let initParam = HwAppAuthInitParam()
        initParam.userName = username
        initParam.ip = "nce.time.com.my"
        initParam.port = 30_110 // swiftlint:disable:this
        initParam.locale = NSLocale.system
        initParam.getTokenHandle = {
            return token
        }

        HwNetopenMobileSDK.initWithAppAuth(initParam, with: callBackAdapter)
    }
    
    func registerErrorMessageHandle(completion: @escaping(_ result: HwNotificationMessage) -> Void) {
        let service = HwMessageService()
        service.registerErrorMessageHandle { value in
            if let result = value as? HwNotificationMessage {
                completion(result)
            }
        }
    }
    
    func checkIsLogin(completion: @escaping(_ result: HwIsLoginedResult) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let result = value as? HwIsLoginedResult {
                completion(result)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        HwNetopenMobileSDK.isLogined(callBackAdapter)
    }
    
    func queryGateway(completion: @escaping(_ result: HwSystemInfo) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? HwSystemInfo {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getSystemInfo(AccountController.shared.gatewayDevId, with: callBackAdapter)
        }
    }
    
    func queryUserBindGateway(completion: @escaping(_ result: [HwUserBindedGateway]) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateways = value as? [HwUserBindedGateway] {
                completion(gateways)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.queryUserBindGateway(callBackAdapter)
        }
    }

    func searchGateway(completion: @escaping(_ result: [HwSearchedUserGateway]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? [HwSearchedUserGateway] {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.searchGateway(callBackAdapter)
        }
    }
    
    func getONTRegisterStatus(devId: String, completion: @escaping(_ result: HwONTRegisterStatus) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? HwONTRegisterStatus {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.getONTRegisterStatus(devId, with: callBackAdapter)
        }
    }
    
    func getFamilyRegisterInfoOnCloud(devId: String, completion: @escaping(_ result: HwFamilyRegisterInfo) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let family = value as? HwFamilyRegisterInfo {
                completion(family)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.getFamilyRegisterInfo(onCloud: devId, with: callBackAdapter)
        }
    }
    
    func factoryReset(deviceMac: String, completion: @escaping(_ result: HwFactoryResetResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let result = value as? HwFactoryResetResult {
                completion(result)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
            print(HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.factoryReset(deviceMac, with: callBackAdapter)
        }
    }
    
    func bindGateway(deviceMac: String, gatewayNickname: String, completion: @escaping(_ result: HwUserBindedGateway) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? HwUserBindedGateway {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        let params = HwBindGatewayParam()
        params.deviceMAC = deviceMac
        params.adminAccount = ""
        params.adminPassword = ""
        params.gatewayNickName = gatewayNickname
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.bindGateway(params, withCallBack: callBackAdapter)
        }
    }
    
    func unbindGateway(completion: @escaping(_ result: HwUnbindGatewayResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? HwUnbindGatewayResult {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.unbindGateway(AccountController.shared.gatewayDevId, withCallBack: callBackAdapter)
        }
    }
    
    func replaceGateway(oldDeviceMac: String, deviceMac: String, completion: @escaping(_ result: HwReplaceGatewayResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? HwReplaceGatewayResult {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        let params = HwReplaceGatewayParam()
        params.deviceMAC = deviceMac
        params.gatewayAdminAccount = ""
        params.gatewayAdminPassword = ""
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.replaceGateway(oldDeviceMac, with: params, withCallBack: callBackAdapter)
        }
    }

    func getGatewaySpeed(completion: @escaping(_ result: HwGatewaySpeed) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gatewaySpeed = value as? HwGatewaySpeed {
                completion(gatewaySpeed)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getGatewaySpeed(AccountController.shared.gatewayDevId, with: callBackAdapter)
        }
    }
    
    func queryLanDeviceCount(completion: @escaping(_ result: HwQueryLanDeviceCountResult) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let lanDevCountResult = value as? HwQueryLanDeviceCountResult {
                completion(lanDevCountResult)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.queryLanDeviceCount(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func getAttachParentControlList(completion: @escaping(_ result: [HwAttachParentControl]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let tplList = value as? [HwAttachParentControl] {
                completion(tplList)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getAttachParentControlList(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func getAttachParentalControlTemplateList(completion: @escaping(_ result: [HwAttachParentControlTemplate]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let tplList = value as? [HwAttachParentControlTemplate] {
                completion(tplList)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getAttachParentControlTemplateList(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func getAttachParentControlTemplate(templateName: String, completion: @escaping(_ result: HwAttachParentControlTemplate) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwAttachParentControlTemplate {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getAttachParentControlTemplate(AccountController.shared.gatewayDevId ?? "", withTemplateName: templateName, with: callBackAdapter)
        }
    }
    
    func getParentControlTemplateDetailList(templateNames: [String], completion: @escaping(_ result: [HwAttachParentControlTemplate]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwAttachParentControlTemplate] {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getParentControlTemplateDetailList(AccountController.shared.gatewayDevId ?? "", withParentControlNameList: templateNames, with: callBackAdapter)
        }
    }
    
    func setAttachParentControlTemplate(ctrlTemplate: HwAttachParentControlTemplate, completion: @escaping(_ result: HwSetAttachParentControlTemplateResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwSetAttachParentControlTemplateResult {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.setAttachParentControlTemplate(AccountController.shared.gatewayDevId ?? "", withParentControl: ctrlTemplate, with: callBackAdapter)
        }
    }
    
    func deleteAttachParentControlTemplate(name: String, completion: @escaping(_ result: HwDeleteAttachParentControlTemplateResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwDeleteAttachParentControlTemplateResult {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.deleteAttachParentControlTemplate(AccountController.shared.gatewayDevId ?? "", withName: name, with: callBackAdapter)
        }
    }
    
    func setAttachParentControl(attachParentCtrl: HwAttachParentControl, completion: @escaping(_ result: HwSetAttachParentControlResult ) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwSetAttachParentControlResult {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.setAttachParentControl(AccountController.shared.gatewayDevId ?? "", with: attachParentCtrl, with: callBackAdapter)
        }
    }
    
    func deleteAttachParentControl(attachParentCtrl: HwAttachParentControl, completion: @escaping(_ result: HwDeleteAttachParentControlResult ) -> Void) {
           let callBackAdapter = HwCallbackAdapter()
           callBackAdapter.handle = {value in
               if let data = value as? HwDeleteAttachParentControlResult {
                   completion(data)
               }
           }
           callBackAdapter.exception = {(exception: HwActionException?) in
               print(exception?.errorCode ?? "")
           }
           
           if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
               service.deleteAttachParentControl(AccountController.shared.gatewayDevId ?? "", with: attachParentCtrl, with: callBackAdapter)
           }
       }
    
    func queryLanDeviceListEx(completion: @escaping(_ result: [HwLanDevice] ) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwLanDevice] {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.queryLanDeviceListEx(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func queryLanDeviceManufacturingInfoList(macList: [String], completion: @escaping(_ result: [HwDeviceTypeInfo] ) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwDeviceTypeInfo] {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.queryLanDeviceManufacturingInfoList(AccountController.shared.gatewayDevId ?? "", macList: macList, callback: callBackAdapter)
        }
    }
    
    func setGatewayNickname(deviceId: String, gatewayName: String, completion: @escaping(_ result: HwSetGatewayNicknameResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwSetGatewayNicknameResult {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwUserService {
            service.setGatewayNickname(deviceId, withGatewayNickname: gatewayName, withCallBack: callBackAdapter)
        }
    }
    
    func getWifiInfoAll(completion: @escaping(_ result: HwWifiInfoAll) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwWifiInfoAll {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getWifiInfoAll(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func setWifiInfoList(wifiInfos: [HwWifiInfo], completion: @escaping(_ result: HwSetWifiInfoListResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = { value in
            if let data = value as? HwSetWifiInfoListResult {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.setWifiInfoList(AccountController.shared.gatewayDevId ?? "", withWifiInfos: wifiInfos, with: callBackAdapter)
        }
    }
    
    func getWifiInfo(ssidIndex: Int32, completion: @escaping(_ result: HwWifiInfo) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwWifiInfo {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getWifiInfo(AccountController.shared.gatewayDevId ?? "", withSsidIndex: ssidIndex, with: callBackAdapter)
        }
    }
    
    func getGuestWifiInfo(completion: @escaping(_ result: HwGuestWifiInfo) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwGuestWifiInfo {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getGuestWifiInfo(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }

    func getWifiTimer(completion: @escaping(_ result: HwWifiTimer) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwWifiTimer {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getWifiTimer(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func setWifiTimer(timer: HwWifiTimer, completion: @escaping(_ result: HwSetWifiTimerResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwSetWifiTimerResult {
                completion(data)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.setWifiTimer(AccountController.shared.gatewayDevId ?? "", with: timer, with: callBackAdapter)
        }
    }
    
    func getPortMappingInfoWithDeviceId(deviceId: String, completion: @escaping(_ result: [HwPortMappingInfo]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwPortMappingInfo] {
                completion(data)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getPortMappingInfo(withDeviceId: deviceId, callback: callBackAdapter)
        }
    }
    
    func getPPPoEAccount(deviceId: String, wanName: String, completion: @escaping(_ result: HwPPPoEAccount) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwPPPoEAccount {
                completion(data)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getPPPoEAccount(deviceId, withWanName: wanName, with: callBackAdapter)
        }
    }
    
    func enableWifiHardwareSwitch(radioType: String, completion: @escaping(_ result: HwSetWiFiRadioSwtichResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwSetWiFiRadioSwtichResult {
                completion(data)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.setWifiHardwareSwitch(AccountController.shared.gatewayDevId ?? "", withRadioType: radioType, withEnableState: true, withCallBack: callBackAdapter)
        }
    }
    
    func removeOfflineDevList(lanMac: String, completion: @escaping(_ result: HwResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwResult {
                completion(data)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        let lanDevice = HwLanDevice()
        lanDevice.mac = lanMac
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.removeOfflineDevList(AccountController.shared.gatewayDevId ?? "", withLanDevice: [lanDevice], with: callBackAdapter)
        }
    }
    
    func registerMessageHandle(completion: @escaping(_ result: HwMessageData) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwMessageHandleAdapter()
        callBackAdapter.handle = {value in
            if let message = value {
                completion(message)
            }
        }
        
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwMessageService.self) as? HwMessageService {
            service.registerMessageHandle(callBackAdapter)
        }
    }
    
    func mapErrorMsg(_ errorCode: String) -> String {
        switch errorCode {
        case "-10":
            return "A service interface is invoked before the login() or isLogined() method is invoked."
        case "-9":
            return "A service interface is invoked before the HwNetopenMobile.initWith***() method is invoked."
        case "-8":
            return "The method is temporarily not implemented by the SDK."
        case "-7":
            return "The SDK has a java runtime exception such as JSONException."
        case "-6":
            return "The server end returns a message that does not carry any parameter."
        case "-5":
            return "Incorrect input parameter."
        case "-4":
            return "The gateway returns a message that does not carry any parameter."
        case "-3":
            return "A network connection fails."
        case "-2":
            return "A network request times out."
        case "-1":
            return "Operation failed."
        case "0":
            return "Operation succeeded."
        case "012":
            return "The token is invalid."
        case "014":
            return "The number of terminals bound to the current user already reaches the upper limit."
        case "015":
            return "The number of users bound to the terminal already reaches the upper limit."
        case "016":
            return "The terminal MAC address is invalid."
        case "027":
            return "The clientID value cannot be empty."
        case "028":
            return "The clientID value is invalid."
        case "035":
            return "A plug-in list query fails."
        case "050":
            return "The parameter is invalid."
        case "086":
            return "The device has been bound to the room."
        case "106":
            return "The user token cannot be empty."
        case "132":
            return "The phone number is not bound yet."
        case "139":
            return "The user does not have this permission."
        case "147":
            return "Upgrading the gateway..."
        case "149":
            return "The room name already exists."
        case "168":
            return "Starting the plug-in..."
        case "169":
            return "Starting the plug-in..."
        case "170":
            return "Removing the plug-in..."
        case "189":
            return "This MAC address access is unauthorized."
        case "190":
            return "This home information access is unauthorized."
        case "231":
            return "The verification code expires."
        case "999":
            return "A server internal error occurs."
        case "2001":
            return "The input parameter is null."
        case "2002":
            return "The room does not exist."
        case "2003":
            return "The device SN does not exist."
        case "2004":
            return "The device is already added."
        case "2005":
            return "No such device service is purchased."
        case "2006":
            return "The package is not activated."
        case "2007":
            return "The number of devices exceeds the limit of package."
        case "2008":
            return "The device name already exists."
        case "2009":
            return "Failed to query the package status."
        default:
            return "An SDK internal error occurs."
        }
    }
}
