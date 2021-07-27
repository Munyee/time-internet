//
//  PeriodView.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 23/02/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import HwMobileSDK

protocol PeriodViewDelegate {
    func remove(period: SelectPeriod)
    func editPeriod(period: SelectPeriod)
}

class PeriodView: UIView {
    
    @IBOutlet var contentView: UIControl!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var closeView: UIControl!
    @IBOutlet weak var separator: UIView!
    
    var period: SelectPeriod?
    
    var delegate: PeriodViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(period: SelectPeriod, isEdit: Bool) {
        super.init(frame: .zero)
        commonInit()
        self.period = period
        closeView.isHidden = !isEdit
        separator.isHidden = !isEdit
        
        var days = ""
        
        if period.repeatMode == kHwRepeatModeNone {
           days = "Once"
        } else {
            for item in period.dayOfWeeks?.sorted(by: { $0.rawValue < $1.rawValue }) ?? [] {
                if let day = item as? kHwDayOfWeek {
                    
                    if days != "" {
                        days = "\(days), "
                    }
                    
                    if day == kHwDayOfWeekMon {
                        days = "Mon"
                    }
                    
                    if day == kHwDayOfWeekTue {
                        days = "\(days)Tue"
                    }
                    
                    if day == kHwDayOfWeekWed {
                        days = "\(days)Wed"
                    }
                    
                    if day == kHwDayOfWeekTus {
                        days = "\(days)Thu"
                    }
                    
                    if day == kHwDayOfWeekFri {
                        days = "\(days)Fri"
                    }
                    
                    if day == kHwDayOfWeekSat {
                        days = "\(days)Sat"
                    }
                    
                    if day == kHwDayOfWeekSun {
                        days = "\(days)Sun"
                    }
                }
            }
        }
        
        if let startTime = period.startTime, let endTime = period.endTime {
            name.text = "\(startTime) - \(endTime) ; \(days)"
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PeriodView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func actRemoveDevice(_ sender: Any) {
        if let currentPeriod = period {
            delegate?.remove(period: currentPeriod)
        }
    }
    
    @IBAction func actEditPeriod(_ sender: Any) {
        if let currentPeriod = period {
            delegate?.editPeriod(period: currentPeriod)
        }
    }
}
