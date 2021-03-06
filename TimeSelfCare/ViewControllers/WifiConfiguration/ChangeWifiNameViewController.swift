//
//  ChangeWifiNameViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 11/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class ChangeWifiNameViewController: UIViewController {
    
    var wifiInfos: [HwWifiInfo?] = []
    var isDualband: Bool?
    var originalPassword: String?

    @IBOutlet private weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet private weak var ssidName: FloatLabeledTextView!
    @IBOutlet private weak var ssidSeparator: UIView!
    @IBOutlet private weak var ssidPassword: FloatLabeledTextView!
    @IBOutlet private weak var ssidPasswordSeparator: UIView!
    @IBOutlet private weak var visiblePassword: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.liveChatView.isHidden = false
        self.title = NSLocalizedString("CHANGE WIFI NAME", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        setUpTextField(textField: ssidName)
        setUpTextField(textField: ssidPassword)
        
        saveButton.backgroundColor = .gray
        saveButton.isUserInteractionEnabled = false
        
        if let firstWifiInfo = wifiInfos.sorted(by: { (wifiInfoA, wifiInfoB) -> Bool in
            return "\(wifiInfoA?.ssidIndex)".compare("\(wifiInfoB?.ssidIndex)", options: .numeric) == .orderedAscending
        }).first(where: { $0?.radioType == "5G" }) {
            ssidName.text = firstWifiInfo?.ssid
        }
    }
    
    func setUpTextField(textField: FloatLabeledTextView) {
        textField.font = UIFont.preferredFont(forTextStyle: .title3)
        textField.textColor = .black
        textField.floatingLabelTextColor = .grey
        textField.floatingLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
        textField.tintColor = .primary
        textField.delegate = self
        textField.returnKeyType = .done
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = .no
        textField.isScrollEnabled = false
        addDoneKeyboard(textView: textField)
    }
    
    func addDoneKeyboard(textView: FloatLabeledTextView) {
        let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.backgroundColor = UIColor.white
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: textView, action: #selector(textView.resignFirstResponder))
        doneButton.tintColor = textView.tintColor
        
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }
    
    @objc
    func popBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.liveChatView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }

    @IBAction func actSave(_ sender: Any) {
        self.showAlertMessage(title: "Change WiFi Login", message: "All your devices will be disconnected. Please reconnect with your new WiFi name and/or password.", actions: [
            UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .destructive) { _ in
                var arrWifiInfo: [HwWifiInfo?] = []
                
                if let wifiInfo5g = self.wifiInfos.sorted(by: { (wifiInfoA, wifiInfoB) -> Bool in
                    return "\(String(describing: wifiInfoA?.ssidIndex))".compare("\(String(describing: wifiInfoB?.ssidIndex))", options: .numeric) == .orderedAscending
                }).first(where: { $0?.radioType == "5G" }) {
                    arrWifiInfo.append(wifiInfo5g)
                }
                
                if let wifiInfo2p4g = self.wifiInfos.sorted(by: { (wifiInfoA, wifiInfoB) -> Bool in
                    return "\(String(describing: wifiInfoA?.ssidIndex))".compare("\(String(describing: wifiInfoB?.ssidIndex))", options: .numeric) == .orderedAscending
                }).first(where: { $0?.radioType == "2.4G" }) {
                    arrWifiInfo.append(wifiInfo2p4g)
                }
                
                for wifiInfo in arrWifiInfo {
                    if self.isDualband! {
                        wifiInfo?.ssid = self.ssidName.text
                    } else {
                        if wifiInfo?.radioType == "5G" {
                            wifiInfo?.ssid = self.ssidName.text
                        } else {
                            wifiInfo?.ssid = "\(self.ssidName.text ?? "")_2.4G"
                        }
                    }
                    wifiInfo?.password = self.originalPassword
                }
                
                if let wifiInfos = arrWifiInfo as? [HwWifiInfo] {
                    let hud = LoadingView().addLoading(toView: self.view)
                    hud.showLoading()
                    HuaweiHelper.shared.setWifiInfoList(wifiInfos: wifiInfos, completion: { _ in
                        DispatchQueue.main.async {
                            hud.hideLoading()
                            self.popBack()
                        }
                    }, error: { exception in
                        DispatchQueue.main.async {
                            self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
                            hud.hideLoading()
                        }
                    })
                }
            },
            UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            }
        ])
    }
    
    @IBAction func toggleVisibility(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        self.ssidPassword.isSecureTextEntry = !sender.isSelected
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

extension ChangeWifiNameViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == ssidName {
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
        
        if ssidName.text == "" || ssidPassword.text == "" {
            saveButton.backgroundColor = .gray
            saveButton.isUserInteractionEnabled = false
        } else {
            saveButton.backgroundColor = .primary
            saveButton.isUserInteractionEnabled = true
        }
    }
}
