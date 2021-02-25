//
//  PCProfileViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK
import MBProgressHUD

class PCProfileViewController: UIViewController {
    
    var selectedDevices: [HwLanDevice] = []
    var selectedPeriod: [SelectPeriod] = []
    
    @IBOutlet weak var descView: UIView!
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
    
    @IBOutlet weak var blockWebsiteView: UIView!
    @IBOutlet weak var blockWebsiteStack: UIStackView!
    @IBOutlet weak var blockWebsiteTextView: FloatLabeledTextView!
    
    @IBOutlet weak var addTimeView: UIView!
    @IBOutlet weak var addWebsiteView: UIView!
    
    @IBOutlet weak var createProfile: UIControl!
    
    var isView: Bool = false
    var isEdit: Bool = false
    var template: HwAttachParentControlTemplate?
    private var name = "\(Date().timeIntervalSince1970)"
    
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
        
        if isView {
            descView.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.edit))
        }
        
        updateTemplateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.liveChatView.isHidden = true
    }
    
    @objc
    func popBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func edit() {
        descView.isHidden = false
        isEdit = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.save))
        updateTemplateView()
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
        insertBlockWebsiteInput(allowRemove:false, isPrimary: true, isEdit: true)
        blockWebsiteTextView.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        blockWebsiteTextView.animateEvenIfNotFirstResponder = true
    }
    
    // swiftlint:disable cyclomatic_complexity
    func updateTemplateView() {
        if let temp = template {
            name = temp.name
            HuaweiHelper.shared.getAttachParentControlList { arrAttachPC in
                let controlledDev = arrAttachPC.filter { $0.templateName == temp.name }.map { $0.mac }
                
                HuaweiHelper.shared.queryLanDeviceListEx { devices in
                    self.selectedDevices = devices.filter { !$0.isAp }.filter { controlledDev.contains($0.mac) }
                    self.updateDeviceList()
                }
            }
            
            profileTextView.text = temp.aliasName
            profileSeperator.isHidden = !isEdit
            deviceView.alpha = 1
            deviceView.isUserInteractionEnabled = isEdit
            deviceSeperator.isHidden = !isEdit
            
            clearPeriodStack()
            selectedPeriod.removeAll()
            
            for item in temp.controlList {
                if let control = item as? HwControlSegment {
                    var days: [kHwDayOfWeek] = []
                    
                    if control.repeatMode == kHwRepeatModeNone {
                        if let period = SelectPeriod(with: [
                            "index": selectedPeriod.count,
                            "startTime": control.startTime,
                            "endTime": control.endTime,
                            "repeatMode": control.repeatMode
                        ]) {
                            selectedPeriod.append(period)
                        }
                    } else {
                        if let daysString = control.dayOfWeeks.allObjects as? [String] {
                            for day in daysString {
                                switch day {
                                case "1":
                                    days.append(kHwDayOfWeekMon)
                                case "2":
                                    days.append(kHwDayOfWeekTue)
                                case "3":
                                    days.append(kHwDayOfWeekWed)
                                case "4":
                                    days.append(kHwDayOfWeekTus)
                                case "5":
                                    days.append(kHwDayOfWeekFri)
                                case "6":
                                    days.append(kHwDayOfWeekSat)
                                case "7":
                                    days.append(kHwDayOfWeekSun)
                                default:
                                    return
                                }
                            }
                        }
                        
                        if let period = SelectPeriod(with: [
                            "index": selectedPeriod.count,
                            "startTime": control.startTime,
                            "endTime": control.endTime,
                            "dayOfWeeks": days,
                            "repeatMode": control.repeatMode
                        ]) {
                            selectedPeriod.append(period)
                        }
                    }
                }
            }
            
            addPeriodStack(isEdit: isEdit)
            
            if !selectedPeriod.isEmpty {
                selectPeriodView.isHidden = true
                periodTextView.alwaysShowFloatingLabel = true
            }
            
            periodView.alpha = 1
            periodView.isUserInteractionEnabled = isEdit
            
            clearBlockWebsite()
            
            if let arrUrl = temp.urlFilterList as? [String] {
                for url in arrUrl {
                    let blockWebsiteView = BlockWebsiteView(text: url, isEdit: isEdit)
                    blockWebsiteView.delegate = self
                    blockWebsiteStack.addArrangedSubview(blockWebsiteView)
                }
                
                if !arrUrl.isEmpty {
                    blockWebsiteTextView.alwaysShowFloatingLabel = true
                } else {
                    let blockWebsiteView = BlockWebsiteView(allowRemove: false, isPrimary: true, isEdit: isEdit)
                    blockWebsiteView.delegate = self
                    blockWebsiteStack.addArrangedSubview(blockWebsiteView)
                }
                
                if isEdit {
                    addTimeView.isHidden = selectedPeriod.isEmpty ? true : false
                    addWebsiteView.isHidden = arrUrl.isEmpty ? true : false
                }
            }
            
            if isEdit {
                addTimeView.isHidden = selectedPeriod.isEmpty ? true : false
            }
            
            blockWebsiteView.alpha = 1
            blockWebsiteView.isUserInteractionEnabled = isEdit
        }
    }
    
    func clearPeriodStack() {
        for pView in selectPeriodStack.arrangedSubviews {
            if let periodView = pView as? PeriodView {
                selectPeriodStack.removeArrangedSubview(periodView)
                periodView.removeFromSuperview()
            }
        }
    }
    
    func addPeriodStack(isEdit: Bool) {
        for period in selectedPeriod {
            let periodView = PeriodView(period: period, isEdit: isEdit)
            periodView.delegate = self
            selectPeriodStack.addArrangedSubview(periodView)
        }
    }
    
    func clearBlockWebsite() {
        for item in blockWebsiteStack.arrangedSubviews {
            if let view = item as? BlockWebsiteView {
                blockWebsiteStack.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
    }
    
    func insertBlockWebsiteInput(allowRemove: Bool, isPrimary: Bool, isEdit: Bool) {
        let blockWebsiteView = BlockWebsiteView(allowRemove: allowRemove, isPrimary: isPrimary, isEdit: isEdit)
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
    
    func checkConfirmButton() {
        if isEdit || template == nil {
            if selectedDevices.isEmpty || selectedPeriod.isEmpty || profileTextView.text == "" {
                self.createProfile.backgroundColor = UIColor(hex: "C6C6C6")
                self.createProfile.isUserInteractionEnabled = false
            } else {
                self.createProfile.backgroundColor = .primary
                self.createProfile.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func actDeviceSelect(_ sender: Any) {
        if let devicesVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCDevicesViewController") as? PCDevicesViewController {
            devicesVC.delegate = self
            if self.template != nil {
                devicesVC.template = self.template
            }
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
        insertBlockWebsiteInput(allowRemove: true, isPrimary: false, isEdit: true)
    }
    
    @IBAction func actCreateProfile(_ sender: Any) {
        save()
    }
    
    @objc
    func save() {
        
        if profileTextView.text == "" {
            self.showAlertMessage(title: "Error", message: "Please fill in profile name", dismissTitle: "Ok")
            return
        } else if selectedPeriod.isEmpty {
            self.showAlertMessage(title: "Error", message: "Please select access period", dismissTitle: "Ok")
            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Loading...", comment: "")
        
        HuaweiHelper.shared.getAttachParentalControlTemplateList(completion: { tplList in
            let names = tplList.filter { $0.name != self.template?.name }.map { $0.name }
            
            if let arrNames = names as? [String] {
                HuaweiHelper.shared.getParentControlTemplateDetailList(templateNames: arrNames, completion: { arrData in
                    
                    hud.hide(animated: true)
                    let arrName = arrData.map { $0.aliasName }
                    if arrName.contains(where: { $0 == self.profileTextView.text }) {
                        hud.hide(animated: true)
                        self.showAlertMessage(title: "Error", message: "Existing profile name", dismissTitle: "Ok")
                        return
                    } else {
                        let template = HwAttachParentControlTemplate()
                        template.name = self.name
                        template.aliasName = self.profileTextView.text
                        template.enable = true
                        
                        let controlList: NSMutableArray? = []
                        
                        for period in self.selectedPeriod {
                            let controlSegment = HwControlSegment()
                            controlSegment.enable = true
                            controlSegment.repeatMode = period.repeatMode ?? kHwRepeatModeNone
                            controlSegment.startTime = period.startTime
                            controlSegment.endTime = period.endTime
                            if let days = period.dayOfWeeks {
                                let periods = NSMutableSet(array: days.map { $0.rawValue })
                                controlSegment.dayOfWeeks = periods
                            }
                            controlList?.add(controlSegment)
                        }
                        
                        template.controlList = controlList
                        
                        var urlList: [String] = []
                        
                        for list in self.blockWebsiteStack.arrangedSubviews {
                            if let blockView = list as? BlockWebsiteView {
                                if let url = blockView.textField.text {
                                    if url != "" {
                                        urlList.append(url)
                                    }
                                }
                            }
                        }
                        
                        if !urlList.isEmpty {
                            template.urlFilterEnable = false
                            template.urlFilterList = NSMutableArray(array: urlList)
                        }
                        
                        HuaweiHelper.shared.setAttachParentControlTemplate(ctrlTemplate: template, completion: { _ in
                            let group = DispatchGroup()
                            for device in self.selectedDevices {
                                group.enter()
                                let attachPC = HwAttachParentControl()
                                attachPC.mac = device.mac
                                attachPC.templateName = self.name
                                HuaweiHelper.shared.setAttachParentControl(attachParentCtrl: attachPC) { _ in
                                    group.leave()
                                }
                            }
                            
                            group.notify(queue: .main) {
                                hud.hide(animated: true)
                                self.popBack()
                            }
                        }) { exception in
                            hud.hide(animated: true)
                            self.showAlertMessage(message: exception?.description ?? "")
                        }
                    }
                    
                }) { exception in
                    hud.hide(animated: true)
                    self.showAlertMessage(message: exception?.description ?? "")
                }
            }
        }) { exception in
            hud.hide(animated: true)
            self.showAlertMessage(message: exception?.description ?? "")
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
        addWebsiteView.isHidden = false
    }
    
    func didEditChange(textField: UITextField) {
        blockWebsiteTextView.text = textField.text
    }
    
    func delete(view: UIView) {
        blockWebsiteStack.removeArrangedSubview(view)
        view.removeFromSuperview()
        
        if !blockWebsiteStack.arrangedSubviews.contains(where: { $0 is BlockWebsiteView }) {
            insertBlockWebsiteInput(allowRemove:false, isPrimary: true, isEdit: true)
            addWebsiteView.isHidden = true
            blockWebsiteTextView.text = ""
            blockWebsiteTextView.alwaysShowFloatingLabel = false
        }
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
            checkConfirmButton()
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
            if !periodView.isUserInteractionEnabled && isEdit {
                UIView.animate(withDuration: 0.5) {
                    self.periodView.isUserInteractionEnabled = true
                    self.periodView.alpha = 1
                }
            }
            
            selectDeviceView.isHidden = true
            deviceTextView.alwaysShowFloatingLabel = true
            for device in selectedDevices {
                let deviceView = DeviceView(device: device, isEdit: template != nil ? isEdit : true)
                deviceView.delegate = self
                selectDeviceStack.addArrangedSubview(deviceView)
            }
        }
        
        checkConfirmButton()
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
            checkConfirmButton()
        }
    }
    
    func showDevices() {
        if let devicesVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCDevicesViewController") as? PCDevicesViewController {
            devicesVC.delegate = self
            devicesVC.selectedDevices = selectedDevices
            if self.template != nil {
                devicesVC.template = self.template
            }
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
        
        clearPeriodStack()
        
        for period in selectedPeriod {
            let periodView = PeriodView(period: period, isEdit: true)
            periodView.delegate = self
            selectPeriodStack.addArrangedSubview(periodView)
        }
        
        if !blockWebsiteView.isUserInteractionEnabled {
            UIView.animate(withDuration: 0.5) {
                self.blockWebsiteView.isUserInteractionEnabled = true
                self.blockWebsiteView.alpha = 1
            }
        }
        
        periodTextView.alwaysShowFloatingLabel = true
        selectPeriodView.isHidden = true
        addTimeView.isHidden = false
        checkConfirmButton()
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
            
            checkConfirmButton()
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
