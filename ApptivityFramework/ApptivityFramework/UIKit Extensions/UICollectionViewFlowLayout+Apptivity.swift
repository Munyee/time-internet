//
//  UICollectionViewFlowLayout+Apptivity.swift
//  ApptivityFramework
//
//  Created by Li Theen Kok on 25/01/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit

public extension UICollectionViewFlowLayout {
    func itemSize(forColumnCount columnCount: Int, fittingWidth maxWidth: CGFloat, widthToHeightRatio ratio: CGFloat = 1) -> CGSize {
        let totalSpacing = self.sectionInset.left + self.sectionInset.right + ((CGFloat(columnCount) - 1) * self.minimumInteritemSpacing)
        let itemWidth = (maxWidth - totalSpacing) / CGFloat(columnCount)
        return CGSize(width: floor(itemWidth), height: floor(ratio * itemWidth))
    }

    func setItemSize(forColumnCount columnCount: Int, fittingWidth maxWidth: CGFloat, widthToHeightRatio ratio: CGFloat = 1) {
        self.itemSize = self.itemSize(forColumnCount: columnCount, fittingWidth: maxWidth, widthToHeightRatio: ratio)
    }
}
