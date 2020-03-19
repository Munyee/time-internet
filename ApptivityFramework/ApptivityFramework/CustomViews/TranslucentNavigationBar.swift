//
//  TranslucentNavigationBar.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/25/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

@IBDesignable
class TransparentNavigationController: UINavigationBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setup()
    }
    
    private func setup() {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
