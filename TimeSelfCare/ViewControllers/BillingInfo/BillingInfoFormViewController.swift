//
//  EditBillingInfoViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 02/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import EasyTipView

protocol BillingInfoFormComponentViewDelegate: class {
    func billingInfoFormComponentView(_ billingInfoFormComponentView: BillingInfoFormComponentView, didUpdateBillingMethod billingMethodString: String)
    func billingInfoFormComponentView(didEdit billingInfoFormComponentView: BillingInfoFormComponentView)
}

class BillingInfoFormComponentView: UIStackView, UITextViewDelegate, CustomPickerViewDelegate {
    var rulesMapping: [((_ text: String) -> Bool, errorMessage: String)] = []
    
    var rightImage: UIImage? {
        didSet {
            self.rightImageView.setImage(rightImage, for: .normal)
            self.rightImageView.isHidden = rightImage == nil
        }
    }

    weak var billingInfo: BillingInfo?
    weak var delegate: BillingInfoFormComponentViewDelegate?

    var billingInfoComponent: BillingInfoFormViewController.BillingInfoFormComponent! { // swiftlint:disable:this implicitly_unwrapped_optional
        didSet {
            self.textView.placeholder = billingInfoComponent.title

            if billingInfoComponent == .billingMethod || billingInfoComponent == .addressState {
                let methods: [String] = billingInfo?.billingMethodOptions.keys.sorted().compactMap { billingInfo?.billingMethodOptions[$0] } ?? []
                let customPickerView = CustomPickerView(dataArray: billingInfoComponent == .billingMethod ? methods : BillingInfo.states)

                if billingInfoComponent == .billingMethod, let index = methods.index(where: { $0 == billingInfo?.billingMethodString }) {
                    customPickerView.selectRow(index, inComponent: 0, animated: false)
                } else if billingInfoComponent == .addressState, let index = BillingInfo.states.index(where: { $0 == billingInfo?.billState }) {
                    customPickerView.selectRow(index, inComponent: 0, animated: false)
                }

                customPickerView.delegate = self
                self.textView.inputView = customPickerView
                self.textView.showCursor = false
            } else if billingInfoComponent == .addressZip {
                self.textView.keyboardType = .numberPad

                let toolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                toolBar.backgroundColor = UIColor.white
                let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneButton: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: textView, action: #selector(textView.resignFirstResponder))
                doneButton.tintColor = textView.tintColor

                toolBar.items = [flexibleSpace, doneButton]
                toolBar.sizeToFit()
                textView.inputAccessoryView = toolBar
            }

            if self.billingInfoComponent == .billingMethod {
                guard let strBillingMethod = self.billingInfo?.billingMethodString  else { return }
                if !strBillingMethod.contains("Online"){
                    self.infoButton.isHidden = !self.isEditable && !(self.billingInfo?.canUpdateBillingMethod ?? false)
                }
            } else
                if self.billingInfoComponent == .emailAddress {
                self.infoButton.isHidden = !self.isEditable && !(self.billingInfo?.canUpdateBillingAddress ?? false)
            }
        }
    }

    var text: String? {
        set {
            self.textView.text = self.billingInfoComponent.isAddress ? newValue?.uppercased() : newValue
        }
        get {
            return self.textView.text
        }
    }

    var isEditable: Bool = true {
        didSet {
            self.textView.isUserInteractionEnabled = isEditable
            self.textView.isEditable = isEditable
            self.textView.textColor = isEditable ? .black : .grey

            if self.billingInfoComponent == .billingMethod {
                guard let strBillingMethod = self.billingInfo?.billingMethodString  else { return }
                if !strBillingMethod.contains("Online"){
                    self.infoButton.isHidden = !self.isEditable && !(self.billingInfo?.canUpdateBillingMethod ?? false)
                }
            } else
                if self.billingInfoComponent == .emailAddress {
                self.infoButton.isHidden = !self.isEditable && !(self.billingInfo?.canUpdateBillingAddress ?? false)
            }
        }
    }

    var isTextValid: Bool {
        let rules = self.rulesMapping.map { $0.0 }
        return rules.reduce(true) { $0 && $1(self.textView.text ?? "") }
    }

    private var tooltip: EasyTipView?

    // swiftlint:disable implicitly_unwrapped_optional
    private weak var textView: FloatLabeledTextView!
    private weak var errorLabel: UILabel!
    private weak var dividerView: UIView!
    private weak var infoButton: UIButton!
    private weak var rightImageView: UIButton!
    // swiftlint:enable implicitly_unwrapped_optional

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill

