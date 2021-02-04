//
//  Permissions.swift
//  ApptivityFramework
//
//  Created by Apptivity Lab on 27/10/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import Foundation
import Photos

// UX-friendly permissions model should handle:
// - Explain the need, and ask if user is ready to allow permission
//   - If ready, then show system prompt, if not, then just disable for now
// - If permission has been denied before, then show a message explaining the need and link to Settings app
public class Permissions {
}

public extension UIViewController {

    public func requestForPhotoPermission(imagePicker: UIImagePickerController, reason: String) {
        self.requestForPhotoPermission(reason: reason) { () -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }

    public func requestForPhotoPermission(reason: String, authorized: (() -> Void)?) {
        let authorizationStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        let alertTitle: String = NSLocalizedString("Photo Library Permission", comment: "Photo Library Permission")

        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (selectedStatus: PHAuthorizationStatus) in
                switch selectedStatus {
                case .authorized:
                    authorized?()
                default:
                    // Ignore
                    break
                }
            })
        case .authorized:
            authorized?()
        case .restricted, .denied, .limited:
            self.showAlertMessage(title: alertTitle, message: reason, actions: [
                UIAlertAction(title: NSLocalizedString("Later", comment: "Later"), style: UIAlertActionStyle.cancel, handler: nil),
                UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                    UIApplication.shared.openApplicationSettings()
                })
                ])
        }
    }

    public func requestForCameraPermission(imagePicker: UIImagePickerController, reason: String) {
        let authorizationStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        let alertTitle: String = NSLocalizedString("Camera Permission", comment: "Camera Permission")

        switch authorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (selectedStatus: PHAuthorizationStatus) in
                switch selectedStatus {
                case .authorized, .limited:
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                default:
                    // Ignore
                    break
                }
            })

        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            }

        case .restricted, .denied, .limited:
            self.showAlertMessage(title: alertTitle, message: reason, actions: [
                UIAlertAction(title: NSLocalizedString("Later", comment: "Later"), style: UIAlertActionStyle.cancel, handler: nil),
                UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                    UIApplication.shared.openApplicationSettings()
                })
                ])
        }
    }

    public func requestPermission(forAVMediaType mediaType: String = AVMediaType.video.rawValue, title: String, reason: String, authorized: (() -> Void)?) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType(rawValue: mediaType), completionHandler: { (granted: Bool) in
                if granted {
                    authorized?()
                }
            })
        case .authorized:
            authorized?()
        case .restricted, .denied:
            self.showAlertMessage(title: title, message: reason, actions: [
                UIAlertAction(title: NSLocalizedString("Later", comment: "Later"), style: UIAlertActionStyle.cancel, handler: nil),
                UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings"), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                    UIApplication.shared.openApplicationSettings()
                })
            ])
        }
    }
}
