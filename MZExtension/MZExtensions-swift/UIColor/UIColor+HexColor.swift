//
//  UIColor+HexColor.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/12.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1.0)
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// init method with hex string and alpha(default:1.0)
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var formatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        formatted = formatted.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init()
        }
    }
    
    /// init method from gray value and alpha(default:1.0)
    public convenience init(gray: CGFloat, alpha: CGFloat = 1.0) {
        self.init(r: gray, g: gray, b: gray, a: alpha)
    }
    
    /// return random UIColor with random alpha(default:false)
    public class func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
    /// return hex string with UIColor
    public func colorToHexString() -> String {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format:"#%06x", rgb)
    }
}
