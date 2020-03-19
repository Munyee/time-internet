//
//  FABViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 04/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

protocol FABViewControllerDelegate: class {
    func viewController(_ viewController: FABViewController, didSelectItem menuItem: FloatingMenuItem)
    func viewControllerWillDismiss(_ viewController: FABViewController)
    func viewControllerDidDismiss(_ viewController: FABViewController)
}

internal class FABViewController: UIViewController {

    var menuItems: [FloatingMenuItem] = []
    private var items: [String] = []
    weak var delegate: FABViewControllerDelegate?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero) // trick to hide separator for empty cells
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addMenuItems()
    }

    private func addMenuItems() {
        self.tableView.beginUpdates()
        for i in 0..<self.menuItems.count {
            self.items.append(self.menuItems[i].title)
            let rowIndexPath = IndexPath(row: i, section: 0)
            self.tableView.insertRows(at: [rowIndexPath], with: .top)
        }
        self.tableView.endUpdates()
    }

    private func clearMenuItems() {
        self.tableView.beginUpdates()
        for i in 0 ..< self.items.count {
            let rowIndexPath = IndexPath(row: i, section: 0)
            self.tableView.deleteRows(at: [rowIndexPath], with: .automatic)
        }
        self.items.removeAll()
        self.tableView.endUpdates()
    }

    @IBAction func dismiss(_ sender: Any?) {
        self.delegate?.viewControllerWillDismiss(self)

        UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState], animations: {
            self.closeButton.alpha = 0
            self.closeButton.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi * -135.0 / 180.0))
        }, completion: { (completed: Bool) in
            self.clearMenuItems()

            if completed {
                self.presentingViewController?.dismiss(animated: true) {
                    self.delegate?.viewControllerDidDismiss(self)
                }
            }
        })
    }
}

extension FABViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FABCell") as? FABCell else {
            return UITableViewCell()
        }
        cell.configureCell(title: self.items[indexPath.row])
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.15, delay: TimeInterval(indexPath.row) * 0.1, options: .beginFromCurrentState, animations: {
            cell.alpha = 1
        }, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.viewController(self, didSelectItem: self.menuItems[indexPath.row])
        self.dismiss(nil)
    }
}
