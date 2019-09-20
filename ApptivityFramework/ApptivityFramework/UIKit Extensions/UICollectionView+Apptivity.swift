//
//  UICollectionView+Apptivity.swift
//  ApptivityFramework
//
//  Created by Avery Choke Kar Sing on 06/01/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    // Work best for full screen UICollectionView
    public var indexPathForVisibleFullScreenItem: IndexPath? {
        let visibleRect: CGRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
        let visiblePoint: CGPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath: IndexPath? = self.indexPathForItem(at: visiblePoint)
        return indexPath
    }
    
}
