//
//  EditGuestWifiViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class EditGuestWifiViewController: UIViewController {

    @IBOutlet weak var wifiName: FloatLabeledTextView!
    @IBOutlet weak var ssidPassword: FloatLabeledTextView!
    @IBOutlet weak var duration: FloatLabeledTextView!
    @IBOutlet private weak var ssidSeparator: UIView!
    @IBOutlet private weak var ssidPasswordSeparator: UIView!
    @IBOutlet private weak var visiblePassword: UIButton!
    
    var originalPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("GUEST WIFI", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        self.setupView()
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        wifiName.font = UIFont(name: "DINCondensed-Bold", size: 20)
        wifiName.floatingLabelFont = UIFont(name: "DIN-Light", size: 14)
        wifiName.floatingLabel.text = "Profile name"
        
        ssidPassword.font = UIFont(name: "DINCondensed-Bold", size: 20)
        ssidPassword.floatingLabelFont = UIFont(name: "DIN-Light", size: 14)
        ssidPassword.floatingLabel.text = "Password"
        
        duration.font = UIFont(name: "DINCondensed-Bold", size: 20)
        duration.floatingLabelFont = UIFont(name: "DIN-Light", size: 14)
        duration.floatingLabel.text = "WiFi duration"
    }
    
    @IBAction func toggleVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            ssidPassword.text = originalPassword
        } else {
            var pass = ""
            for _ in originalPassword ?? "" {
                pass+="*"
            }
            ssidPassword.text = pass
        }
    }
}

extension EditGuestWifiViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == wifiName {
            ssidSeparator.backgroundColor = UIColor(hex: "D9D9D9")
        } else if textView == ssidPassword {
            ssidPasswordSeparator.backgroundColor = UIColor(hex: "D9D9D9")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == ssidPassword {
            originalPassword = ((originalPassword ?? "") as NSString).replacingCharacters(in: range, with: text)
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == ssidPassword && !visiblePassword.isSelected {
            textView.text = String(repeating: "*", count: (textView.text ?? "").count)
        }
        
        if wifiName.text == "" || ssidPassword.text == "" {
//            saveButton.backgroundColor = .gray
//            saveButton.isUserInteractionEnabled = false
        } else {
//            saveButton.backgroundColor = .primary
//            saveButton.isUserInteractionEnabled = true
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == duration {
            if var vc = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = vc.presentedViewController {
                    vc = presentedViewController
                }
                
                if let durationVC = UIStoryboard(name: TimeSelfCareStoryboard.guestwifi.filename, bundle: nil).instantiateViewController(withIdentifier: "DurationViewController") as? DurationViewController {
                    vc.addChild(durationVC)
//                    durationVC.delegate = self
                    durationVC.view.frame = vc.view.frame
                    vc.view.addSubview(durationVC.view)
                    durationVC.didMove(toParent: vc)
                }
            }
            return false
        } else {
            return true
        }
    }
}
