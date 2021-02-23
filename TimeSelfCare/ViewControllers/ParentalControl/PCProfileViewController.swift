//
//  PCProfileViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class PCProfileViewController: UIViewController {
    
    var selectedDevices: [HwLanDevice] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileTextView: FloatLabeledTextView!
    @IBOutlet weak var profileSeperator: UIView!
    
    @IBOutlet weak var deviceTextView: FloatLabeledTextView!
    @IBOutlet weak var deviceSeperator: UIView!
    @IBOutlet weak var selectDeviceStack: UIStackView!
    @IBOutlet weak var selectDeviceView: UIControl!
    
    @IBOutlet weak var periodTextView: FloatLabeledTextView!
    @IBOutlet weak var periodSeperator: UIView!
    @IBOutlet weak var selectPeriodView: UIView!
    
    @IBOutlet weak var blockWebsiteStack: UIStackView!
    @IBOutlet weak var blockWebsiteTextView: FloatLabeledTextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PCProfileViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PCProfileViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.title = NSLocalizedString("PARENTAL CONTROLS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        self.liveChatView.isHidden = false
        setupProfileName()
        setupDevice()
        setupBlockWebsite()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if liveChatView.isExpand {
            liveChatConstraint.constant = 0
        } else {
            liveChatConstraint.constant = -125
        }
    }
    
    func setupProfileName() {
        profileTextView.font = UIFont.preferredFont(forTextStyle: .title3)
        profileTextView.textColor = .black
        profileTextView.floatingLabelTextColor = .grey
        profileTextView.floatingLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
        profileTextView.floatingLabel.text = "Profile name"
        profileTextView.tintColor = .primary
        profileTextView.delegate = self
        profileTextView.autocapitalizationType = .sentences
        profileTextView.autocorrectionType = .no
        profileTextView.isScrollEnabled = false
        addDoneKeyboard(textView: profileTextView)
    }
    
    func setupDevice() {
        deviceTextView.floatingLabelTextColor = .grey
        deviceTextView.floatingLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
        deviceTextView.floatingLabel.text = "Device(s)"
        deviceTextView.delegate = self
        deviceTextView.autocapitalizationType = .sentences
        deviceTextView.autocorrectionType = .no
        deviceTextView.isScrollEnabled = false
    }
    
    func setupBlockWebsite() {
        insertBlockWebsiteInput()
        blockWebsiteTextView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        blockWebsiteTextView.animateEvenIfNotFirstResponder = true
    }
    
    func insertBlockWebsiteInput() {
        let blockWebsiteView = BlockWebsiteView(allowRemove: false, isPrimary: true)
        blockWebsiteView.delegate = self
        blockWebsiteStack.addArrangedSubview(blockWebsiteView)
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
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @IBAction func actDeviceSelect(_ sender: Any) {
        if let devicesVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCDevicesViewController") as? PCDevicesViewController {
            devicesVC.delegate = self
            self.presentNavigation(devicesVC, animated: true)
        }
    }
    
    @IBAction func actPeriodSelect(_ sender: Any) {
        if let devicesVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCPeriodViewController") as? PCPeriodViewController {
            self.presentNavigation(devicesVC, animated: true)
        }
    }
}

extension PCProfileViewController: BlockWebsiteViewDelegate {
    func didBeginEdit(separator: UIView) {
        separator.backgroundColor = .primary
        blockWebsiteTextView.floatingLabelTextColor = .primary
        blockWebsiteTextView.layoutSubviews()
    }
    
    func didEndEdit(separator: UIView) {
        separator.backgroundColor = UIColor(hex: "D9D9D9")
        blockWebsiteTextView.floatingLabelTextColor = .grey
        blockWebsiteTextView.layoutSubviews()
    }
    
    func didEditChange(textField: UITextField) {
        blockWebsiteTextView.text = textField.text
    }
}

extension PCProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == profileTextView {
            profileSeperator.backgroundColor = .primary
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        profileSeperator.backgroundColor = UIColor(hex: "D9D9D9")
    }
}

extension PCProfileViewController: PCDevicesViewControllerDelegate {
    func selected(devices: [HwLanDevice]) {
        selectedDevices = devices
        updateDeviceList()
    }
    
    func updateDeviceList() {
        for view in selectDeviceStack.subviews {
            if let devView = view as? DeviceView {
                selectDeviceStack.removeArrangedSubview(devView)
                devView.removeFromSuperview()
            }
        }
        
        if selectedDevices.isEmpty {
            selectDeviceView.isHidden = false
            deviceTextView.alwaysShowFloatingLabel = false
        } else {
            selectDeviceView.isHidden = true
            deviceTextView.alwaysShowFloatingLabel = true
            for device in selectedDevices {
                let deviceView = DeviceView(device: device)
                deviceView.delegate = self
                selectDeviceStack.addArrangedSubview(deviceView)
            }
        }
    }
}

extension PCProfileViewController: DeviceViewDelegate {
    func removeDevice(device: HwLanDevice) {
        let index = selectedDevices.firstIndex(of: device)
        if let i = index {
            selectedDevices.remove(at: i)
            let view = selectDeviceStack.subviews[i + 1]
            selectDeviceStack.removeArrangedSubview(view)
            view.removeFromSuperview()
            
            if selectedDevices.isEmpty {
                selectDeviceView.isHidden = false
                deviceTextView.alwaysShowFloatingLabel = false
            }
        }
    }
    
    func showDevices() {
        if let devicesVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCDevicesViewController") as? PCDevicesViewController {
            devicesVC.delegate = self
            devicesVC.selectedDevices = selectedDevices
            self.presentNavigation(devicesVC, animated: true)
        }
    }
}
