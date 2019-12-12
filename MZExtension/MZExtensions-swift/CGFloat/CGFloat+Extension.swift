//
//  CGFloat+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/12.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension CGFloat {
    
    /// return the central value of CGFloat
    public var center: CGFloat {
        return (self / 2.0)
    }
    
    /// converts angle degrees to radians
    public func degreesToRadians() -> CGFloat {
        return (.pi * self) / 180.0
    }
    
    /// converts angle degrees to radians static version
    public static func degreesToRadians(_ angle: CGFloat) -> CGFloat {
        return (.pi * angle) / 180.0
    }
    
    /// converts radians to degrees
    public func radiansToDegrees() -> CGFloat {
        return (180.0 * self) / .pi
    }
    
    /// converts angle radians to degrees static version
    public static func radiansToDegrees(_ angleInDegrees: CGFloat) -> CGFloat {
        return (180.0 * angleInDegrees) / .pi
    }
    
    /// return a random floating point number between 0.0 and 1.0, inclusive
    public static func random() -> CGFloat {
        return CGFloat(Double(arc4random()) / 0xFFFFFFFF)
    }
    
    /// return a random floating point number in the range min...max, inclusive
    public static func random(within: Range<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }
    
    /// return a random floating point number in the range min...max, inclusive
    public static func random(within: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.random() * (within.upperBound - within.lowerBound) + within.lowerBound
    }
}
