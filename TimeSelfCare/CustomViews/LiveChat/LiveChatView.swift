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

        if let selectedAccount = AccountController.shared.selectedAccount {
            let user = FreshchatUser.sharedInstance()
            let profile = selectedAccount.profile
            user.firstName = profile?.fullname
            user.email = profile?.email
            user.phoneNumber = profile?.mobileNo
            Freshchat.sharedInstance().setUser(user)
            Freshchat.sharedInstance().setUserPropertyforKey("AccountNo", withValue: selectedAccount.accountNo)
        }

        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Conversations", style: .default , handler:{ (UIAlertAction) in
            Freshchat.sharedInstance().showConversations(self.viewController(forView: self)!)
        }))

        alert.addAction(UIAlertAction(title: "FAQ", style: .default , handler:{ (UIAlertAction) in
            Freshchat.sharedInstance().showFAQs(self.viewController(forView: self)!)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        viewController(forView: self)?.present(alert, animated: true, completion: nil)
    }

    func viewController(forView: UIView) -> UIViewController? {
        var nr = forView.next
        while nr != nil && !(nr! is UIViewController) {
            nr = nr!.next
        }
        return nr as? UIViewController
    }

}
