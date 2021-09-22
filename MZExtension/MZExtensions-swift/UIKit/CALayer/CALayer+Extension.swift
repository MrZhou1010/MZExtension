//
//  CALayer+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/18.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

extension CALayer {
    
    /// 左
    public var left: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    /// 上
    public var top: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    /// 右
    public var right: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    /// 下
    public var bottom: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    /// 宽
    public var width: CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    /// 高
    public var height: CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    /// 中心点x
    public var centerX: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width * 0.5
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width * 0.5
        }
    }
    
    /// 中心点y
    public var centerY: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height * 0.5
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height * 0.5
        }
    }
    
    /// 位置
    public var origin: CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
    
    /// 尺寸
    public var size: CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    /// 移除所有子layer
    public func removeAllSublayers() {
        guard let sublayers = self.sublayers else {
            return
        }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
    }
    
    /// 设置圆角
    public func setCornerRadius(_ radius: CGFloat, corners: UIRectCorner) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.mask = shapeLayer
    }
    
    /// 设置阴影
    public func setShadow(color: UIColor, offset: CGSize, radius: CGFloat) {
        self.shadowColor = color.cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = 1.0
        self.shouldRasterize = true
        self.rasterizationScale = UIScreen.main.scale
    }
    
    /// 添加fade动画
    public func addFadeAnimation(with duration: TimeInterval, curve: UIView.AnimationCurve) {
        guard duration > 0 else {
            return
        }
        var mediaFunction: CAMediaTimingFunctionName = .default
        switch curve {
        case .easeInOut:
            mediaFunction = CAMediaTimingFunctionName.easeInEaseOut
        case .easeIn:
            mediaFunction = CAMediaTimingFunctionName.easeIn
        case .easeOut:
            mediaFunction = CAMediaTimingFunctionName.easeOut
        case .linear:
            mediaFunction = CAMediaTimingFunctionName.linear
        default:
            break
        }
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: mediaFunction)
        transition.type = CATransitionType.fade
        self.add(transition, forKey: "fadeAnimation")
    }
    
    /// 移除fade动画
    public func removeFadeAnimation() {
        self.removeAnimation(forKey: "fadeAnimation")
    }
    
    /// return a line layer
    public static func layer(with size: CGSize, color: UIColor) -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.backgroundColor = color.cgColor
        return layer
    }
    
    /// return a image layer
    public static func layer(with image: UIImage) -> CALayer {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        layer.contents = image.cgImage
        return layer
    }
}

extension CATextLayer {
    
    /// retuan a text layer
    public static func layer(with text: String, mode: CATextLayerAlignmentMode, font: UIFont) -> CATextLayer {
        let layer = CATextLayer()
        layer.string = text
        layer.alignmentMode = mode
        layer.foregroundColor = UIColor.darkText.cgColor
        layer.contentsScale = UIScreen.main.scale
        layer.isWrapped = true
        let fontRef = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        layer.font = fontRef
        layer.fontSize = font.pointSize
        return layer
    }
}
