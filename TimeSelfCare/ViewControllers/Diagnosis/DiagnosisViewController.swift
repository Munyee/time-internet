//
//  DiagnosisViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 04/11/2019.
//  Copyright © 2019 Apptivity Lab. All rights reserved.
//

import UIKit

class DiagnosisViewController: TimeBaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))
        self.title = NSLocalizedString("Diagnosis", comment: "")
        Keyboard.addKeyboardChangeObserver(self)
    }
    
    @IBAction func raiseTicket(_ sender: UIButton) {
        print(AccountController.shared.selectedAccount?.accountNo)
        
    }
    
    @IBAction func backToHomepage(_ sender: UIButton) {
        self.dismissVC()
    }
    
//    @objc
//    private func createTicket() {
//        let ticket = Ticket(id: "")
//        ticket.categoryOptions = TicketDataController.shared.categoryOptions
//        for i in 0..<componentViews.count {
//            guard let component = TicketFormComponent(rawValue: i) else {
//                continue
//            }
//
//            switch component {
//            case .category:
//                ticket.displayCategory = componentViews[i].text
//            case .title:
//                ticket.subject = componentViews[i].text
//            case .message:
//                ticket.description = componentViews[i].text
//            }
//        }
//        ticket.accountNo = AccountController.shared.selectedAccount?.accountNo
//
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.label.text = NSLocalizedString("Creating ticket...", comment: "")
//        let images: [UIImage] = self.selectedImageInfo.compactMap {
//            guard var image = $0[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
//                return nil
//            }
//
//            let ratio = max(
//                max(image.size.width, image.size.height) / 1_920,
//                min(image.size.width, image.size.height) / 1_080
//            )
//            if ratio > 1 {
//                image = image.scaledTo(scale: 1 / ratio)
//            }
//            return image
//        }
//
//        TicketDataController.shared.createTicket(ticket, account: AccountController.shared.selectedAccount, attachments: images) { (error: Error?) in
//            hud.hide(animated: true)
//            if let error = error {
//                self.showAlertMessage(with: error)
//                return
//            }
//
//            let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
//            confirmationVC.mode = .ticketSubmitted
//            confirmationVC.actionBlock = {
//                self.dismissVC()
//            }
//            self.present(confirmationVC, animated: true, completion: nil)
//        }
//    }

}

extension DiagnosisViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
