//
//  Double+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/8/28.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import Foundation

extension Double {
    
    /// 四舍五入到小数点后某一位
    public func roundTo(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// 截断到小数点后某一位
    public func truncate(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(self * divisor)) / divisor
    }
    
    /// random double point number between 0.0 and 1.0, inclusive
    static public var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// random double between min and max
    /// - Parameters:
    ///   - min: min
    ///   - max: max
    /// - Returns: Returns a random double point number between min and max
    static public func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}

extension Float {
    
    /// random float point number between 0.0 and 1.0, inclusive
    static public var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// random float between min and max
    /// - Parameters:
    ///   - min: min
    ///   - max: max
    /// - Returns: Returns a random float point number between min and max
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

extension Int {
    
    /// random integer between 0 and Int.max
    static public var random: Int {
        return Int.random(max: Int.max)
    }
    
    /// random integer between min and max
    /// - Parameters:
    ///   - min: min
    ///   - max: max
    /// - Returns: Returns a random integer point number between min and n max
    static public func random(min: Int, max: Int) -> Int {
        return Int.random(max: max - min + 1) + min
    }
    
    /// random integer between 0 and n-1
    /// - Parameter max: max
    /// - Returns: Returns a random integer point number between 0 and n max
    static public func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
}
