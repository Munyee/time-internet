//
//  ScheduleViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/03/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

protocol ScheduleViewControllerDelegate {
    func updateNewTime(type: HeaderType, time: String)
}

enum HeaderType {
    case startAt
    case closeAt
}

class ScheduleViewController: PopUpViewController {
    
    let maxV = 25_000
    var hours = 7
    var mins = 0
    var type: HeaderType = .startAt
    var delegate: ScheduleViewControllerDelegate?
    
    @IBOutlet private weak var pickerView: UIPickerView!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .startAt:
            self.headerLabel.text = "START AT"
        case .closeAt:
            self.headerLabel.text = "CLOSE AT"
        }
        self.pickerViewLoaded(row: 0, component: 0)
        self.pickerViewLoaded(row: 0, component: 1)
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }
    
    @IBAction func actConfirm(_ sender: Any) {
        delegate?.updateNewTime(type: type, time: String(format: "%02d:%02d", self.pickerView.selectedRow(inComponent: 0) % 24, self.pickerView.selectedRow(inComponent: 1) % 60))
        self.hideAnimate {}
    }
    
}

extension ScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxV
    }
    
    func pickerViewLoaded(row:Int, component:Int) {
        if component == 0 {
            let base24 = (maxV / 2) - (maxV / 2) % 24
            self.pickerView.selectRow(row % 24 + base24 + hours, inComponent: component, animated: false)
        } else if component == 1 {
            let base24 = (maxV / 2) - (maxV / 2) % 60
            self.pickerView.selectRow(row % 60 + base24 + mins, inComponent: component, animated: false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width / 4, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width / 4, height: 50))
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.font = UIFont(name: "DIN-Light", size: 38)
            label.textColor = .primary
        } else {
            label.font = UIFont(name: "DIN-Light", size: 26)
            label.textColor = .lightGray
        }
        
        if component == 0 || component == 2 {
            label.text = String(format: "%02d", (row % 24))
        } else if component == 1 || component == 3 {
            label.text = String(format: "%02d", (row % 60))
        }
        
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
        return contentView
    }
}
