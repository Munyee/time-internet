//
//  LoadingView.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 14/03/2022.
//  Copyright © 2022 Apptivity Lab. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    
    public func addLoading(toView: UIView) -> LoadingView {
        let view = LoadingView(frame: toView.bounds)
        return view
    }
    
    public func showLoading() {
        animationView.play()
        if var vc = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = vc.presentedViewController {
                vc = presentedViewController
            }
            vc.view.addSubview(self)
        }
    }
    
    public func hideLoading() {
        animationView.stop()
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Loading", owner: self, options: nil)
        addSubview(contentView)
        var bounds = UIScreen.main.bounds
        var width = bounds.size.width
        var height = bounds.size.height
        
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        animationView.animation = Animation.named("new_loading")
        animationView.loopMode = .loop
        animationView.play()
    }
}
