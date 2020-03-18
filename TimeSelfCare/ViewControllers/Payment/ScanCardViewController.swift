//
//  ScanCardViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 27/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import AVFoundation

internal protocol ScanCardViewControllerDelegate: class {
    func scanCardViewController(didScanCardInfo cardInfo: CardIOCreditCardInfo)
}

internal class ScanCardViewController: TimeBaseViewController {
    weak var delegate: ScanCardViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Scan Card", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.cancelScannning))
        let frame = CGRect(origin: self.view.frame.origin, size: self.view.frame.size)

        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch authStatus {
        case .authorized:
            initCardIOView(frame)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    DispatchQueue.main.async {
                        self.initCardIOView(frame)
                    }
                } else {
                    self.dismissVC()
                }
            })
        case .denied, .restricted:
            let alertActions: [UIAlertAction] = [
                UIAlertAction(title: NSLocalizedString("Open Settings", comment: ""), style: .default, handler: { _ in
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                UIAlertAction(title: NSLocalizedString("Later", comment: ""), style: .cancel, handler: { _ in
                    self.dismissVC()
                })
            ]

            self.showAlertMessage(message: NSLocalizedString("Please enable Camera Permission to scan your card", comment: ""), actions: alertActions)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CardIOUtilities.preloadCardIO()
    }

    private func initCardIOView(_ frame: CGRect) {
        let newcardIOView = CardIOView(frame: frame)
        newcardIOView.delegate = self
        newcardIOView.hideCardIOLogo = true
        self.view.addSubview(newcardIOView)
    }

    @objc
    func cancelScannning() {
        self.dismissVC()
    }
}

extension ScanCardViewController: CardIOViewDelegate {
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) { // swiftlint:disable:this implicitly_unwrapped_optional
        guard cardInfo.cardNumber != nil else {
            let error = NSError(domain: "TimeSelfCare", code: 500, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Not able to detect card number", comment: "")])
            self.showAlertMessage(with: error)
            return
        }
        delegate?.scanCardViewController(didScanCardInfo: cardInfo)
        self.dismissVC()
    }
}
