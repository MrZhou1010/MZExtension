//
//  String+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    
    /// 字符串长度
    public var length: Int {
        return self.utf16.count
    }
    
    /// 网络URL
    public var url: URL? {
        return URL(string: self)
    }
    
    /// 转Int类型
    public var toInt: Int? {
        return Int(self)
    }
    
    /// 转Float类型
    public var toFloat: Float? {
        return Float(self)
    }
    
    /// 转Double类型
    public var toDouble: Double? {
        return Double(self)
    }
    
    /// base64编码
    public var base64: String {
        return self.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    /// range of all string
    public var range: NSRange {
        return NSRange(location: 0, length: self.count)
    }
    
    /// 多语言
    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    /// 多语言
    public func localized(with tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
    
    /// 删除前后空格和换行
    public func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 判断是否为汉字
    public func isChinese() -> Bool {
        if self == "" {
            return false
        }
        let chinese = "^[\\u4e00-\\u9fa5]{0,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", chinese)
        return predicate.evaluate(with: self)
    }
    
    /// 判断是否为链接地址
    public func isUrl() -> Bool {
        let pattern = "^((https|http)?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// 判断是否为手机号
    public func isMobilePhone() -> Bool {
        let pattern = "^1[3-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// 判断是否为车牌号
    public func isLicence() -> Bool {
        let pattern = "^[\\u4e00-\\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// 验证密码
    public func isPassword() -> Bool {
        let pattern = "^[a-zA-Z0-9]{6,20}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// 验证邮箱
    public func isEmail() -> Bool {
        let pattern = "[A-Z0-9a-z._% -] @[A-Za-z0-9.-] \\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    // 验证昵称
    func isNickName() -> Bool {
        let pattern = "^(?!_)(?!.*?_$)[a-zA-Z0-9_\\u4e00-\\u9fa5]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    // 验证用户名
    func isUserName() -> Bool {
        let pattern = "^[A-Za-z0-9]{6,20}+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    // 验证纯数字
    func isNumber() -> Bool {
        let pattern = "^[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// md5加密
    public func md5() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String).uppercased()
    }
    
    /// md5加密
    public func md5String() -> String {
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(Array(self.utf8), CC_LONG(self.count), result)
        let str = String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         result[0], result[1], result[2], result[3],
                         result[4], result[5], result[6], result[7],
                         result[8], result[9], result[10], result[11],
                         result[12], result[13], result[14], result[15])
        return str
    }
    
    /// 字符串尺寸
    public func size(with font: UIFont, size: CGSize, lineBreakMode: NSLineBreakMode? = nil) -> CGSize {
        var attr: [NSAttributedString.Key: Any] = [.font: font]
        if lineBreakMode != .byWordWrapping {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode ?? .byCharWrapping
            attr[.paragraphStyle] = paragraphStyle
        }
        let rect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attr, context: nil)
        return rect.size
    }
    
    /// 字符串宽度
    public func width(with font: UIFont) -> CGFloat {
        let size = self.size(with: font, size: CGSize(width: CGFloat(HUGE), height: CGFloat(HUGE)), lineBreakMode: .byWordWrapping)
        return size.width
    }
    
    /// 字符串高度
    public func height(with font: UIFont) -> CGFloat {
        let size = self.size(with: font, size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
        return size.height
    }
    
    /// json字符串转字典或者数组
    public func jsonStringDecoded() -> Any? {
        guard let data = self.data(using: .utf8), let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        return object
    }
    
    /// json字符串转字典
    public func toDict() -> [String: Any]? {
        guard let data = self.data(using: .utf8), let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
            return nil
        }
        return dict
    }
    
    /// return a formatter date from string
    public func date(format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.date(from: self) ?? Date()
    }
    
    public func indexOf(_ target: Character) -> Int? {
        #if swift(>=5.0)
        return self.firstIndex(of: target)?.utf16Offset(in: self)
        #else
        return self.firstIndex(of: target)?.encodedOffset
        #endif
    }
    
    public func subString(to: Int) -> String {
        #if swift(>=5.0)
        let endIndex = String.Index(utf16Offset: to, in: self)
        #else
        let endIndex = String.Index.init(encodedOffset: to)
        #endif
        let subStr = self[self.startIndex..<endIndex]
        return String(subStr)
    }
    
    public func subString(from: Int) -> String {
        #if swift(>=5.0)
        let startIndex = String.Index(utf16Offset: from, in: self)
        #else
        let startIndex = String.Index.init(encodedOffset: from)
        #endif
        let subStr = self[startIndex..<self.endIndex]
        return String(subStr)
    }
}

extension String {
    
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[self.startIndex..<end])
    }
    
    public subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = self.index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[self.startIndex...end])
    }
    
    public subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
}
