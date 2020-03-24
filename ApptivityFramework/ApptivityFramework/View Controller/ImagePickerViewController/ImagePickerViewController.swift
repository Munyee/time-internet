//
//  ImagePickerViewController.swift
//  Wanderclass
//
//  Created by AppLab on 18/11/2016.
//  Copyright © 2016 AppLab. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

public protocol ImagePickerControllerDelegate: class {
    func imagePickerDidCancel(imagePicker: ImagePickerViewController)
    func imagePicker(_ imagePicker: ImagePickerViewController, didSelectMediaWithInfo info: [String : Any])
    func imagePicker(_ imagePicker: ImagePickerViewController, didDeselectMediaWithInfo info: [String : Any])
}

open class ImagePickerViewController: UIViewController {

    private static let cellIdentifier = "AssetCell"
    private var assetsController: PhotoAssetsController = PhotoAssetsController()

    var mediaTypes: [String] = [kUTTypeImage as String, kUTTypeVideo as String]
    var sourceType: UIImagePickerControllerSourceType?

    private var allowMultipleSelection: Bool = false {
        didSet {
            self.assetsCollectionView.allowsMultipleSelection = allowMultipleSelection
        }
    }

    private var showingImagePickerControllerButtons: Bool = false
    private var imagePickerController: UIImagePickerController?

    open weak var imagePickerDelegate: ImagePickerControllerDelegate?
    private var imagePickerCompletion: ((_ info: [String : Any]?) -> Void)?

    private var pickedImageSize: CGSize!

    open var headerNib: UINib {
        return UINib(nibName: "ImagePickerHeaderView", bundle: Bundle(for: ImagePickerHeaderView.self))
    }

    open var cellNib: UINib {
        return UINib(nibName: "ImagePickerAssetCell", bundle: Bundle(for: ImagePickerAssetCell.self))
    }

    open class var imagePickerNib: UINib {
        let bundle: Bundle = Bundle(for: ImagePickerViewController.classForCoder())
        return UINib(nibName: "ImagePickerViewController", bundle: bundle)
    }

    @IBOutlet private weak var containerVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var assetsCollectionView: UICollectionView!
    @IBOutlet private weak var assetsCollectionViewLeading: NSLayoutConstraint!
    @IBOutlet private weak var cameraButtonView: UIView!
    @IBOutlet private weak var libraryButtonView: UIView!

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.assetsController.resetCachedAssets()

        self.assetsCollectionView.register(self.headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ImagePickerHeaderView")
        self.assetsCollectionView.register(self.cellNib, forCellWithReuseIdentifier: "AssetCell")
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !self.containerVisualEffectView.isHidden {
            if let sourceType = self.sourceType {
                switch sourceType {
                case .camera:
                    self.presentCamera(self)
                default:
                    self.presentLibrary(self)
                }

                self.containerVisualEffectView.isHidden = true
                return
            }
        }

        self.revealImagePickerButtons(self)
        self.showingImagePickerControllerButtons = true
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.assetsController.updateCachedAssets(viewBounds: self.assetsCollectionView.bounds, indexPathsForElementsInRectHandler: { (rect: CGRect) -> [IndexPath] in
            return self.assetsCollectionView.aapl_indexPathsForElements(in: rect)
        }, targetThumbnailSize: (self.assetsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize)
    }

    @IBAction private func revealImagePickerButtons(_ sender: Any) {
        (sender as? UIButton)?.isHidden = true
        self.cameraButtonView?.isHidden = false
        self.libraryButtonView?.isHidden = false

        self.showingImagePickerControllerButtons = true
        self.assetsCollectionView.collectionViewLayout.invalidateLayout()

        self.assetsCollectionView.setContentOffset(CGPoint.zero, animated: true)
    }

    @IBAction private func presentCamera(_ sender: Any) {
        if !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) {
            self.showAlertMessage(title: NSLocalizedString("Camera Unavailable", comment: "Camera Unavailable"), message: NSLocalizedString("Camera is not available on this device.", comment: "Camera is not available on this device."))
            return
        }

        self.imagePickerController = UIImagePickerController()
        self.imagePickerController?.sourceType = UIImagePickerControllerSourceType.camera
        self.imagePickerController?.mediaTypes = self.mediaTypes
        self.imagePickerController?.delegate = self

        self.present(self.imagePickerController!, animated: true, completion: nil)
    }

    @IBAction private func presentLibrary(_ sender: Any) {
        self.imagePickerController = UIImagePickerController()
        self.imagePickerController?.mediaTypes = self.mediaTypes
        self.imagePickerController?.delegate = self

        self.present(self.imagePickerController!, animated: true, completion: nil)
    }

