//
//  UIFont+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

public enum FontType: String {
    case none = ""
    case regular = "Regular"
    case bold = "Bold"
    case demiBold = "DemiBold"
    case light = "Light"
    case ultraLight = "UltraLight"
    case italic = "Italic"
    case thin = "Thin"
    case book = "Book"
    case roman = "Roman"
    case medium = "Medium"
    case mediumItalic = "MediumItalic"
    case condensedMedium = "CondensedMedium"
    case condensedExtraBold = "CondensedExtraBold"
    case semiBold = "SemiBold"
    case boldItalic = "BoldItalic"
    case heavy = "Heavy"
}

public enum FontName: String {
    case helveticaNeue = "HelveticaNeue"
    case helvetica = "Helvetica"
    case futura = "Futura"
    case menlo = "Menlo"
    case avenir = "Avenir"
    case avenirNext = "AvenirNext"
    case didot = "Didot"
    case americanTypewriter = "AmericanTypewriter"
    case baskerville = "Baskerville"
    case geneva = "Geneva"
    case gillSans = "GillSans"
    case sanFranciscoDisplay = "SanFranciscoDisplay"
    case seravek = "Seravek"
}

extension UIFont {
    
    /// 字体
    public class func font(_ name: FontName, type: FontType, size: CGFloat) -> UIFont {
        // use type
        let fontName = name.rawValue + "-" + type.rawValue
        if let font = UIFont(name: fontName, size: size) {
            return font
        }
        
        // that font doens't have that type,try .None
        let fontNameNone = name.rawValue
        if let font = UIFont(name: fontNameNone, size: size) {
            return font
        }
        
        // that font doens't have that type,try .Regular
        let fontNameRegular = name.rawValue + "-" + "Regular"
        if let font = UIFont(name: fontNameRegular, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
    
    /// return helveticaNeue font with FontType and size
    public class func helveticaNeue(type: FontType, size: CGFloat) -> UIFont {
        return self.font(.helveticaNeue, type: type, size: size)
    }
    
    /// return avenirNext font with FontType and size
    public class func avenirNext(type: FontType, size: CGFloat) -> UIFont {
        return self.font(.avenirNext, type: type, size: size)
    }
    
    /// return avenirNextDemiBold font with size
    public class func avenirNextDemiBold(size: CGFloat) -> UIFont {
        return self.font(.avenirNext, type: .demiBold, size: size)
    }
    
    /// return avenirNextRegular font with size
    public class func avenirNextRegular(size: CGFloat) -> UIFont {
        return self.font(.avenirNext, type: .regular, size: size)
    }
}
