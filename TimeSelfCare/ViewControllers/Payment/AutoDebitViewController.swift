//
//  AutoDebitViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 23/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class AutoDebitViewController: TimeBaseViewController {

    private var creditCards: [CreditCard] = [] {
        didSet {
            self.tableView.reloadData()
            self.tableView.isHidden = self.creditCards.isEmpty
            self.placeholderView.isHidden = !self.creditCards.isEmpty
        }
    }
    @IBOutlet private weak var placeholderView: UIStackView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Auto Debit", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.back))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDataSet()
        self.refresh()
    }

    @IBAction func registerCard(_ sender: Any?) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let createCardVC = storyboard.instantiateViewController(withIdentifier: "CreateAutoDebitViewController") as? CreateAutoDebitViewController else {
            return
        }

        let cell = sender as? AutoDebitCell
        createCardVC.existingCreditCard = cell?.creditCard
        createCardVC.confirmationDidDismissAction = { [unowned self] () -> Void in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }

        self.presentNavigation(createCardVC, animated: true)
    }

    private func updateDataSet() {
        self.creditCards = CreditCardDataController.shared.getCreditCards(account: AccountController.shared.selectedAccount)
    }

    private func refresh() {
        CreditCardDataController.shared.loadCreditCards(account: AccountController.shared.selectedAccount) { _, error in
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }
            self.updateDataSet()
        }
    }

    @objc
    func back() {
        self.dismissVC()
    }
}

extension AutoDebitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AutoDebitCell") as? AutoDebitCell else {
            return UITableViewCell()
        }
        cell.configure(with: self.creditCards[indexPath.row])
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.registerCard(nil)
    }
}

extension AutoDebitViewController: AutoDebitCellDelegate {
    func modify(cell: AutoDebitCell, creditCard: CreditCard) {
        self.registerCard(cell)
    }
}