    public func deselectItem(for identifier: String) {
        guard let index: Int = {
            return Array(0...self.assetsController.assetsFetchResults.count - 1).first { self.assetsController.assetsFetchResults[$0].localIdentifier == identifier }
        }() else {
            return
        }
        self.assetsCollectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: true)
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { () -> Void in
            self.imagePickerDelegate?.imagePickerDidCancel(imagePicker: self)
            self.imagePickerCompletion?(nil)

            if self.imagePickerDelegate == nil {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: { () -> Void in
            self.imagePickerDelegate?.imagePicker(self, didSelectMediaWithInfo: info)
            self.imagePickerCompletion?(info)

            if self.imagePickerDelegate == nil || self.sourceType != nil {
                self.sourceType = nil
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}

extension ImagePickerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetsController.assetsFetchResults.count
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if !self.showingImagePickerControllerButtons {
            return CGSize(width: 40, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: 120, height: collectionView.frame.size.height)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView: ImagePickerHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImagePickerHeaderView", for: indexPath) as! ImagePickerHeaderView

        headerView.setButtonsHidden(!self.showingImagePickerControllerButtons)

        headerView.cameraButton.addTarget(self, action: #selector(ImagePickerViewController.presentCamera(_:)), for: UIControlEvents.touchUpInside)
        self.cameraButtonView = headerView.cameraButtonView

        headerView.libraryButton.addTarget(self, action: #selector(ImagePickerViewController.presentLibrary(_:)), for: UIControlEvents.touchUpInside)
        self.libraryButtonView = headerView.libraryButtonView

        headerView.revealButton.isHidden = self.assetsController.assetsFetchResults.count < 5
        if self.showingImagePickerControllerButtons {
            headerView.revealButton.isHidden = true
        }
        headerView.revealButton.addTarget(self, action: #selector(ImagePickerViewController.revealImagePickerButtons(_:)), for: UIControlEvents.touchUpInside)

        return headerView
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset: PHAsset = self.assetsController.assetsFetchResults[indexPath.item]

        let cell: ImagePickerAssetCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerViewController.cellIdentifier, for: indexPath) as! ImagePickerAssetCell
        cell.setImage(nil, forAssetIdentifier: asset.localIdentifier)

        let targetSize: CGSize = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize ?? CGSize.zero

        self.assetsController.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image: UIImage?, info: [AnyHashable : Any]?) -> Void in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.setImage(image, forAssetIdentifier: asset.localIdentifier)
            }
        })

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset: PHAsset = self.assetsController.assetsFetchResults[indexPath.item]

        let options: PHImageRequestOptions = PHImageRequestOptions()
        options.resizeMode = .none
        //options.isSynchronous = true
        options.isNetworkAccessAllowed = true

        self.assetsController.imageManager.requestImage(for: asset, targetSize: pickedImageSize, contentMode: PHImageContentMode.default, options: options, resultHandler: { [unowned self] (image: UIImage?, info: [AnyHashable : Any]?) -> Void in

            var info: [String : Any] = [:]
            if let adjustedImage: UIImage = image?.scaledTo(scale: 1) {
                info[UIImagePickerControllerOriginalImage] = adjustedImage as Any
                info["localIdentifier"] = asset.localIdentifier
            }

            self.imagePickerDelegate?.imagePicker(self, didSelectMediaWithInfo: info)
            self.imagePickerCompletion?(info)

            if self.imagePickerDelegate == nil {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var info: [String : Any] = [:]
        info["localIdentifier"] = self.assetsController.assetsFetchResults[indexPath.item].localIdentifier
        self.imagePickerDelegate?.imagePicker(self, didDeselectMediaWithInfo: info)
    }
}

public extension ImagePickerViewController {

    public class func imagePicker(mediaTypes: [String] = [kUTTypeImage as String], allowMultipleSelection: Bool = false,  pickedTargetSize: CGSize = PHImageManagerMaximumSize, sourceType: UIImagePickerControllerSourceType? = nil, picked: ((_ info: [String : Any]?) -> Void)? = nil) -> ImagePickerViewController {
        var imagePickerViewController: ImagePickerViewController! = nil

        for items in self.imagePickerNib.instantiate(withOwner: nil, options: nil) {
            if let targetVC: ImagePickerViewController = items as? ImagePickerViewController {
                imagePickerViewController = targetVC
                break
            }
        }
        imagePickerViewController.allowMultipleSelection = allowMultipleSelection
        imagePickerViewController.sourceType = sourceType
        imagePickerViewController.imagePickerCompletion = picked
        imagePickerViewController.mediaTypes = mediaTypes
        imagePickerViewController.pickedImageSize = pickedTargetSize
        return imagePickerViewController
    }
}
