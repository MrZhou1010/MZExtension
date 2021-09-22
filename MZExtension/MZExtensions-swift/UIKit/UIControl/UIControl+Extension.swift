//
//  UIControl+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/18.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

private var controllBlockKey: Void?

extension UIControl {
    
    /// 添加一个闭包
    public func addBlock(for events: UIControl.Event, block: @escaping (_ sender: Any) -> ()) {
        let target = UIControllBlockTarget(attachTo: self, block: block, events: events)
        self.addTarget(target, action: #selector(UIControllBlockTarget.invoke(_:)), for: events)
        objc_setAssociatedObject(self, "[\(arc4random()).control]", target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        var targets = self.allControlBlockTargets()
        targets.append(target)
    }
    
    /// 设置一个闭包
    public func setBlock(for events: UIControl.Event, block: @escaping (_ sender: Any) -> ()) {
        self.addBlock(for: events, block: block)
    }
    
    public func setTarget(_ target: Any, action: Selector, for controlEvents: UIControl.Event) {
        for currrentTarget in self.allTargets {
            guard let actions = self.actions(forTarget: currrentTarget, forControlEvent: controlEvents) else {
                return
            }
            for currentAction in actions {
                self.removeTarget(currrentTarget, action: NSSelectorFromString(currentAction), for: controlEvents)
            }
        }
        self.addTarget(target, action: action, for: controlEvents)
    }
    
    public func removeAllBlock(for events: UIControl.Event) {
        let targets = self.allControlBlockTargets()
        var removes = Array<UIControllBlockTarget>()
        for target in targets {
            guard let newEvent = target.events else {
                self.removeTarget(target, action: #selector(UIControllBlockTarget.invoke(_:)), for: target.events)
                removes.append(target)
                return
            }
            self.removeTarget(target, action: #selector(UIControllBlockTarget.invoke(_:)), for: target.events)
            target.events = newEvent
            self.addTarget(target, action: #selector(UIControllBlockTarget.invoke(_:)), for: target.events)
        }
    }
    
    public func removeAllTarget() {
        for target in self.allTargets {
            self.removeTarget(target, action: nil, for: .allEvents)
        }
        var targets = self.allControlBlockTargets()
        targets.removeAll()
    }
    
    fileprivate func allControlBlockTargets() -> Array<UIControllBlockTarget> {
        var targets = objc_getAssociatedObject(self, &controllBlockKey) as? Array<UIControllBlockTarget>
        if targets == nil {
            targets = []
            objc_setAssociatedObject(self, &controllBlockKey, targets, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return targets!
    }
}

class UIControllBlockTarget {
    
    public var block: (_ sender: Any) -> ()
    
    public var events: UIControl.Event!
    
    init(attachTo: AnyObject, block: @escaping (_ sender: Any) -> (), events: UIControl.Event) {
        self.block = block
        self.events = events
        // 避免被提前释放
        // objc_setAssociatedObject(attachTo, "[\(arc4random()).control]", self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc public func invoke(_ sender: Any) {
        self.block(sender)
    }
}
