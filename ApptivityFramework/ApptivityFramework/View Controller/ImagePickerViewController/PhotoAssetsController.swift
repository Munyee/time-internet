//
//  PhotoAssetsController.swift
//  Wanderclass
//
//  Created by AppLab on 18/11/2016.
//  Copyright © 2016 AppLab. All rights reserved.
//

import UIKit
import Photos

public extension UICollectionView {

    func aapl_indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        if let allLayoutAttributes: [UICollectionViewLayoutAttributes] = self.collectionViewLayout.layoutAttributesForElements(in: rect) {
            if allLayoutAttributes.count > 0 {
                var indexPaths: [IndexPath] = []
                for layoutAttributes in allLayoutAttributes {
                    let indexPath: IndexPath = layoutAttributes.indexPath
                    indexPaths.append(indexPath)
                }
                return indexPaths
            }
        }

        return []
    }
}

class PhotoAssetsController: NSObject {

    public var imageManager: PHCachingImageManager!
    public var assetsFetchResults: PHFetchResult<PHAsset>!
    
    fileprivate var preheatRect: CGRect = CGRect.zero

    public override init() {
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        fetchOptions.includeAssetSourceTypes = PHAssetSourceType.typeUserLibrary

        self.assetsFetchResults = PHAsset.fetchAssets(with: fetchOptions)
        self.imageManager = PHCachingImageManager()
    }

    public func assets(atIndexPaths indexPaths: [IndexPath]) -> [PHAsset] {
        if indexPaths.count == 0 || self.assetsFetchResults.count < indexPaths.count {
            return []
        }

        var assets: [PHAsset] = []
        for indexPath in indexPaths {
            
            assets.append(self.assetsFetchResults[indexPath.item])
        }

        return assets
    }

    public func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
        self.preheatRect = CGRect.zero
    }

    public func updateCachedAssets(viewBounds: CGRect, indexPathsForElementsInRectHandler: @escaping (_ rect: CGRect) -> [IndexPath], targetThumbnailSize: CGSize) {
        var newPreheatRect = viewBounds
        newPreheatRect = viewBounds.insetBy(dx: 0, dy: -0.5 * viewBounds.size.height)

        let delta: CGFloat = abs(newPreheatRect.midY - self.preheatRect.midY)
        if delta > viewBounds.size.height / 3 {
            var addedIndexPaths: [IndexPath] = []
            var removedIndexPaths: [IndexPath] = []

            self.computeDifferenceBetweenRect(self.preheatRect, newRect: newPreheatRect, removedHandler: { (removedRect: CGRect) in
                removedIndexPaths += indexPathsForElementsInRectHandler(removedRect)
            }, addedHandler: { (addedRect: CGRect) in
                addedIndexPaths += indexPathsForElementsInRectHandler(addedRect)
            })

            let assetsToStartCaching: [PHAsset] = self.assets(atIndexPaths: addedIndexPaths)
            let assetsToStopCaching: [PHAsset] = self.assets(atIndexPaths: removedIndexPaths)

            self.imageManager.startCachingImages(for: assetsToStartCaching, targetSize: targetThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil)
            self.imageManager.stopCachingImages(for: assetsToStopCaching, targetSize: targetThumbnailSize, contentMode: PHImageContentMode.aspectFill, options: nil)

            self.preheatRect = newPreheatRect
        }
    }

    private func computeDifferenceBetweenRect(_ oldRect: CGRect, newRect: CGRect, removedHandler: ((_ removedRect: CGRect) -> Void)?, addedHandler: ((_ addedRect: CGRect) -> Void)?) {

        if newRect.intersects(oldRect) {
            let oldMaxY = oldRect.maxY
            let oldMinY = oldRect.minY
            let newMaxY = newRect.maxY
            let newMinY = newRect.minY

            if newMaxY > oldMaxY {
                let rectToAdd: CGRect = CGRect(x: newRect.origin.x, y: oldMaxY, width: newRect.size.width, height: (newMaxY - oldMaxY))
                addedHandler?(rectToAdd)
            }

            if oldMinY > newMinY {
                let rectToAdd: CGRect = CGRect(x: newRect.origin.x, y: newMinY, width: newRect.size.width, height: (oldMinY - newMinY))
                addedHandler?(rectToAdd)
            }

            if newMaxY < oldMaxY {
                let rectToRemove: CGRect = CGRect(x: newRect.origin.x, y: newMaxY, width: newRect.size.width, height: (oldMaxY - newMaxY))
                removedHandler?(rectToRemove)
            }

            if oldMinY < newMinY {
                let rectToRemove: CGRect = CGRect(x: newRect.origin.x, y: oldMinY, width: newRect.size.width, height: (newMinY - oldMinY))
                removedHandler?(rectToRemove)
            }
        } else {
            addedHandler?(newRect)
            removedHandler?(oldRect)
        }
    }
}
