//
//  DispatchQueue+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/17.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    /// 延时
    public func after(time: Double, execute: @escaping () -> Void) {
        let deadline = DispatchTime.now() + time * Double(NSEC_PER_SEC) / Double(NSEC_PER_SEC)
        self.asyncAfter(deadline: deadline, execute: execute)
    }
}
