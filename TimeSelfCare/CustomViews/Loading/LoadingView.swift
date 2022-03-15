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
    
    public func showLoading(toView: UIView) {
        toView.addSubview(self)
    }
    
    public func hideLoading() {
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
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        animationView.animation = Animation.named("new_loading")
        animationView.loopMode = .loop
        animationView.play()
    }
}
