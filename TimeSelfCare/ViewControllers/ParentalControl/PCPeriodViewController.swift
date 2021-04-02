//
//  PCPeriodViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

protocol PCPeriodViewControllerDelegate {
    func selected(period: SelectPeriod)
}

class PCPeriodViewController: UIViewController {
    
    let maxV = 25_000
    let period = [
        PeriodModel(with: ["repeatMode": kHwRepeatModeNone]),
        PeriodModel(with:  ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekMon]),
        PeriodModel(with: ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekTue]),
        PeriodModel(with: ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekWed]),
        PeriodModel(with: ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekTus]),
        PeriodModel(with: ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekFri]),
        PeriodModel(with: ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekSat]),
        PeriodModel(with: ["repeatMode": kHwRepeatModeWeek, "type": kHwDayOfWeekSun])
    ]
    
    var selectedPeriod: [PeriodModel] = []
    var repeatMode: HwRepeatMode?
    var index: Int?

    var delegate: PCPeriodViewControllerDelegate?
    
    var startH = 7
    var startM = 0
    var endH = 23
    var endM = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var confirmView: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SELECT ACCESS PERIOD", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        self.pickerViewLoaded(row: 0, component: 0)
        self.pickerViewLoaded(row: 0, component: 1)
        self.pickerViewLoaded(row: 0, component: 2)
        self.pickerViewLoaded(row: 0, component: 3)
        
        checkConfirmButton()
    }
    
    @IBAction func actConfirm(_ sender: Any) {
        if !selectedPeriod.isEmpty {
            if let period = SelectPeriod(with: [
                "startTime": "\(String(format: "%02d", self.pickerView.selectedRow(inComponent: 0) % 24)):\(String(format: "%02d", self.pickerView.selectedRow(inComponent: 1) % 60))",
                "endTime": "\(String(format: "%02d", self.pickerView.selectedRow(inComponent: 2) % 24)):\(String(format: "%02d", self.pickerView.selectedRow(inComponent: 3) % 60))",
                "dayOfWeeks": selectedPeriod.map { $0.type },
                "repeatMode": selectedPeriod.first?.repeatMode
            ]) {
                self.dismissVC()
                if index != nil {
                    period.index = index
                }
                delegate?.selected(period: period)
            }
        }
    }
    
}

extension PCPeriodViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxV
    }
    
    func pickerViewLoaded(row:Int, component:Int) {
        if component == 0 {
            let base24 = (maxV / 2) - (maxV / 2) % 24
            self.pickerView.selectRow(row % 24 + base24 + startH, inComponent: component, animated: false)
        } else if component == 1 {
            let base24 = (maxV / 2) - (maxV / 2) % 60
            self.pickerView.selectRow(row % 60 + base24 + startM, inComponent: component, animated: false)
        } else if component == 2 {
            let base24 = (maxV / 2) - (maxV / 2) % 24
            self.pickerView.selectRow(row % 24 + base24 + endH, inComponent: component, animated: false)
        } else if  component == 3 {
            let base24 = (maxV / 2) - (maxV / 2) % 60
            self.pickerView.selectRow(row % 60 + base24 + endM, inComponent: component, animated: false)
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

extension PCPeriodViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return period.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as? PCPeriodTableViewCell
        let currentPeriod = period[indexPath.row]
        
        cell?.selectionStyle = .none
        switch currentPeriod?.type {
        case kHwDayOfWeekMon:
            cell?.name.text = "Every Monday"
        case kHwDayOfWeekTue:
            cell?.name.text = "Every Tuesday"
        case kHwDayOfWeekWed:
            cell?.name.text = "Every Wednesday"
        case kHwDayOfWeekTus:
            cell?.name.text = "Every Thursday"
        case kHwDayOfWeekFri:
            cell?.name.text = "Every Friday"
        case kHwDayOfWeekSat:
            cell?.name.text = "Every Saturday"
        case kHwDayOfWeekSun:
            cell?.name.text = "Every Sunday"
        default:
            cell?.name.text = "Once"
        }
        if selectedPeriod.contains(where: { $0.type == currentPeriod?.type }) {
            cell?.setChosen(chosen: true)
        } else {
            cell?.setChosen(chosen: false)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? PCPeriodTableViewCell
        
        let currentPeriod = period[indexPath.row]
        let chosenIndex = selectedPeriod.firstIndex { $0.type == currentPeriod?.type }
        
        if chosenIndex ?? -1 >= 0 {
            selectedPeriod.remove(at: chosenIndex ?? -1)
            cell?.setChosen(chosen: false)
        } else {
            if indexPath.row == 0 {
                selectedPeriod.removeAll()
            } else {
                selectedPeriod.removeAll(where: { $0.type == period[0]?.type })
            }
            selectedPeriod.append(currentPeriod ?? PeriodModel())
            cell?.setChosen(chosen: true)
            tableView.reloadData()
        }
        
        checkConfirmButton()
    }
    
    func checkConfirmButton() {
        if selectedPeriod.isEmpty {
            confirmView.backgroundColor = UIColor(hex: "C6C6C6")
            confirmView.isUserInteractionEnabled = false
        } else {
            confirmView.backgroundColor = .primary
            confirmView.isUserInteractionEnabled = true
        }
    }
}
