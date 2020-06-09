//
//  UIButton+MZHit.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/5/9.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    /// 改进写法【推荐】
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer.init(bitPattern: "clickEdgeInsets".hashValue)
    }
    
    /// 需要扩充的点击边距
    public var mz_clickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
    }
    
    /// 重写系统方法修改点击区域
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        var bounds = self.bounds
        if self.mz_clickEdgeInsets != nil {
            let x: CGFloat = -(self.mz_clickEdgeInsets?.left ?? 0)
            let y: CGFloat = -(self.mz_clickEdgeInsets?.top ?? 0)
            let width: CGFloat = bounds.width + (self.mz_clickEdgeInsets?.left ?? 0) + (mz_clickEdgeInsets?.right ?? 0)
            let height: CGFloat = bounds.height + (self.mz_clickEdgeInsets?.top ?? 0) + (mz_clickEdgeInsets?.bottom ?? 0)
            bounds = CGRect(x: x, y: y, width: width, height: height)
        }
        return bounds.contains(point)
    }
}
