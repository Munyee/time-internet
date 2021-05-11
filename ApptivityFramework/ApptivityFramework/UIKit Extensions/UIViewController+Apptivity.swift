//
//  UIViewController+Apptivity.swift
//  ApptivityFramework
//
//  Created by AppLab on 24/10/2016.
//
//

import UIKit
import CoreLocation
import SafariServices

public extension UIViewController {

    public func showAlertMessage(title: String? = nil, message: String, actions: [UIAlertAction]) {
        let alertViewController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions {
            alertViewController.addAction(action)
        }
        self.present(alertViewController, animated: true, completion: nil)
    }

    public func showAlertMessage(title: String? = nil, message: String, dismissTitle: String = NSLocalizedString("OK", comment: "OK")) {
        self.showAlertMessage(title: title, message: message, actions: [
            UIAlertAction(title: dismissTitle, style: UIAlertActionStyle.cancel, handler: nil)
            ])
    }

    public func showAlertMessage(with error: Error?, message: String = NSLocalizedString("An error has occured. Please try again later.", comment: "An error has occured. Please try again later.")) {
        self.showAlertMessage(title: NSLocalizedString("Error", comment: "Error"), message: error?.localizedDescription ?? message)
    }
    
    public func showShareAction(shareText: String, sourceView: UIView? = nil) {
        let textToShare = [ shareText ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView ?? self.view
        if let sourceView = sourceView {
            activityViewController.popoverPresentationController?.sourceRect = sourceView.bounds
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }

    public func showActionSheet(title: String?, message: String?, actions: [UIAlertAction], dismissTitle: String = NSLocalizedString("Cancel", comment: "Cancel"), sourceView: UIView? = nil) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        for action in actions {
            alertController.addAction(action)
        }
        if !actions.map({ $0.style }).contains(UIAlertActionStyle.cancel) {
            let cancelAction: UIAlertAction = UIAlertAction(title: dismissTitle, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }

        alertController.popoverPresentationController?.sourceView = sourceView ?? self.view
        if let sourceView = sourceView {
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        }

        self.present(alertController, animated: true, completion: nil)
    }
    
    public func openWithNavigationAlert(coordinate: CLLocationCoordinate2D, message: String = "Navigate to location", handler: ((UIApplication.NavigationProvider) -> Void)? = nil) {

        let navigationAlertVC: UIAlertController = UIAlertController(title: NSLocalizedString("Navigation", comment: "Navigation"), message: NSLocalizedString("Navigate to location using", comment: "Navigate to location using"), preferredStyle: .actionSheet)

        if UIApplication.shared.canNavigateWith(provider: .googleMaps) {
            navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Google Maps", comment: "Google Maps"), style: .default) { (alert: UIAlertAction) in
                UIApplication.shared.navigateWithGoogleMaps(coordinate: coordinate)
                handler?(.googleMaps)
            })
        }

        if UIApplication.shared.canNavigateWith(provider: .waze) {
            navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Waze", comment: "Waze"), style: .default) { (alert: UIAlertAction) in
                UIApplication.shared.navigateWithWaze(coordinate: coordinate)
                handler?(.waze)
            })
        }

        if UIApplication.shared.canNavigateWith(provider: .appleMaps) {
            navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Apple Maps", comment: "Apple Maps"), style: .default, handler: { (alert: UIAlertAction) in
                UIApplication.shared.navigateWithAppleMaps(coordinate: coordinate)
                handler?(.appleMaps)
            }))
        }

        navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (alertAction: UIAlertAction) in
            navigationAlertVC.dismiss(animated: true, completion: nil)
        })

        self.present(navigationAlertVC, animated: true, completion: nil)
    }
    
    public func openWithNavigationAlert(address: String, message: String = "Navigate to location", handler: ((UIApplication.NavigationProvider) -> Void)? = nil) {
        
        let navigationAlertVC: UIAlertController = UIAlertController(title: NSLocalizedString("Navigation", comment: "Navigation"), message: NSLocalizedString("Navigate to location using", comment: "Navigate to location using"), preferredStyle: .actionSheet)
        
        if UIApplication.shared.canNavigateWith(provider: .googleMaps) {
            navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Google Maps", comment: "Google Maps"), style: .default) { (alert: UIAlertAction) in
                UIApplication.shared.searchWithGoogleMaps(address: address)
                handler?(.googleMaps)
            })
        }
        
        if UIApplication.shared.canNavigateWith(provider: .waze) {
            navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Waze", comment: "Waze"), style: .default) { (alert: UIAlertAction) in
                UIApplication.shared.searchWithWaze(address: address)
                handler?(.waze)
            })
        }
        
        if UIApplication.shared.canNavigateWith(provider: .appleMaps) {
            navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Apple Maps", comment: "Apple Maps"), style: .default, handler: { (alert: UIAlertAction) in
                UIApplication.shared.searchWithAppleMaps(address: address)
                handler?(.appleMaps)
            }))
        }
        
        navigationAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) { (alertAction: UIAlertAction) in
            navigationAlertVC.dismiss(animated: true, completion: nil)
        })
        
        self.present(navigationAlertVC, animated: true, completion: nil)
    }

    public func openWithImageSourceAlert(imagePicker: UIImagePickerController, messageForPhotoLibrary: String, messageForCamera: String) {
        let imageSourceAlertVC: UIAlertController = UIAlertController(title: NSLocalizedString("Image Source", comment: "Image Source"), message: NSLocalizedString("Select image from", comment: "Select image from"), preferredStyle: .actionSheet)

        imageSourceAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Photo Library", comment: "Photo Library"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.requestForPhotoPermission(imagePicker: imagePicker, reason: messageForPhotoLibrary)
        }))
        imageSourceAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
            self.requestForCameraPermission(imagePicker: imagePicker, reason: messageForCamera)
        }))
        imageSourceAlertVC.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.cancel, handler: nil))

        self.present(imageSourceAlertVC, animated: true, completion: nil)
    }

    public func presentNavigation(_ rootViewController: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: flag, completion: completion)
    }

    public func addViewControllerAsChildController(_ viewController: UIViewController, to containerView: UIView) {
        // Check if VC already contains childVC
        if self.childViewControllers.contains(viewController) {
            return
        }

        self.addChildViewController(viewController)
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }

    public func removeViewControllerAsChildController(_ viewController: UIViewController) {
        // Check that VC already contains childVC
        if !self.childViewControllers.contains(viewController) {
            return
        }

        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    public func openWebView(with url: URL, tintColor: UIColor?) {
        let safariVC = SFSafariViewController(url: url)

        if let tintColor = tintColor {
            if #available(iOS 10.0, *) {
                safariVC.preferredControlTintColor = tintColor
            } else {
                safariVC.view.tintColor = tintColor
            }
        }

        self.present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction public func dismissVC(_ sender: AnyObject? = nil) {
        if self.presentingViewController != nil {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    public func takeScreenshot() -> UIImage {
        let window = UIApplication.shared.windows[0]
        UIGraphicsBeginImageContextWithOptions(window.frame.size, window.isOpaque, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    
    public func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction public func shareScreenshot(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [self.takeScreenshot()], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
}

extension UIViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismissVC()
    }
}

public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
