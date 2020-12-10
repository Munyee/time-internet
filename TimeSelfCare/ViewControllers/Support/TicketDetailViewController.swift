//
//  TicketDetailViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 22/06/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import MBProgressHUD
import FirebaseCrashlytics

class TicketDetailViewController: UIViewController {
    var conversations: [Conversation] = [] {
        didSet {
            self.ticketAgentNameLabel.text = self.conversations.first { $0.fullname != AccountController.shared.selectedAccount?.profile?.fullname }?.fullname
            self.ticketAgentStackView.isHidden = self.ticketAgentNameLabel.text?.isEmpty ?? true
        }
    }
    private var selectedImageInfos: [[String: Any]] = [] {
        didSet {
            self.selectedImageCollectionView.isHidden = self.selectedImageInfos.isEmpty
        }
    }

    private lazy var _imagePickerVC: TimeImagePickerViewController = {
        let imagePickerVC: TimeImagePickerViewController = TimeImagePickerViewController.imagePicker(allowMultipleSelection: true) as! TimeImagePickerViewController // swiftlint:disable:this force_cast

        self.addChild(imagePickerVC)
        self.imageSelectionContainerView.addSubview(imagePickerVC.view)
        imagePickerVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePickerVC.view.bottomAnchor.constraint(equalTo: self.imageSelectionContainerView.bottomAnchor),
            imagePickerVC.view.topAnchor.constraint(equalTo: self.imageSelectionContainerView.topAnchor),
            imagePickerVC.view.leftAnchor.constraint(equalTo: self.imageSelectionContainerView.leftAnchor),
            imagePickerVC.view.rightAnchor.constraint(equalTo: self.imageSelectionContainerView.rightAnchor)
            ])
        imagePickerVC.imagePickerDelegate = self
        return imagePickerVC
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    private var isDetailsHidden: Bool = true {
        didSet {
            self.messagesStackView.isHidden = self.isDetailsHidden
            self.attachmentStackView.isHidden = self.isDetailsHidden || self.ticket.attachments.isEmpty
            self.showHideButton.setTitle(self.isDetailsHidden ? NSLocalizedString("Show Ticket Details", comment: "") : NSLocalizedString("Hide Ticket Details", comment: ""), for: .normal)
        }
    }
    private var imagePickerVC: TimeImagePickerViewController?

    // swiftlint:disable implicitly_unwrapped_optional
    var ticket: Ticket!
    @IBOutlet private weak var selectedImageCollectionView: UICollectionView!
    @IBOutlet private weak var tableView: TimeTableView!
    @IBOutlet private weak var inputStackView: UIStackView!
    @IBOutlet private weak var inputStackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var imageSelectionContainerView: UIView!

    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var headerStackView: UIStackView!
    @IBOutlet private weak var headerBasicStackView: UIStackView!
    @IBOutlet private weak var ticketAgentStackView: UIStackView!
    @IBOutlet private weak var messagesStackView: UIStackView!
    @IBOutlet private weak var attachmentStackView: UIStackView!
    @IBOutlet private weak var attachmentCollectionView: UICollectionView!
    @IBOutlet private weak var attachmentCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var detailButton: UIButton!
    @IBOutlet private weak var addAttachmentButton: UIButton!
    @IBOutlet private weak var showHideButton: UIButton!
    @IBOutlet private weak var ticketAgentNameLabel: UILabel!
    // swiftlint:enable implicitly_unwrapped_optional

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(RightConversationCell.self, forCellReuseIdentifier: "RightConversationCell")
        self.tableView.register(LeftConversationCell.self, forCellReuseIdentifier: "LeftConversationCell")
        self.tableView.register(ConversationAttachmentCell.self, forCellReuseIdentifier: "ConversationAttachmentCell")
        self.tableView.register(ConversationFooterView.self, forHeaderFooterViewReuseIdentifier: "ConversationFooterView")

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        self.textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 40)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorStyle = .none

        self.title = self.ticket.subject
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popViewController))
        Keyboard.addKeyboardChangeObserver(self)

        // configure headerview
        self.attachmentCollectionView.register(AttachmentCell.self, forCellWithReuseIdentifier: "AttachmentCell")
        self.attachmentCollectionView.dataSource = self
        self.attachmentCollectionView.delegate = self
        self.dateTimeLabel.text = ticket.displayDateTime
        self.titleLabel.text = ticket.subject
        self.detailLabel.text = ticket.detail
        self.statusLabel.text = ticket.statusString
        self.statusLabel.isHidden = ticket.statusString?.isEmpty ?? true
        
        if ["open"].contains(ticket.statusString?.lowercased()) {
            self.statusLabel.backgroundColor = .positive
        } else if ["closed"].contains(ticket.statusString?.lowercased()) {
            self.statusLabel.backgroundColor = .grey2
        } else {
            self.statusLabel.backgroundColor = .primary
        }
        
        self.messageLabel.attributedText = try? NSAttributedString(htmlString:ticket.description ?? "")
        self.attachmentCollectionViewHeightConstraint.constant = (self.attachmentCollectionView.bounds.width / 3)
        self.attachmentCollectionView.reloadData()

        self.tableView.addSubview(self.refreshControl)
        self.textView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }

    @objc
    private func refresh() {
        self.refreshControl.beginRefreshing()
        ConversationDataController.shared.loadConversations(ticket: self.ticket, account: AccountController.shared.selectedAccount) { (conversations: [Conversation], error: Error?) in
            self.refreshControl.endRefreshing()
            if let error = error {
                self.showAlertMessage(with: error)
            }
            self.conversations = ConversationDataController.shared.getConversations(ticket: self.ticket).filter { $0.timestamp != nil }.sorted { $0.timestamp! < $1.timestamp! } // swiftlint:disable:this force_unwrapping
            self.tableView.reloadData {
                guard self.tableView.numberOfSections > 0 else {
                    return
                }
                let lastSection = self.tableView.numberOfSections - 1
                let lastRow = self.tableView.numberOfRows(inSection: lastSection) - 1
                let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
                self.tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        guard
            let account = AccountController.shared.selectedAccount,
            !self.textView.text.isEmpty
        else {
            return
        }
        self.view.endEditing(false)
        self.imageSelectionContainerView.isHidden = true

        let newConversation = Conversation(ticket: self.ticket)
        newConversation.body = self.textView.text
        newConversation.fullname = account.profile?.fullname
        newConversation.datetime = Date().string(usingFormat: "dd/MM/YYYY h:mma")
        newConversation.status = .sending

        let images: [UIImage] = self.selectedImageInfos.compactMap {
            guard var image = $0[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
                return nil
            }
            return image
        }
        newConversation.images = images

        self.conversations.append(newConversation)

        self.tableView.beginUpdates()
        let indexSet = IndexSet(integer: self.conversations.count - 1)
        self.tableView.insertSections(indexSet, with: .fade)

        var indexPaths: [IndexPath] = []
        for i in 0..<newConversation.images.count + 1 {
            indexPaths.append(IndexPath(row: i, section: self.conversations.count - 1))
        }

        self.tableView.insertRows(at: indexPaths, with: .fade)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexPaths.last!, at: .top, animated: false) // swiftlint:disable:this force_unwrapping
        self.textView.text = String()

        for info in self.selectedImageInfos {
            guard let identifier = info["localIdentifier"]  as? String else {
                return
            }
//            Crashlytics.crashlytics().
            self.imagePickerVC?.deselectItem(for: identifier)
        }
        self.selectedImageInfos = []
        self.selectedImageCollectionView.reloadData()

        self.send(newConversation)
    }

    private func send(_ conversation: Conversation) {
        conversation.timestamp = Int(Date().timeIntervalSince1970)
        ConversationDataController.shared.replyConversation(conversation: conversation, attachment: conversation.images) { _, error in
            if error == nil {
                ConversationDataController.shared.remove(conversation: conversation)
            }

            conversation.status = error == nil ? .success : .failed
            if let index = self.conversations.index(where: { $0.id == conversation.id }) {
                guard self.tableView.numberOfSections > 0 else {
                    return
                }
                self.tableView.reloadSections([index], with: .automatic)
            }
        }
    }

    @objc
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addAttachment(_ sender: Any?) {
        self.requestForPhotoPermission(reason: NSLocalizedString("Use photos from your Photo Library as attachments.", comment: "")) {
            DispatchQueue.main.async {
                self.updateLayout(sender: sender)
                if self.imagePickerVC == nil {
                    self.imagePickerVC = self._imagePickerVC
                }
            }
        }
    }

    @IBAction func showHideDetails(_ sender: Any?) {
        self.updateLayout(sender: sender)
    }

    private func updateLayout(sender: Any? = nil) {
        switch true {
        case sender as? UITextView == self.textView:
            if !isDetailsHidden {
                self.isDetailsHidden = true
            }

            if !self.imageSelectionContainerView.isHidden {
                self.imageSelectionContainerView.isHidden = true
            }
        case sender as? UIButton == self.addAttachmentButton:
            self.textView.resignFirstResponder()
            if !self.isDetailsHidden {
                self.isDetailsHidden = true
            }
            self.imageSelectionContainerView.isHidden = !self.imageSelectionContainerView.isHidden
        case sender as? UIButton == detailButton:
            self.textView.resignFirstResponder()
            if !self.imageSelectionContainerView.isHidden {
                self.imageSelectionContainerView.isHidden = true
            }
            self.isDetailsHidden = !self.isDetailsHidden
        default:
            break
        }
        self.ticketAgentStackView.isHidden = self.textView.isFirstResponder || !self.imageSelectionContainerView.isHidden || self.ticketAgentNameLabel.text?.isEmpty ?? true

        if UIScreen.main.bounds.height < 667 {
            self.headerBasicStackView.isHidden = self.textView.isFirstResponder || !self.imageSelectionContainerView.isHidden
        }
    }
}

