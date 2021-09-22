//
//  UIColor+HexColor.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/12.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// init method with RGB values from 0 to 255, instead of 0 to 1. with alpha(default:1.0)
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    /// init method from gray value and alpha(default:1.0)
    public convenience init(gray: CGFloat, alpha: CGFloat = 1.0) {
        self.init(r: gray, g: gray, b: gray, a: alpha)
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
    
    /// create a dynamic color(light: a color in light mode,dark: a color in dark mode)
    public convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init {
                $0.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    /// return random UIColor with random alpha(default:false)
    public static func random(randomAlpha: Bool = false) -> UIColor {
        let randomRed = CGFloat.random()
        let randomGreen = CGFloat.random()
        let randomBlue = CGFloat.random()
        let alpha = randomAlpha ? CGFloat.random() : 1.0
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
    }
    
    /// return RGB values from 0 to 255, instead of 0 to 1. and alpha(default:1.0)
    public static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// return color from hex string and alpha(default:1.0)
    public static func color(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        if hex.isEmpty {
            return UIColor.clear
        }
        // 去掉特殊字符及大写
        var hHex = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        if hHex.count < 6 {
            return UIColor.clear
        }
        if hHex.hasPrefix("0X") {
            hHex = (hHex as NSString).substring(from: 2)
        }
        if hHex.hasPrefix("#") {
            hHex = (hHex as NSString).substring(from: 1)
        }
        // 开头是以##开始的
        if hHex.hasPrefix("##") {
            hHex = (hHex as NSString).substring(from: 2)
        }
        // 截取出来的有效长度是6位,所以不是6位的直接返回
        if hHex.count != 6 {
            return UIColor.clear
        }
        // R G B
        var range = NSMakeRange(0, 2)
        // R
        let rHex = (hHex as NSString).substring(with: range)
        // G
        range.location = 2
        let gHex = (hHex as NSString).substring(with: range)
        // B
        range.location = 4
        let bHex = (hHex as NSString).substring(with: range)
        // 类型转换
        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    /// return color from alpha
    public func alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
    
    /// return hex string from color
    public func toHexString() -> String {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format:"#%06x", rgb)
    }
}
