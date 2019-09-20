//
//  HorizontalPagingScrollView.swift
//  ApptivityFramework
//
//  Created by Jason Khong on 10/27/16.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

open class HorizontalPagingScrollView: UIScrollView {
    open var currentPage: Int {
        return Int(self.contentOffset.x / self.frame.width)
    }
    
    open var numberOfPages: Int {
        return Int(self.contentSize.width / self.frame.width)
    }
    
    private func frameForPage(atIndex index: Int) -> CGRect {
        var rect = self.frame
        
        let targetPage: Int =  max(min(index, self.numberOfPages), 0)
        rect.origin.x = rect.width * CGFloat(targetPage)
        
        return rect
    }

    open func scrollToPage(atIndex index: Int, animated: Bool = true) {
        scrollRectToVisible(frameForPage(atIndex: index), animated: animated)
    }

    open func scrollToNextPage(animated: Bool = true, looping: Bool = false) {
        if currentPage < numberOfPages {
            self.scrollToPage(atIndex: currentPage + 1, animated: animated)
        } else if looping {
            self.scrollToPage(atIndex: 0, animated: animated)
        }
    }

    open func scrollToPreviousPage(animated: Bool = true, looping: Bool = false) {
        if currentPage > 0 {
            self.scrollToPage(atIndex: currentPage - 1, animated: animated)
        } else if looping {
            self.scrollToPage(atIndex: 0, animated: animated)
        }
    }

}
