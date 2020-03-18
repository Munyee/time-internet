//
//  NotificationsHistoryViewController.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 11/1/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

open class NotificationsHistoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NotificationsHistoryViewController : UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APNSController.shared.recentNotifications.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        
        if let notification = APNSController.shared.recentNotifications[indexPath.row] as? AlertNotification {
            cell.textLabel?.text = notification.title
            cell.detailTextLabel?.text = notification.body
        } else {
            cell.textLabel?.text = "Unknown"
        }
        
        return cell
    }
}
