//
//  NSMutableAttributedString+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/16.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    public func setAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange? = nil) {
        if NSNull.isEqual(name) {
            return
        }
        let _range = range ?? NSMakeRange(0, self.length)
        if NSNull.isEqual(value) {
            self.removeAttribute(name, range: _range)
        } else {
            self.addAttribute(name, value: value, range: _range)
        }
    }
    
    public func removeAttributes(_ range: NSRange) {
        self.setAttributes(nil, range: range)
    }
    
    public func setFont(_ font: UIFont, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.font, value: font, range: _range)
    }
    
    public func setColor(_ color: UIColor, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.foregroundColor, value: color, range: _range)
    }
    
    public func setBackgroundColor(_ color: UIColor, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.backgroundColor, value: color, range: _range)
    }
    
    public func setShadow(_ shadow: NSShadow, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.shadow, value: shadow, range: _range)
    }
    
    public func setUnderlineStyle(_ underline: NSUnderlineStyle, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.underlineStyle, value: NSNumber(value: underline.rawValue), range: _range)
    }
    
    public func setUnderlineColor(_ color: UIColor, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.underlineColor, value: color, range: _range)
    }
    
    public func setStrikethroughStyle(range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: _range)
    }
    
    public func setStrikethroughColor(_ color: UIColor, range: NSRange? = nil) {
        let _range = range ?? NSMakeRange(0, self.length)
        self.setAttribute(.strikethroughColor, value: color, range: _range)
    }
    
    public func setLineSpacing(_ spacing: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        self.setAttribute(.paragraphStyle, value: style)
    }
}