        let textView = FloatLabeledTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
        textView.tintColor = .primary
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.textColor = .black
        textView.floatingLabelTextColor = .black
        textView.delegate = self
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false

        let infoButton = UIButton()
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.setImage(#imageLiteral(resourceName: "ic_info_circled"), for: .normal)
        infoButton.addTarget(self, action: #selector(self.showInfo(sender:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            infoButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        infoButton.setContentHuggingPriority(UILayoutPriority(1_000), for: .horizontal)
        infoButton.isHidden = true
        
        let rightImageView: UIButton = UIButton()
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        rightImageView.setContentHuggingPriority(UILayoutPriority(1_000), for: .horizontal)
        rightImageView.isHidden = true
        rightImageView.addTarget(self, action: #selector(self.handleButtonTap), for: .touchUpInside)

        let dividerView = UIView()
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.backgroundColor = .black

        let errorLabel = UILabel()
        errorLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        errorLabel.textColor = .error
        errorLabel.preferredMaxLayoutWidth = self.bounds.width
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        let innerStackView = UIStackView()
        innerStackView.axis = .horizontal
        innerStackView.distribution = .fill
        innerStackView.alignment = .fill

        innerStackView.addArrangedSubview(textView)
        innerStackView.addArrangedSubview(infoButton)
        innerStackView.addArrangedSubview(rightImageView)

        self.addArrangedSubview(innerStackView)
        self.addArrangedSubview(dividerView)
        self.addArrangedSubview(errorLabel)

        self.errorLabel = errorLabel
        self.textView = textView
        self.dividerView = dividerView
        self.infoButton = infoButton
        self.rightImageView = rightImageView

        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func validate() {
        for (rule, errorMessage) in self.rulesMapping {
            if !rule(self.textView.text ?? "") {
                self.errorLabel.isHidden = false
                self.errorLabel.text = errorMessage
                self.dividerView.backgroundColor = .error
                break
            }
        }
    }

    @objc
    private func showInfo(sender: UIButton) {
        if self.tooltip != nil {
            self.tooltip?.dismiss(gesture: nil)
            self.tooltip = nil
            return
        }

        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.getCustomFont(family: "DIN", style: .caption1) ?? UIFont.preferredFont(forTextStyle: .caption1),
                                                        NSAttributedString.Key.foregroundColor: UIColor.white]
        let message: String = {
            guard let billingInfoComponent = self.billingInfoComponent else {
                return NSLocalizedString("Show text here", comment: "")
            }

            switch billingInfoComponent {
            case .billingMethod:
                return NSLocalizedString("Changes to your billing method will only be effective starting from next billing cycle", comment: "")
            case .emailAddress:
                return NSLocalizedString("To include multiple email addresses, separate them with a comma. E.g. joe@gmail.com, jen@gmail.com", comment: "")
            default:
                return NSLocalizedString("Show text here", comment: "")
            }
        }()

        let attributedString = NSAttributedString(string: message, attributes: attributes)
        var preferences = EasyTipView.Preferences()
        preferences.drawing.backgroundColor = UIColor.black
        preferences.positioning.maxWidth = self.bounds.width
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.top
        let tooltip = EasyTipView(text: attributedString, preferences: preferences, delegate: nil)
        self.tooltip?.dismiss(gesture: nil)
        self.tooltip = tooltip
        self.tooltip?.show(animated: true, forView: sender, withinSuperview: self.superview)
    }
    
@objc
    private func handleButtonTap() {
        self.textView.becomeFirstResponder()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.dividerView.backgroundColor = .primary
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.dividerView.backgroundColor = self.isTextValid ? .black : .error
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard self.billingInfoComponent.isAddress else {
            return true
        }

        guard text != "" else {
            textView.deleteBackward()
            return false
        }

        let componentCharactersLimit: [BillingInfoFormViewController.BillingInfoFormComponent: Int] = [
            .addressZip: 5,
            .block: 15,
            .level: 7,
            .unit: 8,
            .building: 35
        ]
        let componentAllowedCharacters: [BillingInfoFormViewController.BillingInfoFormComponent: (String) -> Bool] = [
            .block: { $0.isAlphanumeric },
            .level: { $0.isAlphanumeric },
            .building: { !$0.isEmpty && $0.range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil }
        ]

        if (textView.text.count < componentCharactersLimit[self.billingInfoComponent] ?? Int.max) &&
            (componentAllowedCharacters[self.billingInfoComponent]?(text) ?? true) {
            textView.insertText(text.uppercased())
        }

        return false
    }

    func textViewDidChange(_ textView: UITextView) {
        self.errorLabel.isHidden = true
        self.dividerView.backgroundColor = .primary
        self.validate()
        delegate?.billingInfoFormComponentView(didEdit: self)
    }

    func pickerView(pickerView: CustomPickerView, didConfirmSelectionOfRowWithTitle title: [String]) {
        self.textView.resignFirstResponder()
        self.text = title.first ?? ""
        delegate?.billingInfoFormComponentView(self, didUpdateBillingMethod: title.first ?? "")
    }

    func pickerView(pickerView: CustomPickerView, didSelectRowWithTitle title: [String]) {}

    func pickerViewDidCancel(pickerView: CustomPickerView) {
        self.textView.resignFirstResponder()
    }
}

class BillingInfoFormViewController: UIViewController {
    enum BillingInfoFormComponent {
        case deposit, billingMethod, billingCycle, emailAddress, block, level, unit, building, addressLine2, addressLine3, addressZip, addressCity, addressState, addressCountry

        static let allValues: [BillingInfoFormComponent] = [.deposit, .billingMethod, .billingCycle, .emailAddress, .block, .level, .unit, .building, .addressLine2, .addressLine3, .addressZip, .addressCity, .addressState, .addressCountry]

        var title: String {
            switch self {
            case .deposit:
                return NSLocalizedString("Deposit", comment: "")
            case .billingMethod:
                return NSLocalizedString("Billing Method", comment: "")
            case .billingCycle:
                return NSLocalizedString("Billing Cycle", comment: "")
            case .emailAddress:
                return NSLocalizedString("Billing Email Address *", comment: "")
            case .block:
                return NSLocalizedString("Block (e.g. A)", comment: "")
            case .level:
                return NSLocalizedString("Level (e.g. 12)", comment: "")
            case .unit:
                return NSLocalizedString("Unit * (e.g. 11)", comment: "")
            case .building:
                return NSLocalizedString("Building", comment: "")
            case .addressLine2:
                return NSLocalizedString("Address (Line 2)", comment: "")
            case .addressLine3:
                return NSLocalizedString("Address (Line 3)", comment: "")
            case .addressZip:
                return NSLocalizedString("Postcode *", comment: "")
            case .addressCity:
                return NSLocalizedString("City *", comment: "")
            case .addressState:
                return NSLocalizedString("State *", comment: "")
            case .addressCountry:
                return NSLocalizedString("Country", comment: "")
            }
        }

        var rightImage: UIImage? {
            switch self {
            case .addressState:
                return #imageLiteral(resourceName: "ic_expand_magenta")
            default:
                return nil
            }
        }
        
        var isEditable: Bool {
            return ![.deposit, .billingCycle, .addressCountry].contains(self)
        }

        var isAddress: Bool {
            return [.block, .level, .unit, .building, .addressLine2, .addressLine3, .addressZip, .addressCity, .addressState, .addressCountry].contains(self)
        }

        var isAddressAndHalfWidth: Bool {
            return [.block, .level, .unit, .building, .addressZip, .addressCity, .addressState, .addressCountry].contains(self)
        }
    }

    // swiftlint:disable implicitly_unwrapped_optional
    var billingInfo: BillingInfo!

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackViewContainer: UIStackView!
    private weak var addressStackView: UIStackView!
    private weak var saveButton: UIButton!
    // swiftlint:enable implicitly_unwrapped_optional

    private var billingInfoComponentViews: [BillingInfoFormComponentView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()

        Keyboard.addKeyboardChangeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.populateUI(with: self.billingInfo)
    }

    private func setupUI() {
        self.navigationItem.title = NSLocalizedString("Billing Info", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.dismissVC(_:)))

        let addressStackView = UIStackView()
        addressStackView.axis = .vertical
        addressStackView.distribution = .fill
        addressStackView.spacing = 5
        let label = UILabel()
        label.text = NSLocalizedString("Billing Address", comment: "")
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        addressStackView.addArrangedSubview(label)
        self.addressStackView = addressStackView

        BillingInfoFormComponent.allValues.forEach {
            let billingInfoFormComponentView = BillingInfoFormComponentView()
            billingInfoFormComponentView.billingInfo = self.billingInfo
            billingInfoFormComponentView.billingInfoComponent = $0
            billingInfoFormComponentView.isEditable = $0.isEditable
            billingInfoFormComponentView.rightImage = $0.rightImage

            billingInfoFormComponentView.delegate = self
            self.billingInfoComponentViews.append(billingInfoFormComponentView)

            if $0.isAddressAndHalfWidth {
                if let stackView = addressStackView.arrangedSubviews.last as? UIStackView,
                    stackView.arrangedSubviews.count < 2 {
                    stackView.addArrangedSubview(billingInfoFormComponentView)
                } else {
                    let stackView = UIStackView()
                    stackView.axis = .horizontal
                    stackView.distribution = .fillEqually
                    stackView.alignment = .top
                    stackView.spacing = 4
                    stackView.addArrangedSubview(billingInfoFormComponentView)
                    addressStackView.addArrangedSubview(stackView)
                }
            } else if $0.isAddress {
                addressStackView.addArrangedSubview(billingInfoFormComponentView)
            } else {
                self.stackViewContainer.addArrangedSubview(billingInfoFormComponentView)
            }

            // Hard coded business rule
            if $0 == .emailAddress || $0.isAddress && $0 != .addressCountry {
                billingInfoFormComponentView.isEditable = self.billingInfo.canUpdateBillingAddress ?? false
            }
            else if $0 == .billingMethod {
                billingInfoFormComponentView.isEditable = self.billingInfo.canUpdateBillingMethod ?? false
            }
        }
        self.stackViewContainer.addArrangedSubview(addressStackView)

        let requiredLabel = UILabel()
        requiredLabel.text = NSLocalizedString("* Required", comment: "")
        requiredLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        requiredLabel.textColor = .grey
        self.stackViewContainer.addArrangedSubview(requiredLabel)

        let emptyAreaView = UIView()
        emptyAreaView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.stackViewContainer.addArrangedSubview(emptyAreaView)

        let saveButtonContainerView = UIStackView()
        saveButtonContainerView.axis = .vertical
        saveButtonContainerView.alignment = .center
        saveButtonContainerView.distribution = .fill

        let saveButton = UIButton()
        saveButton.isEnabled = false
        saveButton.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)
        saveButton.addTarget(self, action: #selector(self.submitBillingInfo(sender:)), for: .touchUpInside)
        saveButton.backgroundColor = .grey
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.saveButton = saveButton
        saveButtonContainerView.addArrangedSubview(saveButton)

        self.stackViewContainer.addArrangedSubview(saveButtonContainerView)
    }

    private func populateUI(with billingInfo: BillingInfo) {
        for componentView in self.billingInfoComponentViews {
            guard let billingInfoComponent = componentView.billingInfoComponent else { return }

            switch billingInfoComponent {
            case .deposit:
                componentView.text = billingInfo.deposit
            case .billingMethod:
                componentView.text = billingInfo.billingMethodString
            case .billingCycle:
                componentView.text = billingInfo.billingCycle
            case .emailAddress:
                componentView.text = billingInfo.billingEmailAddress
            case .block:
                componentView.text = billingInfo.block
            case .level:
                componentView.text = billingInfo.level
            case .unit:
                componentView.text = billingInfo.unit
            case .building:
                componentView.text = billingInfo.building
            case .addressLine2:
                componentView.text = billingInfo.billAddress2
            case .addressLine3:
                componentView.text = billingInfo.billAddress3
            case .addressZip:
                componentView.text = billingInfo.billZip
            case .addressCity:
                componentView.text = billingInfo.billCity
            case .addressState:
                componentView.text = billingInfo.billState
            case .addressCountry:
                componentView.text = billingInfo.billCountry
            }
        }
        self.updateUI()
    }

    private func updateUI() {
        let billingMethodView = self.billingInfoComponentViews.first { $0.billingInfoComponent == .billingMethod }
        let billingMethodString = billingMethodView?.text ?? ""

        // Hard coded business rules
        let emailAddressComponentView = self.billingInfoComponentViews.first { $0.billingInfoComponent == .emailAddress }
        billingMethodView?.isEditable = !billingMethodString.contains("Online")
        
        if billingMethodString.contains("Online") {
            let cancelAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: nil)
            self.showAlertMessage(title: NSLocalizedString("Update Billing Address", comment: ""), message: NSLocalizedString("As your current billing method is via Online Bill, you're not allowed to update billing address here. However, you may do so by using selfcare portal", comment: ""), actions: [cancelAction])
            return
        }
        
        emailAddressComponentView?.isHidden = !billingMethodString.contains("Online")

        emailAddressComponentView?.rulesMapping = !(emailAddressComponentView?.isHidden ?? true) ?
            [
                ({ !$0.isEmpty }, NSLocalizedString("Field is required.", comment: "")),
                ({ (text: String) -> Bool in
                    let emails: [String] = text.components(separatedBy: ",")

                    return
                        emails.reduce(true) { (previousResult: Bool, email: String) -> Bool in
                            return previousResult && email.trimmingCharacters(in: .whitespaces).isEmail
                        }
                }, NSLocalizedString("Invalid email address.", comment: ""))
            ] :
            []

        // self.addressStackView.isHidden = !billingMethodString.contains("Paper")
        let addressComponentViews = self.billingInfoComponentViews.filter {
            $0.billingInfoComponent.isAddress &&
            $0.billingInfoComponent != .addressLine3 &&
            $0.billingInfoComponent != .addressLine2 &&
            $0.billingInfoComponent != .block &&
            $0.billingInfoComponent != .level &&
            $0.billingInfoComponent != .building
        }
        for componentView in addressComponentViews {
            var rulesMapping: [((_ text: String) -> Bool, errorMessage: String)] = [
                ({ !$0.isEmpty }, NSLocalizedString("Field is required.", comment: ""))
            ]

            if componentView.billingInfoComponent == .addressZip {
                rulesMapping.append(({ $0.count == 5 }, NSLocalizedString("Must be 5 digits.", comment: "")))
            } else if componentView.billingInfoComponent == .unit {
                rulesMapping.append(({ $0.isEmpty || $0.range(of: "[^a-zA-Z0-9/-]", options: .regularExpression) == nil }, NSLocalizedString("Must contain alphanumeric, '-' and '/' characters only.", comment: "")))
            }

            componentView.rulesMapping = !addressStackView.isHidden ? rulesMapping : []
        }
    }

