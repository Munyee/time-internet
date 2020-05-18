//
//  CarouselCollectionView.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/27/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

/// Auto-scrolling collection view
/// - Todo
///   - Timer should stop firing if view is not visible
public class CarouselCollectionView: UICollectionView {
    @IBInspectable var scrollInterval: CGFloat = 0 {
        didSet {
            setupTimer()
        }
    }

//    @IBInspectable var showPageIndicator: Bool = false
    @IBInspectable var loop: Bool = true
    @IBInspectable var scrollByItem: Bool = false

    var autoscrollTimer: Timer!

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTimer()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupTimer()
    }
    
    private func setupTimer() {
        if let timer = autoscrollTimer {
            timer.invalidate()
        }

        guard scrollInterval > 0 else {
            return
        }

        if self.scrollByItem {
            self.autoscrollTimer = Timer.scheduledTimer(timeInterval: TimeInterval(scrollInterval), target: self, selector: #selector(CarouselCollectionView.scrollForwardByItem), userInfo: nil, repeats: true)
            return
        }

        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            if layout.scrollDirection == .horizontal {
                self.startAutoScrolling()
            }
        }
    }

    public func stopAutoScrolling() {
        if let timer = self.autoscrollTimer {
            timer.invalidate()
        }
    }

    public func startAutoScrolling() {
        self.autoscrollTimer = Timer.scheduledTimer(timeInterval: TimeInterval(scrollInterval), target: self, selector: #selector(CarouselCollectionView.scrollForwardHorizontally), userInfo: nil, repeats: true)
    }

    @objc private func scrollForwardHorizontally() {
        let nextContentOffset = self.contentOffset.x + 1
        let maxHorizontalScrollOffset = (self.contentSize.width + self.contentInset.right) - self.contentOffset.x
        var targetXOffset = min(nextContentOffset, maxHorizontalScrollOffset)
        if targetXOffset >= maxHorizontalScrollOffset {
            if self.loop {
                targetXOffset = -self.contentInset.left
            } else {
                self.stopAutoScrolling()
                return
            }
        }

        self.contentOffset = CGPoint(x: targetXOffset, y: 0)
    }

    @objc private func scrollForwardByItem() {
        let visibleIndexPaths: [IndexPath] = self.indexPathsForVisibleItems

        if visibleIndexPaths.count == 0 {
            return
        }

        var targetIndex: Int = 0

        if visibleIndexPaths.count > 1 {
            targetIndex = (visibleIndexPaths.count / 2)
        }
        
        var targetIndexPath = visibleIndexPaths[targetIndex]
        targetIndexPath.item = targetIndexPath.item + 1
        
        if (dataSource?.collectionView(self, numberOfItemsInSection: targetIndexPath.section) ?? 0) == targetIndexPath.item {
            if self.loop {
                targetIndexPath.item = 0
            } else {
                self.stopAutoScrolling()
                return
            }
        }

        self.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    
}
