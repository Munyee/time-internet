//
//  ConfirmationViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 20/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class ConfirmationViewController: UIViewController {
    enum Mode {
        case emailUpdated
        case logout
        case autodebitAdded
        case autodebitRemoved
        case infoUpdated
        case ticketSubmitted
        case rewardRedeemed
        case profileUpdated
        case profileFailed

        var title: String {
            switch self {
            case .autodebitAdded:
                return NSLocalizedString("Auto Debit Added", comment: "Auto Debit Added")
            case .autodebitRemoved:
                return NSLocalizedString("Auto Debit Removed", comment: "Auto Debit Removed")
            case .emailUpdated:
                return NSLocalizedString("Successful!", comment: "")
            case .logout:
                return NSLocalizedString("Successfully Logged Out", comment: "")
            case .infoUpdated, .profileUpdated:
                return NSLocalizedString("Changes Saved", comment: "")
            case .profileFailed:
                return NSLocalizedString("Changes Failed", comment: "")
            case .ticketSubmitted, .rewardRedeemed:
                return NSLocalizedString("Thank You", comment: "")
            }
        }

        var iconImage: UIImage {
            switch self {
            case .autodebitRemoved:
                return #imageLiteral(resourceName: "ic_debit_card_removed")
            case .logout:
                return #imageLiteral(resourceName: "ic_logout")
            case .profileFailed:
                return #imageLiteral(resourceName: "ic_status_failed")
            default:
                return #imageLiteral(resourceName: "ic_status_success")
            }
        }

        var actionButtonTitle: String {
            switch self {
            case .autodebitAdded, .autodebitRemoved:
                return NSLocalizedString("Back to Home", comment: "Back to Home")
            case .emailUpdated:
                return NSLocalizedString("Continue", comment: "")
            case .logout:
                return NSLocalizedString("Go to Menu", comment: "")
            case .infoUpdated, .profileUpdated, .profileFailed:
                return NSLocalizedString("Close", comment: "")
            case .ticketSubmitted:
                return NSLocalizedString("View Tickets", comment: "")
            case .rewardRedeemed:
                return NSLocalizedString("View Reward", comment: "")
            }
        }

        var description: String {
            switch self {
            case .autodebitAdded:
                return NSLocalizedString("Thank you for your Auto Debit registration.", comment: "")
            case .autodebitRemoved:
                return NSLocalizedString("Your Card / Auto Debit service has been removed.", comment: "")
            case .emailUpdated:
                return NSLocalizedString("You have successfully completed the registration process.", comment: "")
            case .logout:
                return NSLocalizedString("You're now logged out.\n Your password will be required to login again.", comment: "")
            case .infoUpdated:
                return NSLocalizedString("Your information has been updated.", comment: "")
            case .ticketSubmitted:
                return NSLocalizedString("Your ticket has been submitted!", comment: "")
            case .rewardRedeemed:
                return NSLocalizedString("You have claimed your reward", comment: "")
            case .profileUpdated:
                return NSLocalizedString("Your information has been updated.", comment: "")
            case .profileFailed:
                return NSLocalizedString("Your information failed to update.", comment: "")
            }
        }
    }

    var actionBlock: (() -> Void)?
    var mode: Mode! // swiftlint:disable:this implicitly_unwrapped_optional

    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.actionButton.setTitle(mode.actionButtonTitle, for: .normal)
        self.descriptionLabel.text = mode.description
        self.iconImageView.image = mode.iconImage
        self.titleLabel.text = mode.title
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        actionBlock?()
    }
}