    private func updateSaveButton() {
        guard let billingMethodString = self.billingInfo.billingMethodString else { return }
        if !billingMethodString.contains("Online") {
            self.saveButton.isEnabled = self.billingInfoComponentViews.reduce(true) { $0 && $1.isTextValid }
            self.saveButton.backgroundColor = self.saveButton.isEnabled ? .primary : .grey
        }
    }

    private func populateData() {
        self.billingInfoComponentViews.forEach {
            guard let billingInfoComponent = $0.billingInfoComponent else {
                return
            }

            switch billingInfoComponent {
            case .billingMethod:
                if self.billingInfo.canUpdateBillingMethod ?? false {
                    billingInfo.billingMethodString = $0.text
                }
            case .emailAddress:
                billingInfo.billingEmailAddress = $0.text
            case .block:
                billingInfo.block = $0.text
            case .level:
                billingInfo.level = $0.text
            case .unit:
                billingInfo.unit = $0.text
            case .building:
                billingInfo.building = $0.text
            case .addressLine2:
                billingInfo.billAddress2 = $0.text
            case .addressLine3:
                billingInfo.billAddress3 = $0.text
            case .addressZip:
                billingInfo.billZip = $0.text
            case .addressCity:
                billingInfo.billCity = $0.text
            case .addressState:
                billingInfo.billState = $0.text
            default:
                break
            }
        }
    }

