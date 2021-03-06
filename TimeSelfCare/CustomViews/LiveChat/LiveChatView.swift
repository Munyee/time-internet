//
//  LiveChatView.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 08/05/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class LiveChatView: UIView, UIActionSheetDelegate {

    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("LiveChatView", owner: self, options: nil)
        addSubview(contentView)
    }

    @IBAction func actClick(_ sender: Any) {
        LiveChatDataController.shared.loadStatus { statusResult in
            if let status = statusResult {
                if (status == "online") {
                    DispatchQueue.main.async {
                        if let selectedAccount = AccountController.shared.selectedAccount, let service = ServiceDataController.shared.getServices(account: selectedAccount).first {
                            if let restoreID = FreshChatManager.shared.restoreID, let username = selectedAccount.profileUsername {
                                Freshchat.sharedInstance().identifyUser(withExternalID: username, restoreID: restoreID)
                            } else {
                                let user = FreshchatUser.sharedInstance()
                                let profile = selectedAccount.profile
                                user.firstName = profile?.fullname
                                user.email = profile?.email
                                user.phoneNumber = profile?.mobileNo
                                Freshchat.sharedInstance().setUserPropertyforKey("AccountNo", withValue: selectedAccount.accountNo)
                                Freshchat.sharedInstance().setUserPropertyforKey("so_number", withValue: service.serviceId)
                                Freshchat.sharedInstance().setUser(user)
                                if let username = selectedAccount.profileUsername {
                                    Freshchat.sharedInstance().identifyUser(withExternalID: username, restoreID: nil)
                                }
                            }
                            
                            let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
                            alert.addAction(UIAlertAction(title: "Conversations", style: .default , handler:{ (UIAlertAction) in
                                Freshchat.sharedInstance().showConversations(self.viewController(forView: self)!)
                            }))
                            alert.addAction(UIAlertAction(title: "FAQ", style: .default , handler:{ (UIAlertAction) in
                                Freshchat.sharedInstance().showFAQs(self.viewController(forView: self)!)
                            }))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
                            self.viewController(forView: self)?.present(alert, animated: true, completion: nil)
                        } else {
                            if let viewController = UIStoryboard(name: "LiveChatUserDetailsViewController", bundle: nil).instantiateViewController(withIdentifier: "LiveChatUserDetailsViewController") as? LiveChatUserDetailsViewController {
                                if let previousViewController = self.viewController(forView: self) {
                                    viewController.modalTransitionStyle = .crossDissolve
                                    viewController.modalPresentationStyle = .overFullScreen
                                    viewController.previousViewController = previousViewController
                                    self.viewController(forView: self)?.present(viewController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                } else {
                    if var vc = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = vc.presentedViewController {
                            vc = presentedViewController
                        }

                        if let alertView = UIStoryboard(name: "LiveChatAlert", bundle: nil).instantiateViewController(withIdentifier: "alertView") as? LiveChatPopUpViewController {
                            vc.addChild(alertView)
                            alertView.view.frame = vc.view.frame
                            vc.view.addSubview(alertView.view)
                            alertView.didMove(toParent: vc)
                        }
                    }
                }
            }
        }
    }

    func viewController(forView: UIView) -> UIViewController? {
        var nr = forView.next
        while nr != nil && !(nr! is UIViewController) {
            nr = nr!.next
        }
        return nr as? UIViewController
    }

}
