//
//  UIStoryboard+Apptivity.swift
//  ApptivityFramework
//
//  Created by Aarief on 27/03/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import Foundation

public protocol Storyboard {
    var filename: String { get }
}

public extension UIStoryboard {
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}