extension TicketDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.conversations.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let conversation = self.conversations[section]
        if conversation.images.isEmpty {
            return conversation.attachment.count + 1
        }
        return conversation.images.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = self.conversations[indexPath.section]
        let profile = AccountController.shared.selectedAccount?.profile

        guard conversation.fullname == profile?.fullname else {
            if indexPath.row > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationAttachmentCell") as? ConversationAttachmentCell {
                cell.configureCell(with: conversation.attachment[indexPath.row - 1], alignment: .left)
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            } else if let cell = tableView.dequeueReusableCell(withIdentifier: "LeftConversationCell") as? LeftConversationCell {
                cell.configureCell(with: conversation)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }

        let attachmentCount = conversation.images.isEmpty ? conversation.attachment.count : conversation.images.count
        if indexPath.row < attachmentCount,
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationAttachmentCell") as? ConversationAttachmentCell {
            if conversation.images.isEmpty {
                cell.configureCell(with: conversation.attachment[indexPath.row])
            } else {
                cell.configureCell(with: conversation.images[indexPath.row])
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "RightConversationCell") as? RightConversationCell {
            cell.configureCell(with: conversation)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ConversationFooterView") as? ConversationFooterView {
            let conversation = self.conversations[section]
            let profile = AccountController.shared.selectedAccount?.profile

            footerView.configure(with: conversation, alignment: conversation.fullname == profile?.fullname ? .right : .left  )
            footerView.delegate = self
            return footerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TicketDetailViewController: ConversationAttachmentCellDelegate {
    func cell(_ cell: ConversationAttachmentCell, didSelectImage image: UIImage?, attachment: Attachment?) {
        let photoVC: PhotoViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
        photoVC.image = image
        photoVC.attachment = attachment
        photoVC.modalTransitionStyle = .crossDissolve
        photoVC.modalPresentationStyle = .overCurrentContext
        self.present(photoVC, animated: true, completion: nil)
    }
}

extension TicketDetailViewController: KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval) {
        self.inputStackViewBottomConstraint.constant = endHeight
    }
}

