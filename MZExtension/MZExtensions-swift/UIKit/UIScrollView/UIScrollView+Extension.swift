//
//  UIScrollView+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/18.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    public func scrollToTop(animated: Bool) {
        var offset = self.contentOffset
        offset.y = 0 - self.contentInset.top
        self.setContentOffset(offset, animated: animated)
    }
    
    public func scrollToLeft(animated: Bool) {
        var offset = self.contentOffset
        offset.x = 0 - self.contentInset.left
        self.setContentOffset(offset, animated: animated)
    }
    
    public func scrollToBottom(animated: Bool) {
        var offset = self.contentOffset
        offset.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
        self.setContentOffset(offset, animated: animated)
    }
    
    public func scrollToRight(animated: Bool) {
        var offset = self.contentOffset
        offset.x = self.contentSize.width - self.bounds.width + self.contentInset.right
        self.setContentOffset(offset, animated: animated)
    }
    
    public func scrollToTop() {
        self.scrollToTop(animated: true)
    }
    
    public func scrollToLeft() {
        self.scrollToLeft(animated: true)
    }
    
    public func scrollToBottom() {
        self.scrollToBottom(animated: true)
    }
    
    public func scrollToRight() {
        self.scrollToRight(animated: true)
    }
}
