//
//  TicketFormViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 19/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import TimeSelfCareData

protocol TicketFormComponentViewDelegate: class {
    func componentView(didEdit ticketFormComponentView: TicketFormComponentView)
    func componentView(didBeginEdit ticketFormComponentView: TicketFormComponentView)
}

class TicketFormComponentView: UIStackView, UITextViewDelegate, CustomPickerViewDelegate {
    var rulesMapping: [((_ text: String) -> Bool, errorMessage: String)] = []
    var rightImage: UIImage? {
        didSet {
            self.rightImageView.setImage(rightImage, for: .normal)
            self.rightImageView.isHidden = rightImage == nil
        }
    }

    var placeholder: String? {
        didSet {
            self.textView.placeholder = placeholder
        }
    }

    var customInputView: UIView? {
        didSet {
            self.textView.inputView = customInputView
            self.textView.showCursor = false
        }
    }

    var text: String {
        return self.textView.text
    }

    weak var delegate: TicketFormComponentViewDelegate?

    var isTextValid: Bool {
        let rules = self.rulesMapping.map { $0.0 }
        return rules.reduce(true) { $0 && $1(self.textView.text ?? "") }
    }

    // swiftlint:disable implicitly_unwrapped_optional
    private weak var textView: FloatLabeledTextView!
    private weak var errorLabel: UILabel!
    private weak var dividerView: UIView!
    private weak var rightImageView: UIButton!
    // swiftlint:enable implicitly_unwrapped_optional

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 0

        let textView = FloatLabeledTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56).isActive = true
        textView.tintColor = .primary
        textView.font = UIFont.preferredFont(forTextStyle: .title3)
        textView.textColor = .black
        textView.floatingLabelTextColor = .grey
        textView.delegate = self
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.returnKeyType = .next

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
        dividerView.backgroundColor = .grey2

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
        innerStackView.addArrangedSubview(rightImageView)

        self.addArrangedSubview(innerStackView)
        self.addArrangedSubview(dividerView)
        self.addArrangedSubview(errorLabel)

        self.errorLabel = errorLabel
        self.textView = textView
        self.dividerView = dividerView
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

    func textViewDidChange(_ textView: UITextView) {
        self.errorLabel.isHidden = true
        self.dividerView.backgroundColor = .grey2
        self.validate()

        delegate?.componentView(didEdit: self)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.componentView(didBeginEdit: self)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.validate()
    }

    func pickerView(pickerView: CustomPickerView, didConfirmSelectionOfRowWithTitle title: [String]) {
        self.textView.text = title.first ?? ""
        self.textView.resignFirstResponder()
        self.textViewDidChange(self.textView)
    }

    func pickerViewDidCancel(pickerView: CustomPickerView) {
        self.textView.resignFirstResponder()
    }

    func pickerView(pickerView: CustomPickerView, didSelectRowWithTitle title: [String]) {
    }

    @objc
    private func handleButtonTap() {
        self.textView.becomeFirstResponder()
    }
}

class TicketFormViewController: TimeBaseViewController {
    enum TicketFormComponent: Int {
        case category = 0, title, message

        var title: String {
            switch self {
            case .category:
                return NSLocalizedString("I need help with", comment: "")
            case .title:
                return NSLocalizedString("Subject", comment: "")
            case .message:
                return NSLocalizedString("Message", comment: "")
            }
        }

        var rightImage: UIImage? {
            switch self {
            case .category:
                return #imageLiteral(resourceName: "ic_expand_magenta")
            default:
                return nil
            }
        }

        var rulesMapping: [((_ text: String) -> Bool, errorMessage: String)] {
            let requiredRule: ((_ text: String) -> Bool, errorMessage: String) = ({ !$0.isEmpty }, NSLocalizedString("Field is required.", comment: ""))
            switch self {
            case .category, .title, .message:
                return [
                    requiredRule
                ]
            }
        }

        static let allValues: [TicketFormComponent] = [.category, .title, .message]
    }

    private let itemPerRows: CGFloat = 3
    private let stackViewContainerTotalHorizontalMargin: CGFloat = 40

    private var selectedImageInfo: [[String: Any]] = [] {
        didSet {
            let itemWidth = (self.containerStackView.bounds.width - stackViewContainerTotalHorizontalMargin) / itemPerRows

            self.attachmentCollectionViewHeightConstraint?.constant = itemWidth * ceil(CGFloat(self.selectedImageInfo.count + 1) / itemPerRows)
        }
    }

