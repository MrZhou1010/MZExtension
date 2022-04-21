//
//  NSObject+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import Foundation

private var objcetBlockKey: Void?

typealias MZKVOBlock = ((_ obj: Any?, _ oldVal: Any?, _ newVal: Any?) -> Void)

extension NSObject {
    
    /// 对象名的className
    public var className: String {
        return type(of: self).className
    }
    
    /// 对象名的className
    static public var className: String {
        return String(describing: self)
    }
    
    static public func swizzleInstanceMethod(originalSel: Selector, newSel: Selector) -> Bool {
        let orginalMethod = class_getInstanceMethod(self as AnyClass, originalSel)
        let newMethod = class_getInstanceMethod(self as AnyClass, newSel)
        if orginalMethod != nil || newMethod != nil {
            return false
        }
        class_addMethod(self as AnyClass, originalSel,
                        class_getInstanceMethod(self as AnyClass, originalSel)!,
                        method_getTypeEncoding(orginalMethod!))
        class_addMethod(self as AnyClass, newSel,
                        class_getInstanceMethod(self as AnyClass, newSel)!,
                        method_getTypeEncoding(newMethod!))
        method_exchangeImplementations(class_getInstanceMethod(self as AnyClass, originalSel)!,
                                       class_getInstanceMethod(self as AnyClass, newSel)!)
        return true
    }
    
    static public func swizzleClassMethod(originalSel: Selector, newSel: Selector) -> Bool {
        let _class: AnyClass = object_getClass(self)!
        let originalMethod = class_getInstanceMethod(_class, originalSel)
        let newMethod = class_getInstanceMethod(_class, newSel)
        if originalMethod == nil || newMethod == nil {
            return false
        }
        method_exchangeImplementations(originalMethod!, newMethod!)
        return true
    }
    
    // MARK: - KVO
    internal func addObserverBlock(forKeyPath keyPath: String, block: @escaping MZKVOBlock) {
        if keyPath == "" {
            return
        }
        let target = NSObjectKVOBlockTarget(with: block, attachTo: self)
        var dict = self.allNSObjectObserverBlocks
        var arr = dict[keyPath]
        if arr == nil {
            arr = []
            dict[keyPath] = arr
        }
        arr?.append(target)
        self.addObserver(target, forKeyPath: keyPath, options: [.new, .old], context: nil)
    }
    
    internal func removeObserverBlock(forKeyPath keyPath: String) {
        if keyPath == "" {
            return
        }
        var dict = self.allNSObjectObserverBlocks
        let arr = dict[keyPath] ?? []
        for item in arr {
            self.removeObserver(item, forKeyPath: keyPath)
        }
        dict.removeValue(forKey: keyPath)
    }
    
    internal func removeObserverBlocks() {
        var dict = self.allNSObjectObserverBlocks
        for (key, value) in dict {
            for item in value {
                self.removeObserver(item, forKeyPath: key)
            }
        }
        dict.removeAll()
    }
    
    private var allNSObjectObserverBlocks: [String: [NSObjectKVOBlockTarget]] {
        var targets = objc_getAssociatedObject(self, &objcetBlockKey) as? [String: [NSObjectKVOBlockTarget]]
        if targets == nil {
            targets = [String: [NSObjectKVOBlockTarget]]()
            objc_setAssociatedObject(self, &objcetBlockKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return targets!
    }
}

class NSObjectKVOBlockTarget: NSObject {
    
    public var block: MZKVOBlock?
    
    init(with block: @escaping MZKVOBlock, attachTo: AnyObject) {
        super.init()
        self.block = block
        objc_setAssociatedObject(attachTo, "[\(arc4random()).kvo]", self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.block == nil {
            return
        }
        if let _ = change?[.notificationIsPriorKey] as? Bool {
            return
        }
        if let _ = change?[.kindKey] as? NSKeyValueChange {
            return
        }
        let oldVal = change?[.oldKey]
        let newVal = change?[.newKey]
        self.block!(object, oldVal, newVal)
    }
}
