//
//  NSObject+Extension.swift
//  MZExtension
//
//  Created by 木木 on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import Foundation

extension NSObject {
    
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}