    // swiftlint:disable implicitly_unwrapped_optional
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerStackView: UIStackView!
    private weak var submitButton: UIButton!
    private weak var attachmentCollectionView: UICollectionView!
    private weak var attachmentCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imagePickerContainerView: UIView!
    @IBOutlet private weak var imagePickerContainerViewBottomConstraint: NSLayoutConstraint!
    // swiftlint:enable implicitly_unwrapped_optional

    private var componentViews: [TicketFormComponentView] = []

    private lazy var _imagePickerVC: TimeImagePickerViewController = {
        let imagePickerVC: TimeImagePickerViewController = TimeImagePickerViewController.imagePicker(allowMultipleSelection: true) as! TimeImagePickerViewController // swiftlint:disable:this force_cast

        self.addChild(imagePickerVC)
        self.imagePickerContainerView.addSubview(imagePickerVC.view)
        imagePickerVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePickerVC.view.bottomAnchor.constraint(equalTo: self.imagePickerContainerView.bottomAnchor),
            imagePickerVC.view.topAnchor.constraint(equalTo: self.imagePickerContainerView.topAnchor),
            imagePickerVC.view.leftAnchor.constraint(equalTo: self.imagePickerContainerView.leftAnchor),
            imagePickerVC.view.rightAnchor.constraint(equalTo: self.imagePickerContainerView.rightAnchor)
            ])
        imagePickerVC.imagePickerDelegate = self
        return imagePickerVC
    }()

    private var imagePickerVC: TimeImagePickerViewController?

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        Keyboard.addKeyboardChangeObserver(self)
    }

    private func setupUI() {
        self.title = NSLocalizedString("Create Ticket", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .done, target: self, action: #selector(self.dismissVC(_:)))

        for component in TicketFormComponent.allValues {
            let ticketFormComponentView = TicketFormComponentView()
            ticketFormComponentView.placeholder = component.title
            ticketFormComponentView.rightImage = component.rightImage
            ticketFormComponentView.rulesMapping = component.rulesMapping
            ticketFormComponentView.delegate = self

            if component == .category {
                let categories = TicketDataController.shared.categoryOptions.compactMap { $0.value }.sorted { previous, next -> Bool in
                    if previous.lowercased() == "others" {
                        return false
                    } else if next.lowercased() == "others" {
                        return true
                    }
                    return previous < next
                }
                let customPickerView = CustomPickerView(dataArray: categories)
                customPickerView.delegate = ticketFormComponentView
                ticketFormComponentView.customInputView = customPickerView
            }

            self.containerStackView.addArrangedSubview(ticketFormComponentView)

            self.componentViews.append(ticketFormComponentView)
        }

        let attachmentsLabel = UILabel()
        attachmentsLabel.text = NSLocalizedString("Attachments", comment: "")
        self.containerStackView.addArrangedSubview(attachmentsLabel)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(AttachmentCell.self, forCellWithReuseIdentifier: "AttachmentCell")
        collectionView.register(AddAttachmentCell.self, forCellWithReuseIdentifier: "AddAttachmentCell")
        self.containerStackView.addArrangedSubview(collectionView)
        self.attachmentCollectionView = collectionView

        let itemWidth = (self.containerStackView.bounds.width) / itemPerRows
        let collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: itemWidth)
        self.attachmentCollectionViewHeightConstraint = collectionViewHeightConstraint
        NSLayoutConstraint.activate([
            collectionViewHeightConstraint
            ])
        let emptyAreaView = UIView()
        emptyAreaView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.containerStackView.addArrangedSubview(emptyAreaView)

        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.isEnabled = false
        submitButton.setTitle(NSLocalizedString("SUBMIT", comment: ""), for: .normal)
        submitButton.addTarget(self, action: #selector(self.createTicket), for: .touchUpInside)
        submitButton.backgroundColor = .grey
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.widthAnchor.constraint(equalToConstant: 200)
            ])
        self.submitButton = submitButton

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubview(submitButton)
        self.containerStackView.addArrangedSubview(stackView)
    }

    @objc
    private func createTicket() {
        let ticket = Ticket(id: "")
        ticket.categoryOptions = TicketDataController.shared.categoryOptions
        for i in 0..<componentViews.count {
            guard let component = TicketFormComponent(rawValue: i) else {
                continue
            }

            switch component {
            case .category:
                ticket.displayCategory = componentViews[i].text
            case .title:
                ticket.subject = componentViews[i].text
            case .message:
                ticket.description = componentViews[i].text
            }
        }
        ticket.accountNo = AccountController.shared.selectedAccount?.accountNo

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = NSLocalizedString("Creating ticket...", comment: "")
        let images: [UIImage] = self.selectedImageInfo.compactMap {
            guard var image = $0[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
                return nil
            }

            let ratio = max(
                max(image.size.width, image.size.height) / 1_920,
                min(image.size.width, image.size.height) / 1_080
            )
            if ratio > 1 {
                image = image.scaledTo(scale: 1 / ratio)
            }
            return image
        }

        TicketDataController.shared.createTicket(ticket, account: AccountController.shared.selectedAccount, attachments: images) { _, error in
            hud.hide(animated: true)
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            let confirmationVC: ConfirmationViewController = UIStoryboard(name: TimeSelfCareStoryboard.common.filename, bundle: nil).instantiateViewController()
            confirmationVC.mode = .ticketSubmitted
            confirmationVC.actionBlock = {
                self.dismissVC()
            }
            self.present(confirmationVC, animated: true, completion: nil)
        }
    }
}

