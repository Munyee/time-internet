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
                completion()
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        let param = HwAppAuthInitParam() // swiftlint:disable:this
        param.ip = "nce.time.com.my"
        param.port = 30110 // swiftlint:disable:this
        param.locale = NSLocale.system
        HwNetopenMobileSDK.initWithHwAuth(param, with: callBackAdapter)
    }
    
    func login(completion: @escaping(_ result: HwLoginInfo) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let result = value as? HwLoginInfo {
                completion(result)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        let loginParam = HwLoginParam()
        //        loginParam.account = "timence2"
        //        loginParam.password = "timence2@"
        loginParam.account = "timetestnce"
        loginParam.password = "Time123"
        HwNetopenMobileSDK.login(loginParam, with: callBackAdapter)
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
    
    func loginInfo(result: HwLoginInfo?) {
        if let gateway = result?.gatewayInfoList.firstObject as? HwGatewayInfo {
            AccountController.shared.gatewayDevId = gateway.deviceId
        }
    }
    
    func queryGateway(completion: @escaping(_ result: HwSystemInfo) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let gateway = value as? HwSystemInfo {
                completion(gateway)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getSystemInfo(AccountController.shared.gatewayDevId, with: callBackAdapter)
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
    
    func getAttachParentControlList(completion: @escaping(_ result: [HwAttachParentControl]) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let tplList = value as? [HwAttachParentControl] {
                completion(tplList)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        if let service = HwNetopenMobileSDK.getService(HwControllerService.self) as? HwControllerService {
            service.getAttachParentControlList(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func getAttachParentalControlTemplateList(completion: @escaping(_ result: [HwAttachParentControlTemplate]) -> Void,  error: @escaping(_ result: HwActionException?) -> Void) {
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
    
    func getParentControlTemplateDetailList(templateNames: [String], completion: @escaping(_ result: [HwAttachParentControlTemplate]) -> Void,  error: @escaping(_ result: HwActionException?) -> Void) {
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
}
