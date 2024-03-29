//
//  CGFloat+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/12.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension CGFloat {
    
    /// 中心值
    public var center: CGFloat {
        return (self / 2.0)
    }
    
    /// 将角度转换为弧度
    public func degreesToRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }
    
    /// 将角度转换为弧度
    static public func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (.pi * angle) / 180.0
    }
    
    /// 将弧度转换为角度
    public func radiansToDegrees() -> CGFloat {
        return (180.0 * self) / .pi
    }
    
    /// 将弧度转换为角度
    static public func radiansToDegrees(_ angleInDegrees: CGFloat) -> CGFloat {
        return (180.0 * angleInDegrees) / .pi
    }
    
    /// 随机浮点数(0.0~1.0)
    static public func random() -> CGFloat {
        return CGFloat(Double(arc4random()) / 0xFFFFFFFF)
    }
    
    /// 随机浮点数(min~max)
    static public func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
    
    /// 随机浮点数(min~max)
    static public func random(_ within: Range<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }
    
    /// 随机浮点数(min~max)
    static public func random(_ within: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }
}