// MARK: CollectionView Related
extension TicketFormViewController: TicketFormComponentViewDelegate {
    func componentView(didBeginEdit ticketFormComponentView: TicketFormComponentView) {
        guard self.imagePickerContainerViewBottomConstraint.constant == 0 else {
            return
        }

        UIView.animate(withDuration: 0.3) {
            self.imagePickerContainerViewBottomConstraint.constant = -256
        }
    }

    func componentView(didEdit ticketFormComponentView: TicketFormComponentView) {
        self.submitButton.isEnabled = self.componentViews.reduce(true) { $0 && $1.isTextValid }
        self.submitButton.backgroundColor = self.submitButton.isEnabled ? .primary : .grey
    }
}

extension TicketFormViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AttachmentCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImageInfo.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  indexPath.item > 0,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as? AttachmentCell {
            cell.delegate = self
            cell.configureCell(with: self.selectedImageInfo[indexPath.item - 1])
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAttachmentCell", for: indexPath) as? AddAttachmentCell {
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / itemPerRows
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item == 0 else {
            return
        }
        self.requestForPhotoPermission(reason: NSLocalizedString("Use photos from your Photo Library as attachments.", comment: "")) {
            DispatchQueue.main.async {
                self.view.endEditing(false)
                if self.imagePickerVC == nil {
                    self.imagePickerVC = self._imagePickerVC
                }
                UIView.animate(withDuration: 0.3) {
                    self.imagePickerContainerViewBottomConstraint.constant = 0
                }
            }
        }
    }

    func cell(_ cell: AttachmentCell, didRemove mediaInfo: [String : Any]) {
        guard let identifier = mediaInfo["localIdentifier"] as? String,
            let index = self.selectedImageInfo.index(where: { identifier == $0["localIdentifier"] as? String })
            else {
                return
        }
        self.selectedImageInfo.remove(at: index)
        self.attachmentCollectionView.performBatchUpdates({
            let indexPath = IndexPath(item: index + 1, section: 0)
            self.attachmentCollectionView.deleteItems(at: [indexPath])
        }, completion: nil)
        self.imagePickerVC?.deselectItem(for: identifier)
    }
}

extension TicketFormViewController: ImagePickerControllerDelegate {
    func imagePickerDidCancel(imagePicker: ImagePickerViewController) {
    }

    func imagePicker(_ imagePicker: ImagePickerViewController, didSelectMediaWithInfo info: [String : Any]) {
        guard let _ = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            self.showAlertMessage(message: NSLocalizedString("Not able to select photo.", comment: ""))
            return
        }
        self.selectedImageInfo.append(info)

        self.attachmentCollectionView.performBatchUpdates({
            let newIndexPath = IndexPath(item: self.selectedImageInfo.count, section: 0)
            self.attachmentCollectionView.insertItems(at: [newIndexPath])
        }, completion: nil)
    }

    func imagePicker(_ imagePicker: ImagePickerViewController, didDeselectMediaWithInfo info: [String : Any]) {
        guard let identifier = info["localIdentifier"] as? String,
            let index = self.selectedImageInfo.index(where: { identifier == $0["localIdentifier"] as? String })  else {
                return
        }

        self.selectedImageInfo.remove(at: index)
        let indexPath = IndexPath(item: index + 1, section: 0)
        self.attachmentCollectionView.deleteItems(at: [indexPath])
    }
}

// MARK: KeyboardObserver
extension TicketFormViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endHeight + 16, right: 0)
    }
}