    @IBAction func submitBillingInfo(sender: Any?) {
        self.billingInfoComponentViews.forEach { $0.validate() }

        guard self.billingInfoComponentViews.reduce(true, { $0 && $1.isTextValid }) else {
            return
        }

        self.populateData()

        let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = NSLocalizedString("Updating...", comment: "")

            BillingInfoDataController.shared.updateBillingInfo(billingInfo: self.billingInfo) { _, error in
                hud.hide(animated: true)
                if let error = error {
                    self.showAlertMessage(with: error)
                    return
                }
                let confirmationVC: ConfirmationViewController = UIStoryboard(name: "Common", bundle: nil).instantiateViewController()
                confirmationVC.mode = .infoUpdated
                confirmationVC.actionBlock = {
                    self.dismissVC()
                }
                confirmationVC.modalPresentationStyle = .fullScreen
                self.present(confirmationVC, animated: true, completion: nil)
            }
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        self.showAlertMessage(title: NSLocalizedString("Change Confirmation", comment: ""), message: NSLocalizedString("Are you sure you want to proceed?", comment: ""), actions: [cancelAction, okAction])

    }
}

extension BillingInfoFormViewController: BillingInfoFormComponentViewDelegate {
    func billingInfoFormComponentView(didEdit billingInfoFormComponentView: BillingInfoFormComponentView) {
        self.updateSaveButton()
    }

    func billingInfoFormComponentView(_ billingInfoFormComponentView: BillingInfoFormComponentView, didUpdateBillingMethod billingMethodString: String) {
        self.updateSaveButton()
    }
}

extension BillingInfoFormViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight, right: 0)
    }
}
