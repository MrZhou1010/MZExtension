//
//  UIImage+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 图片转换成为base64字符串
    public var base64: String {
        return self.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
    }
    
    /// 压缩图片
    public func compressImage(_ rate: CGFloat = 1.0) -> Data? {
        return self.jpegData(compressionQuality: rate)
    }
    
    /// 图片压缩
    public func compressImage(maxLength: Int) -> UIImage {
        let tempMaxLength: Int = maxLength / 8
        var compression: CGFloat = 1.0
        guard var data = self.jpegData(compressionQuality: compression), data.count > tempMaxLength else {
            return self
        }
        // 压缩大小
        var max: CGFloat = 1.0
        var min: CGFloat = 0.0
        for _ in 0 ..< 6 {
            compression = (max + min) * 0.5
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(tempMaxLength) * 0.9 {
                min = compression
            } else if data.count > tempMaxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < tempMaxLength {
            return resultImage
        }
        // 压缩大小
        var lastDataLength: Int = 0
        while data.count > tempMaxLength && data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(tempMaxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)), height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width:size.width , height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return resultImage
    }
    
    /// 图片的大小(byte)
    public func getSizeAsBytes() -> Int {
        return self.jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    /// 图片的大小(kb)
    public func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = self.getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }
    
    /// 改变图片的尺寸
    public func scaleImage(_ width: CGFloat, _ height: CGFloat) -> UIImage {
        let newSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    /// 根据宽度改变图片的尺寸
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        self.scaleImage(width, self.aspectHeightForWidth(width))
    }
    
    /// 根据高度改变图片的尺寸
    public func resizeWithHeight(_ height: CGFloat) -> UIImage {
        self.scaleImage(self.aspectWidthForHeight(height), height)
    }
    
    /// 根据宽度获取图片的高度
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    /// 根据高度获取图片的宽度
    public func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
    /// 剪裁图片
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
    
    /// 用颜色填充图片
    public func imageWithColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!)
        context?.setFillColor(tintColor.cgColor)
        context?.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    /// 根据地址获取图片
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
    
    /// check if has alpha
    public func hasAlphaChannel() -> Bool {
        if self.cgImage == nil {
            return false
        }
        let alpha = self.cgImage?.alphaInfo
        return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
    }
    
    /// 返回空白的图片
    public class func blankImage(width: CGFloat = 1.0, height: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 根据颜色生成图片
    public class func image(with color: UIColor) -> UIImage? {
        return self.image(with: color, size: CGSize(width: 1.0, height: 1.0))
    }
    
    /// 根据颜色生成图片
    public class func image(with color: UIColor, size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 设置圆角图片
    public func rounded(cornerRadius: CGFloat? = nil, borderWidth: CGFloat = 0.0, borderColor: UIColor = UIColor.white) -> UIImage {
        let diameter = min(self.size.width, self.size.height)
        let isLandscape = self.size.width > self.size.height
        let xOffset = isLandscape ? (self.size.width - diameter) * 0.5 : 0
        let yOffset = isLandscape ? 0 : (self.size.height - diameter) * 0.5
        let imageSize = CGSize(width: diameter, height: diameter)
        if #available(iOS 10.0, *) {
            return UIGraphicsImageRenderer(size: imageSize).image { _ in
                let roundedPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: cornerRadius ?? diameter * 0.5)
                roundedPath.addClip()
                self.draw(at: CGPoint(x: -xOffset, y: -yOffset))
                if borderWidth > 0 {
                    borderColor.setStroke()
                    roundedPath.lineWidth = borderWidth
                    roundedPath.stroke()
                }
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            let roundedPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: imageSize), cornerRadius: cornerRadius ?? diameter * 0.5)
            roundedPath.addClip()
            self.draw(at: CGPoint(x: -xOffset, y: -yOffset))
            if borderWidth > 0 {
                borderColor.setStroke()
                roundedPath.lineWidth = borderWidth
                roundedPath.stroke()
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }
    }
    
    /// 获取图片某一个位置像素的颜色
    public func pixelColor(_ point: CGPoint) -> UIColor? {
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
    
    public class func gif(data: Data) -> UIImage? {
        // create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return UIImage.animatedImage(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // validate URL
        guard let bundleURL = URL(string: url) else {
            return nil
        }
        // validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // check for existance of gif
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            return nil
        }
        // validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            return nil
        }
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            return nil
        }
        return gif(data: dataAsset.data)
    }
    
    internal class func animatedImage(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        // fill arrays
        for index in 0 ..< count {
            // add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            // at it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index), source: source)
            // seconds to ms
            delays.append(Int(delaySeconds * 1000.0))
        }
        // calculate full duration
        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()
        // get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for index in 0 ..< count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        return animation
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        // swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        // get greatest common divisor
        var res: Int
        while true {
            res = lhs! % rhs!
            if res == 0 {
                // found it
                return rhs!
            } else {
                lhs = rhs
                rhs = res
            }
        }
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        // get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        // get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            // make sure they're not too fast
            delay = 0.1
        }
        return delay
    }
    
    /// 将内容生成二维码
    public static func generateCode(message: String, logo: UIImage? = nil) -> UIImage {
        // 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 恢复默认设置
        filter?.setDefaults()
        // 设置生成的二维码的容错率("L/M/Q/H")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        // 设置输入的内容(KVC)
        let inputData = message.data(using: .utf8)
        filter?.setValue(inputData, forKey: "inputMessage")
        // 获取输出的图片
        guard let outputImage = filter?.outputImage else {
            return UIImage()
        }
        // 获取高清图片
        let hdImage = UIImage.getHDImage(outputImage)
        return logo == nil ? hdImage : UIImage.getResultImage(hdImage: hdImage, logo: logo!)
    }
    
    /// 获取高清图片
    fileprivate static func getHDImage(_ outImage: CIImage) -> UIImage {
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        // 放大图片
        let ciImage = outImage.transformed(by: transform)
        return UIImage(ciImage: ciImage)
    }
    
    /// 获取带前景logo的图片
    fileprivate static func getResultImage(hdImage: UIImage, logo: UIImage) -> UIImage {
        let hdSize = hdImage.size
        // 开启图形上下文
        UIGraphicsBeginImageContext(hdSize)
        // 将高清图片画到上下文
        hdImage.draw(in: CGRect(x: 0, y: 0, width: hdSize.width, height: hdSize.height))
        // 将前景图片画到上下文
        let logoSize = logo.size
        logo.draw(in: CGRect(x: (hdSize.width - logoSize.width) * 0.5, y: (hdSize.height - logoSize.height) * 0.5, width: logoSize.width, height: logoSize.height))
        // 获取上下文
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        // 5.关闭上下文
        UIGraphicsEndImageContext()
        return resultImage
    }
}
