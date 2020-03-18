//
//  SidebarNavigationController.swift
//  TimeSelfCare
//
//  Created by Loka on 09/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import APTSidebarNavigationController

internal class SidebarNavigationController: APTSidebarNavigationController {
    var sideBarTableViewController: SidebarTableViewController? {
        return self.children.compactMap { $0 as? SidebarTableViewController }.first
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideLeftSidebar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
