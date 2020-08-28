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
    
    /// base64编码
    public var base64: String {
        return self.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    /// 多语言
    public var localized: String {
        NSLocalizedString(self, comment: self)
    }
    
    /// 多语言
    public func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
    
    /// 删除前后空格和换行
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[self.startIndex..<end])
    }
    
    public subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[self.startIndex...end])
    }
    
    public subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
}
