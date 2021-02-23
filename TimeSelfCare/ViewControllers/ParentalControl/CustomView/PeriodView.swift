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
    var period: SelectPeriod?
    
    var delegate: PeriodViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(period: SelectPeriod) {
        super.init(frame: .zero)
        commonInit()
        self.period = period
        
        var days = ""
        
        if period.repeatMode == kHwRepeatModeNone {
           days = "Once"
        } else {
            for item in period.dayOfWeeks ?? [] {
                if let day = item as? kHwDayOfWeek {
                    
                    if days != "" {
                        days = "\(days), "
                    }
                    
                    if day == kHwDayOfWeekMon {
                        days = "Monday"
                    }
                    
                    if day == kHwDayOfWeekTue {
                        days = "\(days)Tuesday"
                    }
                    
                    if day == kHwDayOfWeekWed {
                        days = "\(days)Wednesday"
                    }
                    
                    if day == kHwDayOfWeekTus {
                        days = "\(days)Thursday"
                    }
                    
                    if day == kHwDayOfWeekFri {
                        days = "\(days)Friday"
                    }
                    
                    if day == kHwDayOfWeekSat {
                        days = "\(days)Saturday"
                    }
                    
                    if day == kHwDayOfWeekSun {
                        days = "\(days)Sunday"
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
