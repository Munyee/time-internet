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
    var selectedPeriod: [SelectPeriod] = []

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var liveChatView: ExpandableLiveChatView!
    @IBOutlet weak var liveChatConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileTextView: FloatLabeledTextView!
    @IBOutlet weak var profileSeperator: UIView!
    
    @IBOutlet weak var deviceView: UIView!
    @IBOutlet weak var deviceTextView: FloatLabeledTextView!
    @IBOutlet weak var deviceSeperator: UIView!
    @IBOutlet weak var selectDeviceStack: UIStackView!
    @IBOutlet weak var selectDeviceView: UIControl!
    
    @IBOutlet weak var periodView: UIView!
    @IBOutlet weak var periodTextView: FloatLabeledTextView!
    @IBOutlet weak var selectPeriodStack: UIStackView!
    @IBOutlet weak var selectPeriodView: UIControl!

    @IBOutlet weak var blockWebsiteStack: UIStackView!
    @IBOutlet weak var blockWebsiteTextView: FloatLabeledTextView!
        
    @IBOutlet weak var addTimeView: UIView!
    @IBOutlet weak var addWebsiteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PCProfileViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PCProfileViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.title = NSLocalizedString("PARENTAL CONTROLS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        self.liveChatView.isHidden = false
        addTimeView.isHidden = true
        addWebsiteView.isHidden = true
        setupProfileName()
        setupDevice()
        setupPeriod()
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
        profileTextView.returnKeyType = .done
        profileTextView.autocapitalizationType = .sentences
        profileTextView.autocorrectionType = .no
        profileTextView.isScrollEnabled = false
        addDoneKeyboard(textView: profileTextView)
    }
    
    func setupDevice() {
        deviceTextView.floatingLabelTextColor = .grey
        deviceTextView.floatingLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
        deviceTextView.floatingLabel.text = "Device(s)"
    }
    
    func setupPeriod() {
        periodTextView.floatingLabelTextColor = .grey
        periodTextView.floatingLabelFont = UIFont.preferredFont(forTextStyle: .caption1)
        periodTextView.floatingLabel.text = "Internet access period"
    }
    
    func setupBlockWebsite() {
        insertBlockWebsiteInput(allowRemove:false, isPrimary: true)
        blockWebsiteTextView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        blockWebsiteTextView.animateEvenIfNotFirstResponder = true
    }
    
    func insertBlockWebsiteInput(allowRemove: Bool, isPrimary: Bool) {
        let blockWebsiteView = BlockWebsiteView(allowRemove: allowRemove, isPrimary: isPrimary)
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
        if let periodVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCPeriodViewController") as? PCPeriodViewController {
            periodVC.delegate = self
            self.presentNavigation(periodVC, animated: true)
        }
    }
    
    @IBAction func actAddWebsite(_ sender: Any) {
        insertBlockWebsiteInput(allowRemove: true, isPrimary: false)
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
        addWebsiteView.isHidden = false
    }
    
    func didEditChange(textField: UITextField) {
        blockWebsiteTextView.text = textField.text
    }
    
    func delete(view: UIView) {
        blockWebsiteStack.removeArrangedSubview(view)
        view.removeFromSuperview()
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
        
        if textView == profileTextView {
            if !deviceView.isUserInteractionEnabled && profileTextView.text != "" {
                UIView.animate(withDuration: 0.5) {
                    self.deviceView.isUserInteractionEnabled = true
                    self.deviceView.alpha = 1
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
            if !periodView.isUserInteractionEnabled {
                UIView.animate(withDuration: 0.5) {
                    self.periodView.isUserInteractionEnabled = true
                    self.periodView.alpha = 1
                }
            }
            
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

extension PCProfileViewController: PCPeriodViewControllerDelegate {
    func selected(period: SelectPeriod) {
        
        if period.index == nil {
            period.index = selectedPeriod.count
            selectedPeriod.append(period)
        } else {
            if let index = selectedPeriod.firstIndex(where: { $0.index == period.index }) {
                selectedPeriod[index] = period
            }
        }
        
        
        for pView in selectPeriodStack.arrangedSubviews {
            if let periodView = pView as? PeriodView {
                selectPeriodStack.removeArrangedSubview(periodView)
                periodView.removeFromSuperview()
            }
        }
        
        for period in selectedPeriod {
            let periodView = PeriodView(period: period)
            periodView.delegate = self
            selectPeriodStack.addArrangedSubview(periodView)
        }
        
        periodTextView.alwaysShowFloatingLabel = true
        selectPeriodView.isHidden = true
        addTimeView.isHidden = false
    }
}

extension PCProfileViewController: PeriodViewDelegate {
    func remove(period: SelectPeriod) {
        if let i = period.index {
            selectedPeriod.remove(at: i)
            let view = selectPeriodStack.subviews[i + 1]
            selectPeriodStack.removeArrangedSubview(view)
            view.removeFromSuperview()
            
            for (index, period) in selectedPeriod.enumerated() {
                period.index = index
            }
            
            if selectedPeriod.isEmpty {
                addTimeView.isHidden = true
                selectPeriodView.isHidden = false
                periodTextView.alwaysShowFloatingLabel = false
            }
        }
    }
    
    func editPeriod(period: SelectPeriod) {
        if let periodVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCPeriodViewController") as? PCPeriodViewController {
            periodVC.delegate = self
            var periods: [PeriodModel?] = []
            
            if period.repeatMode == kHwRepeatModeNone {
                periods.append(PeriodModel(with: ["repeatMode": kHwRepeatModeNone]))
            } else {
                if let dayWeek = period.dayOfWeeks {
                    for day in dayWeek {
                        periods.append(PeriodModel(with: ["repeatMode": period.repeatMode, "type": day]))
                    }
                }
            }
            
            if let selectPeriod = periods as? [PeriodModel] {
                periodVC.selectedPeriod = selectPeriod
            }
            periodVC.repeatMode = period.repeatMode
            periodVC.index = period.index
            periodVC.startH = Int(period.startTime?.components(separatedBy: ":")[0] ?? "0") ?? 0
            periodVC.startM = Int(period.startTime?.components(separatedBy: ":")[1] ?? "0") ?? 0
            periodVC.endH = Int(period.endTime?.components(separatedBy: ":")[0] ?? "0") ?? 0
            periodVC.endM = Int(period.endTime?.components(separatedBy: ":")[1] ?? "0") ?? 0
            self.presentNavigation(periodVC, animated: true)
        }
    }
}
