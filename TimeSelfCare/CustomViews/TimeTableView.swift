//
//  TimeTableView.swift
//  TimeSelfCare
//
//  Created by Loka on 01/08/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

class TimeTableView: UITableView {
    private var reloadCompletionBlock: (() -> Void)?

    func reloadData(with completion: (() -> Void)?) {
        self.reloadCompletionBlock = completion
        self.reloadData()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.reloadCompletionBlock != nil {
            self.reloadCompletionBlock?()
            self.reloadCompletionBlock = nil
        }
    }
}
