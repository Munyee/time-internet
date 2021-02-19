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
        let callBackAdapter = HwCallbackAdapter.init()
        callBackAdapter.handle = {value in
            if let _ = value as? HwAuthInitResult {
                completion()
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        let param = HwAppAuthInitParam.init() // swiftlint:disable:this
        param.ip = "nce.time.com.my"
        param.port = 30110 // swiftlint:disable:this
        param.locale = NSLocale.system
        HwNetopenMobileSDK.initWithHwAuth(param, with: callBackAdapter)
    }
    
    func login(completion: @escaping(_ result: HwLoginInfo) -> Void) {
        let callBackAdapter = HwCallbackAdapter.init()
        callBackAdapter.handle = {value in
            if let result = value as? HwLoginInfo  {
                completion(result)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            print(exception?.errorCode ?? "")
        }
        
        let loginParam = HwLoginParam.init()
        //        loginParam.account = "timence2"
        //        loginParam.password = "timence2@"
        loginParam.account = "timetestnce"
        loginParam.password = "Time123"
        HwNetopenMobileSDK.login(loginParam, with: callBackAdapter)
    }
    
    func checkIsLogin(completion: @escaping(_ result: HwIsLoginedResult) -> Void) {
        let callBackAdapter = HwCallbackAdapter.init()
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
        let callBackAdapter = HwCallbackAdapter.init()
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
        let callBackAdapter = HwCallbackAdapter.init()
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
        let callBackAdapter = HwCallbackAdapter.init()
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
}
