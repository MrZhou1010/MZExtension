//
//  UIFont+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

import UIKit

public enum FontType: String {
    case None = ""
    case Regular = "Regular"
    case Bold = "Bold"
    case DemiBold = "DemiBold"
    case Light = "Light"
    case UltraLight = "UltraLight"
    case Italic = "Italic"
    case Thin = "Thin"
    case Book = "Book"
    case Roman = "Roman"
    case Medium = "Medium"
    case MediumItalic = "MediumItalic"
    case CondensedMedium = "CondensedMedium"
    case CondensedExtraBold = "CondensedExtraBold"
    case SemiBold = "SemiBold"
    case BoldItalic = "BoldItalic"
    case Heavy = "Heavy"
}

public enum FontName: String {
    case HelveticaNeue
    case Helvetica
    case Futura
    case Menlo
    case Avenir
    case AvenirNext
    case Didot
    case AmericanTypewriter
    case Baskerville
    case Geneva
    case GillSans
    case SanFranciscoDisplay
    case Seravek
}

extension UIFont {
    
    /// return font with FontName、FontType and size
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
        return self.font(.HelveticaNeue, type: type, size: size)
    }
    
    /// return avenirNext font with FontType and size
    public class func avenirNext(type: FontType, size: CGFloat) -> UIFont {
        return self.font(.AvenirNext, type: type, size: size)
    }
    
    /// return avenirNextDemiBold font with size
    public class func avenirNextDemiBold(size: CGFloat) -> UIFont {
        return self.font(.AvenirNext, type: .DemiBold, size: size)
    }
    
    /// return avenirNextRegular font with size
    public class func avenirNextRegular(size: CGFloat) -> UIFont {
        return self.font(.AvenirNext, type: .Regular, size: size)
    }
}
