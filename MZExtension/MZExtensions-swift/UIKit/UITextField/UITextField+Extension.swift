//
//  UITextField+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/18.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

extension UITextField {
    
    public func selectedAllText() {
        let range = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument)
        self.selectedTextRange = range
    }
    
    public func selectedText(range: NSRange) {
        let beginning = self.beginningOfDocument
        let startPosition = self.position(from: beginning, offset: range.location)
        let endPosition = self.position(from: beginning, offset: NSMaxRange(range))
        let selectedRange = self.textRange(from: startPosition!, to: endPosition!)
        self.selectedTextRange = selectedRange
    }
}
