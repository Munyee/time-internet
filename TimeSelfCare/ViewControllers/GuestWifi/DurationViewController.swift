//
//  DurationViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 10/05/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

enum DurationType {
    case noLimit
    case custom
}

protocol DurationViewControllerDelegate {
    func updateNewDuration(time: Int32, durationType: DurationType)
}

class DurationViewController: PopUpViewController {

    @IBOutlet private weak var pickerViewDays: UIPickerView!
    @IBOutlet private weak var pickerViewHours: UIPickerView!
    @IBOutlet private weak var pickerViewMins: UIPickerView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var timePickerView: UIView!
    @IBOutlet private weak var noLimitImageView: UIImageView!
    @IBOutlet private weak var customImageView: UIImageView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    let maxDays = 30
    var days = 1
    var hours = 1
    var mins = 1
    var duration: Int32?
    var durationType: DurationType?
    var delegate: DurationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timePickerView.isHidden = true
        ableConfirm(can: false)
        
        if let durationTime = duration {
            if durationTime == 0 {
                self.timePickerView.isHidden = true
                self.noLimitImageView.image = #imageLiteral(resourceName: "ic_radio_selected")
                self.customImageView.image = #imageLiteral(resourceName: "ic_radio_unselect")
                ableConfirm(can: true)
            } else if durationTime > 0 {
                self.timePickerView.isHidden = false
                self.noLimitImageView.image = #imageLiteral(resourceName: "ic_radio_unselect")
                self.customImageView.image = #imageLiteral(resourceName: "ic_radio_selected")
                ableConfirm(can: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.updateDuration()
                }
            }
        }
    }
    
    @IBAction func actDismiss(_ sender: Any) {
        self.hideAnimate {}
    }
    
    func toggleTimePicker(hide: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.timePickerView.isHidden = hide
            self.stackView.layoutIfNeeded()
            self.noLimitImageView.image = hide ? #imageLiteral(resourceName: "ic_radio_selected") : #imageLiteral(resourceName: "ic_radio_unselect")
            self.customImageView.image = hide ? #imageLiteral(resourceName: "ic_radio_unselect") : #imageLiteral(resourceName: "ic_radio_selected")
        }
    }
    
    @IBAction func actNoLimit(_ sender: Any) {
        durationType = .noLimit
        ableConfirm(can: true)
        toggleTimePicker(hide: true)
    }
    
    @IBAction func actCustom(_ sender: Any) {
        durationType = .custom
        ableConfirm(can: true)
        toggleTimePicker(hide: false)
    }
    
    func ableConfirm(can: Bool) {
        self.confirmButton.isUserInteractionEnabled = can
        self.confirmButton.backgroundColor = can ? UIColor.primary : UIColor.grey
    }
    
    @IBAction func actConfirm(_ sender: Any) {
        if durationType == .custom {
            let days = self.pickerViewDays.selectedRow(inComponent: 0)
            let hours = self.pickerViewHours.selectedRow(inComponent: 0)
            let mins = self.pickerViewMins.selectedRow(inComponent: 0)
            
            var duration = 0
            duration += days * 24 * 60
            duration += hours * 60
            duration += mins
            delegate?.updateNewDuration(time: Int32(duration), durationType: .custom)

        } else if durationType == .noLimit {
            delegate?.updateNewDuration(time: 0, durationType: .noLimit)
        }
        self.hideAnimate {}
    }
    
    func updateDuration() {
        let days = Int(duration!) / 60 / 24
        let hours = (Int(duration!) / 60) % 24
        let mins = (Int(duration!) % 60)
        
        self.pickerViewDays.selectRow(days, inComponent: 0, animated: false)
        self.pickerViewHours.selectRow(hours, inComponent: 0, animated: false)
        self.pickerViewMins.selectRow(mins, inComponent: 0, animated: false)

        self.pickerViewDays.reloadAllComponents()
        self.pickerViewHours.reloadAllComponents()
        self.pickerViewMins.reloadAllComponents()
    }
}

extension DurationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewDays {
            return 31
        } else if pickerView == pickerViewHours {
            return 24
        } else if pickerView == pickerViewMins {
            return 60
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
                
        if pickerView.selectedRow(inComponent: component) == row {
            label.font = UIFont(name: "DIN-Light", size: 36)
            label.textColor = .primary
        } else {
            label.font = UIFont(name: "DIN-Light", size: 23)
            label.textColor = .lightGray
        }
        
        label.text = String(format: "%02d", row)
        
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
        return contentView
    }
}
