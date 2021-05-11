//
//  DurationViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

protocol DurationViewControllerDelegate {
    func updateNewDuration(type: HeaderType, time: String)
}

class DurationViewController: PopUpViewController {

    @IBOutlet weak var pickerViewDays: UIPickerView!
    @IBOutlet weak var pickerViewHours: UIPickerView!
    @IBOutlet weak var pickerViewMins: UIPickerView!

    let maxDays = 30
    var days = 1
    var hours = 1
    var mins = 1
    var delegate: DurationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerViewLoaded(pickerView: pickerViewDays)
        self.pickerViewLoaded(pickerView: pickerViewHours)
        self.pickerViewLoaded(pickerView: pickerViewMins)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }
}

extension DurationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return maxDays
        } else if component == 2 || component == 4 {
            return 60
        } else {
            return 1
        }
    }
    
    func pickerViewLoaded(pickerView: UIPickerView) {
        if pickerView == pickerViewDays {
            pickerView.selectRow(days, inComponent: 0, animated: false)
        } else if pickerView == pickerViewHours {
            pickerView.selectRow(hours, inComponent: 0, animated: false)
        } else if pickerView == pickerViewMins {
            pickerView.selectRow(mins, inComponent: 0, animated: false)
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
        
        label.text = String(format: "%02d", row)
        
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
        return contentView
    }
}
