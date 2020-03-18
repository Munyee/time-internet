//
//  PhotoGalleryView.swift
//  ApptivityFramework
//
//  Created by Li Theen Kok on 5/26/15.
//  Copyright (c) 2015 Apptivity Lab. All rights reserved.
//

import UIKit

@objc
public protocol PhotoGalleryDataSource: NSObjectProtocol {
    func numberOfMedias(in galleryView: PhotoGalleryView) -> Int
    func galleryView(_ galleryView: PhotoGalleryView, mediaViewAt index: Int) -> MediaView
}

@objc
public protocol PhotoGalleryDelegate: NSObjectProtocol {
    func galleryView(_ galleryView: PhotoGalleryView, willPageTo index: Int)
}

public class PhotoGalleryView: UIScrollView {

    fileprivate var currentIndex: Int = 0
    fileprivate var recycledViews: NSMutableSet = NSMutableSet()
    fileprivate var visibleViews: NSMutableSet = NSMutableSet()
    fileprivate var viewClassesMap: [String: AnyClass] = [:]
    fileprivate var viewNibsMap: [String: UINib] = [:]

    @IBOutlet public weak var galleryDataSource: PhotoGalleryDataSource!
    @IBOutlet public weak var galleryDelegate: PhotoGalleryDelegate?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    private func setup() {
        self.recycledViews = NSMutableSet()
        self.visibleViews = NSMutableSet()
        self.viewClassesMap = [:]
        self.viewNibsMap = [:]

        self.isPagingEnabled = true
        self.delegate = self

        self.indicatorStyle = UIScrollViewIndicatorStyle.white
        self.backgroundColor = UIColor.black
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateView()
    }

    public func registerClass(viewClass: AnyClass, forReuseIdentifier reuseIdentifier: String) {
        self.viewClassesMap[reuseIdentifier] = viewClass
    }

    public func registerNib(viewNib: UINib, forReuseIdentifier reuseIdentifier: String) {
        self.viewNibsMap[reuseIdentifier] = viewNib
    }

    public func dequeueReusableViewWithIdentifier(reuseIdentifier: String) -> MediaView {
        let view: MediaView
        if let mediaView = self.dequeueRecycledView(with: reuseIdentifier) {
            view = mediaView
        } else {
            view = self.newView(reuseIdentifier: reuseIdentifier)
        }

        return view
    }

    fileprivate func newView(reuseIdentifier: String) -> MediaView! {
        guard self.viewClassesMap.keys.contains(reuseIdentifier) else {
            assert(false, "No view class registered for reuseIdentifier: \(reuseIdentifier)")
            return nil
        }

        let view: MediaView
        if let viewNib: UINib = self.viewNibsMap[reuseIdentifier] {
            let topLevelObjects: [Any] = viewNib.instantiate(withOwner: nil, options: nil)
            assert(topLevelObjects.count == 1, "Custom MediaView nib should contain exactly one top level objects")
            assert(topLevelObjects.first is MediaView, "Custom MediaView nib top level object should be subclass of APTPhotoView or APTVideoView")

            view = topLevelObjects.first! as! MediaView
        } else {
            let viewClass: AnyClass = self.viewClassesMap[reuseIdentifier]!
            if viewClass === PhotoView.self {
                view = (viewClass as! PhotoView.Type).init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            } else {
                view = (viewClass as! VideoView.Type).init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            }
        }

        view.reuseIdentifier = reuseIdentifier
        return view
    }

    public func reloadData() {
        self.setContentOffset(CGPoint.zero, animated: true)

        self.recycledViews.removeAllObjects()
        self.visibleViews.removeAllObjects()

        for aView in self.subviews {
            aView.removeFromSuperview()
        }

        self.currentIndex = 0
        self.galleryDelegate?.galleryView(self, willPageTo: 0)
        self.updateView()
    }

    fileprivate func updateView() {
        let mediaCount: Int = self.galleryDataSource.numberOfMedias(in: self)
        self.contentSize = CGSize(width: CGFloat(mediaCount) * self.frame.size.width, height: 0)

        // First clean-up neccessary views
        let unnecessaryViews: NSMutableSet = NSMutableSet()
        for aView in self.subviews {
            if let mediaView: MediaView = aView as? MediaView, mediaView.index < self.currentIndex - 1 || mediaView.index > self.currentIndex + 1 {
                unnecessaryViews.add(aView)
                aView.removeFromSuperview()
            }
        }
        self.recycledViews.union(unnecessaryViews as Set<NSObject>)
        self.visibleViews.minus(unnecessaryViews as Set<NSObject>)

        // Then add necessary views
        for index: Int in max(self.currentIndex - 1, 0) ... min(self.currentIndex + 1, mediaCount - 1) {
            if !self.viewAtIndexIsVisible(index: index) {
                guard let mediaView = self.galleryDataSource.galleryView(self, mediaViewAt: index) as? UIView else {
                    continue
                }
                
                (mediaView as? MediaView)?.index = index
                mediaView.frame = CGRect(x: CGFloat(index) * self.frame.size.width, y: 0 - self.contentInset.top, width: self.frame.size.width, height: self.frame.size.height)
                
                self.visibleViews.add(mediaView)
                self.addSubview(mediaView)
            } else {
                let mediaView = self.viewAtIndex(index: index)
                (mediaView as? UIView)?.frame = CGRect(x: CGFloat(index) * self.frame.size.width, y: -self.contentInset.top, width: self.frame.size.width, height: self.frame.size.height)
            }
        }
    }

    fileprivate func viewAtIndexIsVisible(index: Int) -> Bool {
        if let visibleMediaViews: [MediaView] = self.visibleViews.allObjects as? [MediaView] {
            for aView: MediaView in visibleMediaViews {
                if aView.index == index {
                    return true
                }
            }
        }

        return false
    }

    fileprivate func viewAtIndex(index: Int) -> MediaView? {
        if let visibleMediaViews: [MediaView] = self.visibleViews.allObjects as? [MediaView] {
            for aView: MediaView in visibleMediaViews {
                if aView.index == index {
                    return aView
                }
            }
        }

        return nil
    }
    
    fileprivate func dequeueRecycledView(with reuseIdentifier: String) -> MediaView? {
        guard let mediaView = self.recycledViews.first(where: {
            return ($0 as? MediaView)?.reuseIdentifier == reuseIdentifier
        }) else {
            return nil
        }
        
        self.recycledViews.remove(mediaView)
        return mediaView as? MediaView
    }
}

extension PhotoGalleryView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index: Int = Int(round(scrollView.contentOffset.x / self.frame.size.width))
        if self.currentIndex != index {
            self.viewAtIndex(index: self.currentIndex)?.prepareForReuse()
            self.currentIndex = index
            self.galleryDelegate?.galleryView(self, willPageTo: index)
            self.updateView()
        }
    }
}
