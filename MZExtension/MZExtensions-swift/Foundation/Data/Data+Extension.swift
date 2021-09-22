//
//  Data+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/8/28.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import Foundation

extension Data {
    
    /// 转字符串
    public func utf8String() -> String? {
        return self.count > 0 ? String(data: self, encoding: .utf8) : ""
    }
    
    /// json字符串转字典或者数组
    public func jsonStringDecoded() -> Any? {
        let object = try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed)
        return object
    }
}
