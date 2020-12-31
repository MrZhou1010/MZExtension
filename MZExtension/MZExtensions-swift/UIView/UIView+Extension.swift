//
//  UIView+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension UIView {
    
    /// 视图所在的控制器
    public var viewController: UIViewController? {
        weak var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// 视图生成图片(截屏效果)
    public func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 设置圆角
    public func setCorner(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    /// 设置边框颜色及边框宽度
    public func setBorder(_ color: UIColor, width: CGFloat = 1.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    /// 设置某几个角的圆角
    public func setCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// 设置虚线
    public func addDashLine(_ strokeColor: UIColor, lineWidth: CGFloat = 1.0, lineDashPattern: [NSNumber]) {
        let borderLayer = CAShapeLayer()
        borderLayer.bounds = self.bounds
        borderLayer.anchorPoint = CGPoint(x: 0, y: 0)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = lineDashPattern
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
        borderLayer.path = path
        self.layer.addSublayer(borderLayer)
    }
    
    /// 设置点画线
    public func addDottedLine(_ strokeColor: UIColor, frame: CGRect, lineWidth: CGFloat = 1.0, lineDashPattern: [NSNumber]) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = strokeColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: 5, height: 5)).cgPath
        borderLayer.frame = frame
        borderLayer.lineWidth = lineWidth
        borderLayer.lineCap = CAShapeLayerLineCap.square
        borderLayer.lineDashPattern = lineDashPattern
        borderLayer.cornerRadius = 5
        self.layer.addSublayer(borderLayer)
    }
    
    /// 设置渐变颜色
    public func setGradientColor(_ colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        // 设置渐变的主颜色（可多个颜色添加）
        gradientLayer.colors = colors
        // startPoint与endPoint分别为渐变的起始方向与结束方向,它是以矩形的四个角为基础的,
        //（0,0）为左上角、（1,0）为右上角、（0,1）为左下角、（1,1）为右下角,默认是值是（0.5,0）和（0.5,1）
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        // 将gradientLayer作为子layer添加到主layer上
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 设置渐变颜色
    public func setGradientColor(_ colors: [CGColor], corner: CGFloat) {
        if self.layer.sublayers != nil && self.layer.sublayers!.count > 0 {
            self.layer.sublayers!.first?.removeFromSuperlayer()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = corner
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
