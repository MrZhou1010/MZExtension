//
//  NSObject+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// 对象名的className
    public var className: String {
        return type(of: self).className
    }
    
    /// 对象名的className
    public static var className: String {
        return String(describing: self)
    }
}
