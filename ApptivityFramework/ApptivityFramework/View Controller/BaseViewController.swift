//
//  BaseViewController.swift
//  ApptivityFramework
//
//  Created by AppLab on 13/02/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import Foundation

open class BaseViewController : UIViewController {
    open var analyticsTitle: String {
        return self.navigationItem.title ?? self.title ?? NSStringFromClass(self.classForCoder)
    }
}

open class BaseTableViewController : UITableViewController {
    open var analyticsTitle: String {
        return self.navigationItem.title ?? self.title ?? NSStringFromClass(self.classForCoder)
    }
}

open class BaseTabBarController : UITabBarController {
    open var analyticsTitle: String {
        return self.navigationItem.title ?? self.title ?? NSStringFromClass(self.classForCoder)
    }
}

