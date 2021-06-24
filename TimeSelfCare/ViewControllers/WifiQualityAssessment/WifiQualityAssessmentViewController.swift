//
//  WifiQualityAssessmentViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 02/06/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit

class WifiQualityAssessmentViewController: UIViewController {

    @IBOutlet private weak var linkRateFormula: UILabel!
    @IBOutlet private weak var linkRate: UILabel!
    @IBOutlet private weak var rssiFormula: UILabel!
    @IBOutlet private weak var rssi: UILabel!
    @IBOutlet private weak var latencyFormula: UILabel!
    @IBOutlet private weak var latency: UILabel!
    @IBOutlet private weak var finalScore: UILabel!
    @IBOutlet private weak var hostTextField: UITextField!
    
    var pinger = try? SwiftyPing(host: "1.1.1.1", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupToHideKeyboardOnTapOnView()
        
        self.title = NSLocalizedString("WIFI QUALITY ASSESSMENT", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))

//        print(Units(kBytes: Int64(LinkRate.getRouterLinkSpeed() / 1_024)).getReadableUnit())
       
        startPing()
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pinger?.stopPinging()
    }
    
    func calculateLatecyScore(_ latency: Double) -> Double {
        if latency < 20 {
            let deductScore = latency * 1
            return (100.0 - deductScore)
        } else if latency >= 20 && latency < 100 {
            let deductScore = (latency - 20) * 0.25
            return (80.0 - deductScore)
        } else if latency >= 100 && latency < 300 {
            let deductScore = (latency - 100) * 0.15
            return (60.0 - deductScore)
        }
        
        return 0.0
    }
    
    func calculateLinkRate(_ linkrate: Double) -> Double {
        if linkrate > 300 {
            return 100
        } else if linkrate >= 150 && linkrate <= 300 {
            let deductScore = (300 - linkrate) / 15
            return (100 - deductScore)
        } else {
            return 0
        }
    }
    
    func calculateRSSIScore(_ rssi: Int) -> Double {
        if rssi == 3 {
            return 95
        } else if rssi == 2 {
            return 75
        } else if rssi == 1 {
            return 30
        } else {
            return 0
        }
    }
    
    func startPing() {
        pinger?.observer = { response in
            let duration = response.duration * 1_000
            
            let linkrate = ceil(self.calculateLinkRate(Units(kBytes: Int64(LinkRate.getRouterLinkSpeed() / 1_024)).getRateInMbps()))
            let rssi = ceil(self.calculateRSSIScore(HuaweiHelper.shared.getRSSISignal()))
            let latency = ceil(self.calculateLatecyScore(duration))
            print("-------Latest LinkRate/RSSI/Latency-------")
            print("Link Rate: \(linkrate) * 30% = \(linkrate * 30 / 100)")
            print("RSSI: \(rssi) * 30% = \(rssi * 30 / 100)")
            print("Latency: \(latency) * 40% = \(latency * 40 / 100)")
            print("Final Score: \(ceil((linkrate * 30 / 100)) + ceil(rssi * 30 / 100) + ceil(latency * 40 / 100))")
            self.linkRateFormula.text = "\(linkrate) * 30%"
            self.linkRate.text = "\(linkrate * 30 / 100)"
            self.rssiFormula.text = "\(rssi) * 30%"
            self.rssi.text = "\(rssi * 30 / 100)"
            self.latencyFormula.text = "\(String(format: "%.f", duration))ms - \(latency) * 40%"
            self.latency.text = "\(latency * 40 / 100)"
            self.finalScore.text = "\(ceil((linkrate * 30 / 100)) + ceil(rssi * 30 / 100) + ceil(latency * 40 / 100))"
        }
        try? pinger?.startPinging()
    }
    
    @IBAction func textFieldEndEdit(_ sender: UITextField) {
        pinger?.stopPinging()
        pinger = try? SwiftyPing(host: sender.text ?? "1.1.1.1", configuration: PingConfiguration(interval: 0.5, with: 5), queue: DispatchQueue.global())
        startPing()
    }
}
