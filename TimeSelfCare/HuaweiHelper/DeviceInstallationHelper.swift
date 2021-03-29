//
//  DeviceInstallationHelper.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 26/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import Foundation
import HwMobileSDK

public class DeviceInstallationHelper {
    private static let singleton: DeviceInstallationHelper = DeviceInstallationHelper()
    public static var shared: DeviceInstallationHelper {
        return DeviceInstallationHelper.singleton
    }
}

public extension DeviceInstallationHelper {
    func getLanDeviceOKCList(completion: @escaping(_ result: [HwOKCWhiteInfo]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwOKCWhiteInfo] {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwControllerService {
            service.getLanDeviceOKCList(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func getOKCWhiteList(completion: @escaping(_ result: [HwOKCWhiteInfo]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwOKCWhiteInfo] {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwControllerService {
            service.getOKCWhiteList(AccountController.shared.gatewayDevId ?? "", with: callBackAdapter)
        }
    }
    
    func deleteOKCWhiteList(list: [String], completion: @escaping(_ result: [HwOKCWhiteInfo]) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? [HwOKCWhiteInfo] {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwControllerService {
            service.deleteOKCWhiteList(AccountController.shared.gatewayDevId ?? "",withList: list, with: callBackAdapter)
        }
    }
    
    func addOKCWhiteList(list: [HwOKCWhiteInfo], completion: @escaping(_ result: HwResult) -> Void, error: @escaping(_ result: HwActionException?) -> Void) {
        let callBackAdapter = HwCallbackAdapter()
        callBackAdapter.handle = {value in
            if let data = value as? HwResult {
                completion(data)
            }
        }
        callBackAdapter.exception = {(exception: HwActionException?) in
            error(exception)
        }
        
        if let service = HwNetopenMobileSDK.getService(HwUserService.self) as? HwControllerService {
            service.addOKCWhiteList(AccountController.shared.gatewayDevId ?? "", withList: list, with: callBackAdapter)
        }
    }
}
