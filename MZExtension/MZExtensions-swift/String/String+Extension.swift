//
//  String+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension String {
    
    /// 字符串长度
    public var length: Int {
        return self.count
    }
    
    /// 网络URL
    public var url: URL? {
        URL(string: self)
    }
    
    /// 多语言
    public var localized: String {
        NSLocalizedString(self, comment: self)
    }
    
    public func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
}

