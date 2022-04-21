//
//  Dictionary+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/8/28.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import Foundation

extension Dictionary {
    
    /// 字典转json字符串
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
}
