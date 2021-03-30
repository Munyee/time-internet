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
}
