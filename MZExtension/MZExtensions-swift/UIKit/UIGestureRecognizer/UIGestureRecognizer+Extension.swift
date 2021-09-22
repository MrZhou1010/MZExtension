//
//  UIGestureRecognizer+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/22.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

private var gestureRecognizerTargetKey: Void?

extension UIGestureRecognizer {
    
    /// 初始化一个闭包
    public convenience init(block: @escaping (_ sender: Any) -> ()) {
        self.init()
        self.addBlock(block: block)
    }
    
    /// 添加一个闭包
    public func addBlock(block: @escaping (_ sender: Any) -> ()) {
        let target = UIGestureRecognizerBlockTarget(attachTo: self, block: block)
        self.addTarget(target, action: #selector(UIGestureRecognizerBlockTarget.invoke(_:)))
        var targets = self.allGestureRecognizerBlockTargets()
        targets.append(target)
    }
    
    public func removeAllBlock() {
        var targets = self.allGestureRecognizerBlockTargets()
        for target in targets {
            self.removeTarget(target, action: #selector(UIGestureRecognizerBlockTarget.invoke(_:)))
        }
        targets.removeAll()
    }
    
    fileprivate func allGestureRecognizerBlockTargets() -> [UIGestureRecognizerBlockTarget] {
        guard var targets = objc_getAssociatedObject(self, &gestureRecognizerTargetKey) else {
            return []
        }
        targets = []
        objc_setAssociatedObject(self, &gestureRecognizerTargetKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return targets as! [UIGestureRecognizerBlockTarget]
    }
}

class UIGestureRecognizerBlockTarget {
    
    public var block: (_ sender: Any) -> ()
    
    init(attachTo: Any, block: @escaping (_ sender: Any) -> ()) {
        self.block = block
        objc_setAssociatedObject(attachTo, "[\(arc4random()).gestureRecognizer]", self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc public func invoke(_ sender: Any) {
        self.block(sender)
    }
}
