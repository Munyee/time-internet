//
//  ReferralViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 18/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

class ReferralViewController: UIViewController {

    weak var data: HUAE?
    @IBOutlet private weak var referralLabel: UILabel!
    @IBOutlet private weak var pendingLabel: UILabel!
    @IBOutlet private weak var activatedLabel: UILabel!
    @IBOutlet private weak var unsuccessfulLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    var filterData: [String : Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("REFERRAL STATUS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        filterData = data?.referral_status_list
        initView()
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
     func initView() {
        let pending = data?.referral_status_list?.filter { _, value -> Bool in
            if let val = value as? NSDictionary {
                let status = val.value(forKey: "status") as? String
                return status == "In Progress"
            }
            return false
        }
        
        let activated = data?.referral_status_list?.filter { _, value -> Bool in
            if let val = value as? NSDictionary {
                let status = val.value(forKey: "status") as? String
                return status == "Activated"
            }
            return false
        }
        
        let unsuccessful = data?.referral_status_list?.filter { _, value -> Bool in
            if let val = value as? NSDictionary {
                let status = val.value(forKey: "status") as? String
                return status == "Unsuccessful"
            }
            return false
        }
        
        referralLabel.text = "\(data?.referral_status_list?.count ?? 0)"
        pendingLabel.text = "\(pending?.count ?? 0)"
        activatedLabel.text = "\(activated?.count ?? 0)"
        unsuccessfulLabel.text = "\(unsuccessful?.count ?? 0)"
        dateLabel.text = "As Of \(data?.discount_bill_date ?? "")"
        tableView.reloadData()
    }
    
    @IBAction func actChooseStatus(_ sender: Any) {
        let storyboard = UIStoryboard(name: TimeSelfCareStoryboard.summary.filename, bundle: nil)
        let fabMenuVC: FABViewController = storyboard.instantiateViewController()

        fabMenuVC.menuItems =  [.unsuccessful, .inprogress, .activated, .all]
        fabMenuVC.delegate = self
        self.present(fabMenuVC, animated: true, completion: nil)
    }
}

extension ReferralViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "referralCell", for: indexPath) as? ReferralTableViewCell
        guard let result: [String : Any] = filterData?.sorted(by: { $0.0 < $1.0 })[indexPath.row].value as? [String: Any] else {
            return UITableViewCell()
        }
        guard let item: ReferralStatus = ReferralStatus(with: result) else {
            return UITableViewCell()
        }
        cell?.nameLabel.text = item.name
        cell?.statusLabel.text = item.status?.uppercased()
        cell?.activationDateLabel.text = item.activation_date
        
        switch item.status?.uppercased() {
        case "ACTIVATED":
            cell?.statusLabel.backgroundColor = UIColor.turquoise
        case "IN PROGRESS":
            cell?.statusLabel.backgroundColor = UIColor.grey2
        case "UNSUCCESSFUL":
            cell?.statusLabel.backgroundColor = UIColor.primary
        default:
            cell?.statusLabel.backgroundColor = UIColor.turquoise
        }
        return cell ?? UITableViewCell()
    }
}

extension ReferralViewController: FABViewControllerDelegate {
    func viewController(_ viewController: FABViewController, didSelectItem menuItem: FloatingMenuItem) {
        filterData = data?.referral_status_list?.filter { _, value -> Bool in
            if menuItem.title == "All" {
                return true
            } else if let val = value as? NSDictionary {
                let status = val.value(forKey: "status") as? String
                return status == menuItem.title
            }
            return false
        }
        tableView.reloadData()
    }
    
    func viewControllerWillDismiss(_ viewController: FABViewController) {
        
    }
    
    func viewControllerDidDismiss(_ viewController: FABViewController) {
        
    }
}
