//
//  PairingViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 08/04/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import Pulsator

class PairingViewController: UIViewController {
    
    @IBOutlet private weak var pulseView: UIView!
    @IBOutlet private weak var timerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var progressWitdh: NSLayoutConstraint!
    @IBOutlet private weak var startImgView: UIImageView!
    @IBOutlet private weak var connectedImgView: UIImageView!
    @IBOutlet private weak var onlineImgView: UIImageView!
    let status: String? = ""
    let pulsator = Pulsator()

    var timer: Timer?
    var totalTime = 240
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DEVICE INSTALLATION", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        self.pulseView.layer.insertSublayer(pulsator, below: timerView.layer)
        pulsator.position = CGPoint(x: self.pulseView.bounds.width / 2, y: self.pulseView.bounds.height / 2)
        pulsator.radius = 100
        pulsator.animationDuration = 1
        pulsator.backgroundColor = UIColor.primary.cgColor
        UserDefaults.standard.set(0, forKey: "NO_DEVICE_FOUND")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pulsator.start()
        totalTime = 5
        self.timerLabel.text = timeFormatted(totalTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           UIView.transition(with: self.startImgView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.startImgView.image = UIImage(named: "icon_done")
            }, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.0, animations: {
                self.progressWitdh.constant = (self.view.frame.size.width - 120) / 2
                self.view.layoutIfNeeded()
            }, completion: { _ in
                UIView.transition(with: self.connectedImgView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.connectedImgView.image = UIImage(named: "icon_done")
                }, completion: nil)
            })
           
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        pulsator.stop()
    }
    
    @objc
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            timerLabel.text = timeFormatted(totalTime)
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
            
            switch status {
            case "WLAN_OKC_FOUND":
                break
            case "WLAN_OKC_SUCCESS", "EXTERNAP_ONLINE":
                break
            default:
                if let vc = UIStoryboard(name: TimeSelfCareStoryboard.deviceinstallation.filename, bundle: nil).instantiateViewController(withIdentifier: "NoDeviceFoundViewController") as? NoDeviceFoundViewController {
                    vc.delegate = self
                    self.presentNavigation(vc, animated: true)
                }
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension PairingViewController: NoDeviceFoundViewControllerDelegate {
    func backToHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
