//
//  NavigationSegue.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/26/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

// Presents destinationVC modally within a UINavigationController
class NavigationSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentNavigation(self.destination, animated: UIView.areAnimationsEnabled)
    }
}
