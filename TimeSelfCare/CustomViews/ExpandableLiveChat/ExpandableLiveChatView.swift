//
//  LiveChatView.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 08/05/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ExpandableLiveChatView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var liveChat: UILabel!
    @IBOutlet weak var liveChatSmall: UILabel!
    var isExpand = false

    let expandedX: CGFloat = 0.0
    let collapseX: CGFloat = -125.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ExpandableLiveChatView", owner: self, options: nil)
        addSubview(contentView)
        self.roundCorners(corners: [.topRight, .bottomRight], radius: 5)
        self.clipsToBounds = true
        liveChatSmall.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        liveChat.alpha = 0
        liveChatSmall.alpha = 1

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        contentView.addGestureRecognizer(leftSwipe)
    }

    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {

        if (sender.direction == .left) {
            toggleAnimation()
        }
    }

    @IBAction func actClick(_ sender: Any) {
        if (isExpand) {
            if let selectedAccount = AccountController.shared.selectedAccount {
                let user = FreshchatUser.sharedInstance()
                let profile = selectedAccount.profile
                user?.firstName = profile?.fullname
                user?.email = profile?.email
                user?.phoneNumber = profile?.mobileNo
                Freshchat.sharedInstance().setUser(user)
                Freshchat.sharedInstance().setUserPropertyforKey("AccountNo", withValue: selectedAccount.accountNo)
            }

            let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "Conversations", style: .default , handler:{ (UIAlertAction) in
                Freshchat.sharedInstance()?.showConversations(self.viewController(forView: self))
            }))

            alert.addAction(UIAlertAction(title: "FAQ", style: .default , handler:{ (UIAlertAction) in
                Freshchat.sharedInstance()?.showFAQs(self.viewController(forView: self))
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

            viewController(forView: self)?.present(alert, animated: true, completion: nil)
        }
        toggleAnimation()
    }

    func toggleAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(x: self.isExpand ? self.collapseX : self.expandedX, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)

            if (self.isExpand) {
                self.liveChat.alpha = 0
                self.liveChatSmall.alpha = 1
            } else {
                self.liveChat.alpha = 1
                self.liveChatSmall.alpha = 0
            }
            self.isExpand = !self.isExpand
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
