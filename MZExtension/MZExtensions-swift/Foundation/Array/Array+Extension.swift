//
//  Array+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/8/28.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import Foundation

extension Array {
    
    /// 枚举
    public func forEachEnumerated(_ body: @escaping (_ index: Int, _ element: Element) -> Void) {
        self.enumerated().forEach(body)
    }
    
    /// 数组是否包含某一个数据
    public func contains<T>(of element: T) -> Bool {
        let elementType = type(of: element)
        return self.contains {
            type(of: $0) == elementType
        }
    }
    
    /// 数组转json字符串
    public func toJson() -> String {
        if JSONSerialization.isValidJSONObject(self) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString ?? ""
            } catch {
                return "error_catch"
            }
        }
        return "error_valid_fail"
    }
    
    /// return a object located at a random index
    public func random() -> Any? {
        return self.count > 0 ? self[Int(arc4random_uniform(UInt32(self.count)))] : nil
    }
}
