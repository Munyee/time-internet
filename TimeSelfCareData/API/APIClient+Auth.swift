import Foundation
import Alamofire
import ApptivityFramework

extension APIClient {
    public func signUp(icNumber: String, accountNumber: String, password: String, completion: @escaping SimpleRequestListener) {
        let path = "register"
        let body: [String : Any] = [
            "action" : path,
            "account_no" : accountNumber,
            "ic_brn" : icNumber,
            "password": password,
            "token": self.getToken(forPath: path)
        ]

        self.request(method: .post, parameters: body).responseJSON { (response: DataResponse<Any>) in
            do {
                let responseJSON = try self.JSONFromResponse(response: response)
                self.extractLoginInfo(responseJSON)

                completion(nil)

            } catch {
                completion(error)
            }
        }
    }

    public func loginWithEmail(_ email: String, password: String, completion: @escaping SimpleRequestListener) {
        let path = "login"
        let body: [String : Any] = [
            "action" : path,
            "username" : email,
            "password" : password,
            "token" : self.getToken(forPath: path)
        ]

        self.request(method: .post, parameters: body).responseJSON { (response: DataResponse<Any>) in
            do {
                let responseJSON = try self.JSONFromResponse(response: response)
                self.extractLoginInfo(responseJSON)

                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    public func forgetPassword(_ username: String, accountNo: String, completion: @escaping SimpleRequestListener) {
        let path = "forgot_password"
        let body: [String : Any] = [
            "action" : path,
            "username" : username,
            "account_no" : accountNo,
            "token" : self.getToken(forPath: path)
        ]
        self.simplePost(body, completion: completion)
    }

    public func changeEmailAddress(_ username: String, email: String, completion: @escaping SimpleRequestListener) {
        let path = "change_email_address"
        let body: [String : Any] = [
            "action" : path,
            "username" : username,
            "email_address" : email,
            "token" : self.getToken(forPath: path),
            "session_id" : AccountController.shared.sessionId
        ]
        self.simplePost(body, completion: completion)
    }

    public func changePassword(_ username: String, currentPassword: String, newPassword: String, completion: @escaping SimpleRequestListener) {
        let path = "change_password"
        let body: [String : Any] = [
            "action" : path,
            "current_password": currentPassword,
            "new_password": newPassword,
            "retype_password": newPassword,
            "username" : username,
            "token" : self.getToken(forPath: path),
            "session_id" : AccountController.shared.sessionId
        ]
        self.simplePost(body, completion: completion)
    }
    
    public func editProfile(_ email: String, contact: String, completion: @escaping SimpleRequestListener) {
        let path = "change_profile"
        let body: [String : Any] = [
            "action" : path,
            "email_address": email,
            "contact": contact,
            "token" : self.getToken(forPath: path),
            "session_id" : AccountController.shared.sessionId
        ]
        self.simplePost(body, completion: completion)
    }

    public func verifyPasswordStrength(_ password: String, completion: @escaping ((_ passwordStrength: String?) -> Void)) {
        let path = "check_password"
        let body: [String : Any] = [
            "action" : path,
            "password": password,
            "token" : self.getToken(forPath: path)
        ]

        self.request(method: .post, parameters: body).responseJSON { (response: DataResponse<Any>) in
            if let json = response.result.value as? [String: Any],
                let status = json["status"] as? String {
                completion(status)
            } else {
                completion(nil)
            }
        }
    }

    public func removeAutoDebit(_ username: String, account: Account, completion: @escaping SimpleRequestListener) {
        let path = "remove_autodebit"
        let body: [String : Any] = [
            "action" : path,
            "username" : username,
            "account_no": account.accountNo,
            "token" : self.getToken(forPath: path),
            "session_id" : AccountController.shared.sessionId
        ]
        self.simplePost(body, completion: completion)
    }

    public func generateTHRCode(_ username: String, account: Account, service: Service, completion: @escaping ((_ service: Service, _ error: Error?) -> Void)) {
        let path = "gen_thf_qrcode"
        let body: [String : Any] = [
            "action" : path,
            "username" : username,
            "account_no": account.accountNo,
            "service_id": service.serviceId,
            "token" : self.getToken(forPath: path),
            "session_id" : AccountController.shared.sessionId
        ]
        self.request(method: .post, parameters: body).responseJSON { (response: DataResponse<Any>) in
            do {
                let responseJSON = try self.JSONFromResponse(response: response)
                if let dataJSON = responseJSON["data"] as? [String: Any] {
                    service.thfQrcodeCode = dataJSON["thf_qrcode_code"] as? String
                    service.thfQrcodeUrl = dataJSON["thf_qrcode_url"] as? String
                    service.thfQrcodeGenCount = Int(dataJSON["thf_qrcode_gen_count"] as? String ?? String())
                }

                completion(service, nil)

            } catch {
                completion(service, error)
            }
        }
    }

    public func simplePost(_ body: [String: Any], completion: @escaping SimpleRequestListener) {
        self.request(method: .post, parameters: body).responseJSON { (response: DataResponse<Any>) in
            do {
                _ = try self.JSONFromResponse(response: response)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    private func extractLoginInfo(_ responseJSON: [String : Any]) {
        if let profileJSON = responseJSON["data"] as? [String: Any], let profile = Profile(with: profileJSON) {
            AuthUser.current?.person = profile
            Installation.current().set(profileJSON["session_id"] as? String, forKey: sessionIdKey)
            AccountController.shared.needUpdateEmailAddress = (profileJSON["todo"] as? String) == "update_email_address"

//            for identityJSON in identitiesJSON {
//                if let identity = TimeSelfCareIdentity(with: identityJSON) {
//                    AuthUser.current?.saveIdentityToKeychain(identity)
//                }
//            }

            AuthUser.current?.save()
        }
    }

    public func logout(completion: @escaping SimpleRequestListener) {
        if let username = AccountController.shared.selectedAccount?.profile?.username, let sessionId = AccountController.shared.sessionId {
            let path = "logout"
            let body: [String : Any] = [
                "action": path,
                "token": self.getToken(forPath: path),
                "username": username,
                "session_id": sessionId
            ]
            self.request(method: .post, parameters: body).responseJSON { (response: DataResponse<Any>) in
                do {
                    _ = try self.JSONFromResponse(response: response)
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        } else {
            // No API call, assume success
            completion(nil)
        }
    }
}
