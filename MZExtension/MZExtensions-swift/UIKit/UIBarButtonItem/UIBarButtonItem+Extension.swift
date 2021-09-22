//
//  UIBarButtonItem+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/18.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

private var barButtomItemBlockKey: Void?

extension UIBarButtonItem {
    
    public var actionBlock: (_ sender: UIBarButtonItem) -> () {
        set {
            let target = UIBarButtonItemBlockTarget(attachTo: self, block: newValue)
            objc_setAssociatedObject(self, &barButtomItemBlockKey, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.target = target
            self.action = #selector(UIBarButtonItemBlockTarget.invoke(_:))
        }
        get {
            let target = objc_getAssociatedObject(self, &barButtomItemBlockKey) as? UIBarButtonItemBlockTarget
            return (target?.block)!
        }
    }
}

class UIBarButtonItemBlockTarget {
        
    public var block: (_ sender: UIBarButtonItem) -> ()
    
    init(attachTo: Any, block: @escaping (_ sender: UIBarButtonItem) -> ()) {
        self.block = block
        objc_setAssociatedObject(attachTo, "[\(arc4random()).barButtomItem]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc public func invoke(_ sender: UIBarButtonItem) {
        self.block(sender)
    }
}
