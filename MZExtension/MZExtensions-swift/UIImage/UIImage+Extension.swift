//
//  UIImage+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// return base64 string
    public var base64: String {
        return self.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
    }
    
    /// return compressed image to rate from 0.0 to 1.0
    public func compressImage(rate: CGFloat = 1.0) -> Data? {
        return self.jpegData(compressionQuality: rate)
    }
    
    /// return image size in Bytes
    public func getSizeAsBytes() -> Int {
        return self.jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    /// return image size in Kylobytes
    public func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = self.getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }
    
    /// scale image
    public func scaleImage(w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// return resized image with width. Might return low quality
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        self.scaleImage(w: width, h: self.aspectHeightForWidth(width))
    }
    
    /// return resized image with height. Might return low quality
    public func resizeWithHeight(_ height: CGFloat) -> UIImage {
        self.scaleImage(w: self.aspectWidthForHeight(height), h: height)
    }
    
    /// return image height with width
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    /// return image width with height
    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
    /// return cropped image from CGRect
    public func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            return nil
        }
        guard self.size.height > bound.origin.y else {
            return nil
        }
        let scaledBounds: CGRect = CGRect(x: bound.minX * self.scale, y: bound.minY * self.scale, width: bound.width * self.scale, height: bound.height * self.scale)
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: .up)
        return croppedImage
    }
    
    /// use current image for pattern of color
    public func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// return the image associated with the URL
    public convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.init(data: Data())
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            self.init(data: Data())
            return
        }
        self.init(data: data)
    }
    
    /// return an empty image
    public class func blankImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1.0, height: 1.0), false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// rounded image
    public func rounded(cornerRadius: CGFloat? = nil, borderWidth: CGFloat = 0.0, borderColor: UIColor = .white) -> UIImage {
        let diameter = min(self.size.width, self.size.height)
        let isLandscape = self.size.width > self.size.height
        let xOffset = isLandscape ? (self.size.width - diameter) / 2.0 : 0
        let yOffset = isLandscape ? 0 : (self.size.height - diameter) / 2.0
        let imageSize = CGSize(width: diameter, height: diameter)
        return UIGraphicsImageRenderer(size: imageSize).image { _ in
            let roundedPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: cornerRadius ?? diameter / 2.0)
            roundedPath.addClip()
            self.draw(at: CGPoint(x: -xOffset, y: -yOffset))
            if borderWidth > 0 {
                borderColor.setStroke()
                roundedPath.lineWidth = borderWidth
                roundedPath.stroke()
            }
        }
    }
    
    /// return the color of image at point
    public func pixelColor(at point: CGPoint) -> UIColor? {
        let size = self.cgImage.map { CGSize(width: $0.width, height: $0.height) } ?? self.size
        guard point.x >= 0, point.x < size.width, point.y >= 0, point.y < size.height,
            let data = self.cgImage?.dataProvider?.data,
            let pointer = CFDataGetBytePtr(data) else {
                return nil
        }
        let numberOfComponents = 4
        let pixelData = Int((size.width * point.y) + point.x) * numberOfComponents
        let r = CGFloat(pointer[pixelData]) / 255.0
        let g = CGFloat(pointer[pixelData + 1]) / 255.0
        let b = CGFloat(pointer[pixelData + 2]) / 255.0
        let a = CGFloat(pointer[pixelData + 3]) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
