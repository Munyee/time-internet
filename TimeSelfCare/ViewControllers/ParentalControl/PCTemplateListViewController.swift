//
//  PCTemplateListViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 22/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

class PCTemplateListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var templateList: [HwAttachParentControlTemplate] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("PARENTAL CONTROLS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 10
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "ic_add"), style: .done, target: self, action: #selector(self.goToAddTemplate)), UIBarButtonItem(image: #imageLiteral(resourceName: "ic_info"), style: .done, target: self, action: #selector(self.goToMainView)), spacer]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.getParentalControl), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        getParentalControl()
        // Do any additional setup after loading the view.
    }
    
    @objc
    func goToMainView() {
        let parentalControlVC: PCMainViewController = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(parentalControlVC, animated: true)
    }
    
    @objc
    func goToAddTemplate() {
        if let profileVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCProfileViewController") as? PCProfileViewController {
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc
    func getParentalControl() {
        templateList.removeAll()
        
        HuaweiHelper.shared.getAttachParentalControlTemplateList { tplList in
            let names = tplList.map { template -> String in
                return template.name
            }
            
            HuaweiHelper.shared.getParentControlTemplateDetailList(templateNames: names) { arrData in
                self.templateList = arrData
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension PCTemplateListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "templateCell", for: indexPath) as? PCTemplateTableViewCell else {
            return UITableViewCell()
        }
        
        let template = templateList[indexPath.row]
        cell.delegate = self
        cell.name.text = template.aliasName
        cell.numDevice.text = "\(template.macList.count) \(template.macList.count == 1 ? "device" : "devices")"
        cell.status.text = template.enable ? "Activated" : "Not Activated"
        cell.status.textColor = template.enable ? UIColor(hex: "21B406") : UIColor(hex: "E50707")
        cell.templateSwitch.isOn = template.enable
        cell.ctrlTemplate = template
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
}

extension PCTemplateListViewController: PCTemplateTableViewCellDelegate {
    func templateUpdated() {
       getParentalControl()
    }
}
