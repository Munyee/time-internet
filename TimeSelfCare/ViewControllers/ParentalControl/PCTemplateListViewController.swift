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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getParentalControl()
    }
    
    @objc
    func goToMainView() {
        let parentalControlVC: PCMainViewController = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController()
        parentalControlVC.hasData = true
        self.navigationController?.pushViewController(parentalControlVC, animated: true)
    }
    
    @objc
    func goToAddTemplate() {
        if let profileVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCProfileViewController") as? PCProfileViewController {
            profileVC.isEdit = true
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc
    func getParentalControl() {
        templateList.removeAll()
        let hud = LoadingView().addLoading(toView: self.view)
        hud.showLoading()

        HuaweiHelper.shared.getAttachParentalControlTemplateList(completion: { tplList in
            
            if tplList.isEmpty {
                let parentalControlVC: PCMainViewController = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController()
                parentalControlVC.hasData = false
                self.navigationController?.pushViewController(parentalControlVC, animated: true)
            }
            
            let names = tplList.map { template -> String in
                return template.name
            }
            
            HuaweiHelper.shared.getParentControlTemplateDetailList(templateNames: names, completion: { arrData in
                hud.hideLoading()
                self.templateList = arrData
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }) { _ in
                hud.hideLoading()
                self.dismissVC()
            }
            
        }) { _ in
            hud.hideLoading()
            self.dismissVC()
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
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let template = strongSelf.templateList[indexPath.row]
            cell.delegate = strongSelf
            cell.selectionStyle = .none
            cell.name.text = template.aliasName
            cell.numDevice.text = "\(template.macList.count) \(template.macList.count == 1 ? "device" : "devices")"
            cell.status.text = template.enable ? "Activated" : "Not Activated"
            cell.status.textColor = template.enable ? UIColor(hex: "21B406") : UIColor(hex: "E50707")
            cell.templateSwitch.isOn = template.enable
            cell.ctrlTemplate = template
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let template = templateList[indexPath.row]
            self.showAlertMessage(
                title: NSLocalizedString("Delete Profile", comment: ""),
                message: NSLocalizedString("Are you sure want to remove from the list?", comment: ""),
                actions: [
                    UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .destructive) { _ in
                        let hud = LoadingView().addLoading(toView: self.view)
                        hud.showLoading()

                        if let controlledDev = template.macList as? [String] {
                            let group = DispatchGroup()
                            for dev in controlledDev {
                                group.enter()
                                let pcControl = HwAttachParentControl()
                                pcControl.mac = dev
                                pcControl.templateName = template.name
                                HuaweiHelper.shared.deleteAttachParentControl(attachParentCtrl: pcControl) { _ in
                                    group.leave()
                                }
                            }
                            
                            group.notify(queue: .main) {
                                HuaweiHelper.shared.deleteAttachParentControlTemplate(name: template.name, completion: { _ in
                                    hud.hideLoading()
                                    self.getParentalControl()
                                }, error: { exception in
                                    DispatchQueue.main.async {
                                        self.showAlertMessage(message: HuaweiHelper.shared.mapErrorMsg(exception?.errorCode ?? ""))
                                        hud.hideLoading()
                                    }
                                })
                            }
                        }
                    },
                    UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let template = templateList[indexPath.row]
        
        if let profileVC = UIStoryboard(name: TimeSelfCareStoryboard.parentalcontrol.filename, bundle: nil).instantiateViewController(withIdentifier: "PCProfileViewController") as? PCProfileViewController {
            profileVC.isView = true
            profileVC.template = template
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

extension PCTemplateListViewController: PCTemplateTableViewCellDelegate {
    func templateUpdated() {
        getParentalControl()
    }
}
