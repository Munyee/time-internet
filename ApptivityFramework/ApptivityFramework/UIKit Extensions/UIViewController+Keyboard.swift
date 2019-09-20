//
//  UIViewController+Keyboard.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/27/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

@objc public protocol KeyboardChangeObserver {
    func keyboardChanging(endHeight: CGFloat, duration: TimeInterval)
    @objc func keyboardChangeNotification(notification: Notification)
}

public class Keyboard {

    public static func addKeyboardChangeObserver(_ observer: KeyboardChangeObserver) {
        NotificationCenter.default.addObserver(observer, selector: #selector(KeyboardChangeObserver.keyboardChangeNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    public static func removeKeyboardChangeObserver(_ observer: KeyboardChangeObserver) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}

extension UIViewController {
    open func observeKeyboardChange(block: @escaping ((_ keyboardEndHeight: CGFloat, _ animationDuration: TimeInterval) -> (Void))) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

                block(endFrame!.height, duration)
            }
        }
    }

    @objc public final func keyboardChangeNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

            (self as? KeyboardChangeObserver)?.keyboardChanging(endHeight: endFrame!.origin.y >= UIScreen.main.bounds.size.height ? 0 : endFrame!.height, duration: duration)
        }
    }
}

