//
//  DevicesViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class DevicesViewController: UIViewController {
    
    let maxV = 120
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SELECT ACCESS PERIOD", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_close_magenta"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        self.pickerViewLoaded(row: 0, component: 0)
        self.pickerViewLoaded(row: 0, component: 1)
        self.pickerViewLoaded(row: 0, component: 3)
        self.pickerViewLoaded(row: 0, component: 4)
        // Do any additional setup after loading the view.
    }
    
}

extension DevicesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 2 {
            return 1
        } else {
            return maxV
        }
    }
    
    func pickerViewLoaded(row:Int, component:Int) {
        let base24 = (maxV / 2) - (maxV / 2) % 24
        self.pickerView.selectRow(row % 24 + base24, inComponent: component, animated: false)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
        
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var contentView = UIView(frame: CGRect(x: 0, y: 0, width: (pickerView.frame.width - 20) / 4, height: 50))
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: (pickerView.frame.width - 20) / 4, height: 50))
        
        if component == 2 {
            contentView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        }
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.font = UIFont(name: "DIN-Light", size: 38)
            label.textColor = .primary
        } else {
            label.font = UIFont(name: "DIN-Light", size: 26)
            label.textColor = .lightGray
        }

        if component == 0 || component == 3 {
            label.text = String(format: "%02d", (row % 24))
        } else if component == 1 || component == 4 {
            label.text = String(format: "%02d", (row % 60))
        } else {
            label.text = "-"
            label .textColor = .primary
        }

        label.textAlignment = .center

        contentView.addSubview(label)

        return contentView
    }
}