extension TicketDetailViewController: ConversationFooterViewDelegate {
    func footerView(_ footerView: ConversationFooterView, resend conversation: Conversation) {
        self.send(conversation)
    }
}

extension TicketDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SelectedImageCellDelegate {
    func selectedImageCell(_ cell: SelectedImageCell, didRemove info: [String : Any]) {
        guard let identifier = info["localIdentifier"] as? String,
            let index = self.selectedImageInfos.index(where: { identifier == $0["localIdentifier"] as? String })
        else {
            return
        }

        self.selectedImageInfos.remove(at: index)
        self.selectedImageCollectionView.performBatchUpdates({
            self.selectedImageCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, completion: nil)

        imagePickerVC?.deselectItem(for: identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == attachmentCollectionView {
            return self.ticket.attachments.count
        }
        return selectedImageInfos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if
            collectionView == attachmentCollectionView,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttachmentCell", for: indexPath) as? AttachmentCell
        {
            cell.configureCell(with: self.ticket.attachments[indexPath.item])
            return cell
        } else if
            collectionView == selectedImageCollectionView,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedImageCell", for: indexPath) as? SelectedImageCell
        {
            let info = selectedImageInfos[indexPath.item]
            cell.configureCell(with: info)
            cell.delegate = self
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == attachmentCollectionView {
            let width = collectionView.bounds.width / 3
            return CGSize(width: width, height: width)
        } else if collectionView == selectedImageCollectionView {
            return CGSize(width: 80, height: collectionView.bounds.height - 2 * 5)
        }
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == selectedImageCollectionView {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == attachmentCollectionView {
            let photoVC: PhotoViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
            photoVC.attachment = self.ticket.attachments[indexPath.item]
            photoVC.modalTransitionStyle = .crossDissolve
            photoVC.modalPresentationStyle = .overCurrentContext
            self.present(photoVC, animated: true, completion: nil)
        }
    }
}

extension NSAttributedString {
    convenience init(htmlString html: String) throws {
        try self.init(data: Data(html.utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)
    }
}

extension TicketDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.updateLayout(sender: textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.updateLayout(sender: textView)
    }
}

extension TicketDetailViewController: ImagePickerControllerDelegate {
    func imagePickerDidCancel(imagePicker: ImagePickerViewController) {
    }

    func imagePicker(_ imagePicker: ImagePickerViewController, didDeselectMediaWithInfo info: [String : Any]) {
        guard let identifier = info["localIdentifier"] as? String,
            let index = self.selectedImageInfos.index(where: { identifier == $0["localIdentifier"] as? String })  else {
                return
        }
        self.selectedImageInfos.remove(at: index)
        self.selectedImageCollectionView.performBatchUpdates({
            self.selectedImageCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }, completion: nil)

    }

    func imagePicker(_ imagePicker: ImagePickerViewController, didSelectMediaWithInfo info: [String : Any]) {
        guard let _ = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            self.showAlertMessage(message: NSLocalizedString("Not able to select photo.", comment: ""))
            return
        }

        var info = info
        if info["localIdentifier"] == nil {
            info["localIdentifier"] = UUID().uuidString
        }
        self.selectedImageInfos.append(info)

        if self.textView.text.isEmpty {
            self.textView.text = NSLocalizedString("This is my attachment.", comment: "")
        }

        let indexPath = IndexPath(item: self.selectedImageInfos.count - 1, section: 0)
        self.selectedImageCollectionView.performBatchUpdates({
            self.selectedImageCollectionView.insertItems(at: [indexPath])
        }, completion: { (_: Bool) in
            if indexPath.item < self.selectedImageCollectionView.numberOfItems(inSection: 0) {
                self.selectedImageCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            }
        })
    }
}

class TimeImagePickerViewController: ImagePickerViewController {
    override  open class var imagePickerNib: UINib {
        return UINib(nibName: "TimeImagePickerViewController", bundle: Bundle.main)
    }

    override var cellNib: UINib {
        return UINib(nibName: "TimeImagePickerCell", bundle: Bundle.main)
    }
}
