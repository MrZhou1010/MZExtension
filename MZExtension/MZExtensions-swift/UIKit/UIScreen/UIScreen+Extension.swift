//
//  UIScreen+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2021/9/22.
//  Copyright © 2021 Mr.Z. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static public var mainScale: CGFloat {
        return UIScreen.main.scale
    }
    
    public var currentBounds: CGRect {
        return self.bounds(for: UIApplication.shared.statusBarOrientation)
    }
    
    public func bounds(for orientation: UIInterfaceOrientation) -> CGRect {
        var bounds = self.bounds
        if orientation.isLandscape {
            let buffer = bounds.size.width
            bounds.size.width = bounds.size.height
            bounds.size.height = buffer
        }
        return bounds
    }
    
    public var sizeInPixel: CGSize {
        var size = CGSize.zero
        if UIScreen.main.isEqual(self) {
            let model = UIDevice.current.machineModel
            if model.hasPrefix("iPhone") {
                if model.hasPrefix("iPhone1") {
                    size = CGSize(width: 320, height: 480)
                } else if model.hasPrefix("iPhone2") {
                    size = CGSize(width: 320, height: 480)
                } else if model.hasPrefix("iPhone3") {
                    size = CGSize(width: 640, height: 960)
                } else if model.hasPrefix("iPhone4") {
                    size = CGSize(width: 640, height: 960)
                } else if model.hasPrefix("iPhone5") {
                    size = CGSize(width: 640, height: 1136)
                } else if model.hasPrefix("iPhone6") {
                    size = CGSize(width: 640, height: 1136)
                } else if model.hasPrefix("iPhone7,1") {
                    size = CGSize(width: 1080, height: 1920)
                } else if model.hasPrefix("iPhone7,2") {
                    size = CGSize(width: 750, height: 1334)
                } else if model.hasPrefix("iPhone8,1") {
                    size = CGSize(width: 1080, height: 1920)
                } else if model.hasPrefix("iPhone8,2") {
                    size = CGSize(width: 750, height: 1334)
                } else if model.hasPrefix("iPhone8,4") {
                    size = CGSize(width: 640, height: 1136)
                } else if model.hasPrefix("iPhone9,1") {
                    size = CGSize(width: 750, height: 1334)
                } else if model.hasPrefix("iPhone9,3") {
                    size = CGSize(width: 750, height: 1334)
                } else if model.hasPrefix("iPhone9,2") {
                    size = CGSize(width: 1080, height: 1920)
                } else if model.hasPrefix("iPhone9,4") {
                    size = CGSize(width: 1080, height: 1920)
                } else if model.hasPrefix("iPhone10,1") {
                    size = CGSize(width: 750, height: 1334)
                } else if model.hasPrefix("iPhone10,4") {
                    size = CGSize(width: 750, height: 1334)
                } else if model.hasPrefix("iPhone10,2") {
                    size = CGSize(width: 1080, height: 1920)
                } else if model.hasPrefix("iPhone10,5") {
                    size = CGSize(width: 1080, height: 1920)
                } else if model.hasPrefix("iPhone10,3") {
                    size = CGSize(width: 1125, height: 2436)
                } else if model.hasPrefix("iPhone10,6") {
                    size = CGSize(width: 1125, height: 2436)
                }
            } else if model.hasPrefix("iPod") {
                if model.hasPrefix("iPod1") {
                    size = CGSize(width: 320, height: 480)
                } else if model.hasPrefix("iPod2") {
                    size = CGSize(width: 320, height: 480)
                } else if model.hasPrefix("iPod3") {
                    size = CGSize(width: 320, height: 480)
                } else if model.hasPrefix("iPod4") {
                    size = CGSize(width: 640, height: 960)
                } else if model.hasPrefix("iPod5") {
                    size = CGSize(width: 640, height: 1136)
                } else if model.hasPrefix("iPod7") {
                    size = CGSize(width: 640, height: 1136)
                }
            } else if model.hasPrefix("iPad") {
                if model.hasPrefix("iPad1") {
                    size = CGSize(width: 768, height: 1024)
                } else if model.hasPrefix("iPad2") {
                    size = CGSize(width: 768, height: 1024)
                } else if model.hasPrefix("iPad3") {
                    size = CGSize(width: 1536, height: 2048)
                } else if model.hasPrefix("iPad4") {
                    size = CGSize(width: 1536, height: 2048)
                } else if model.hasPrefix("iPad5") {
                    size = CGSize(width: 1536, height: 2048)
                } else if model.hasPrefix("iPad6,3") {
                    size = CGSize(width: 1536, height: 2048)
                } else if model.hasPrefix("iPad6,4") {
                    size = CGSize(width: 1536, height: 2048)
                } else if model.hasPrefix("iPad6,7") {
                    size = CGSize(width: 2048, height: 2732)
                } else if model.hasPrefix("iPad6,8") {
                    size = CGSize(width: 2048, height: 2732)
                } else if model.hasPrefix("iPad7,1") {
                    size = CGSize(width: 2048, height: 2732)
                } else if model.hasPrefix("iPad7,2") {
                    size = CGSize(width: 2048, height: 2732)
                } else if model.hasPrefix("iPad7,3") {
                    size = CGSize(width: 1668, height: 2224)
                } else if model.hasPrefix("iPad7,4") {
                    size = CGSize(width: 1668, height: 2224)
                }
            }
        }
        if __CGSizeEqualToSize(size, CGSize.zero) {
            if self.responds(to: #selector(getter: UIScreen.nativeBounds)) {
                size = self.nativeBounds.size
            } else {
                size = self.bounds.size
                size.width *= self.scale
                size.height *= self.scale
            }
            if size.height < size.width {
                let tmp: CGFloat = size.height
                size.height = size.width
                size.width = tmp
            }
        }
        return size
    }
    
    public var pixelsPerInch: CGFloat {
        var ppi: CGFloat = 0
        if UIScreen.main.isEqual(self) {
            let model = UIDevice.current.machineModel
            if model.hasPrefix("iPhone") {
                if model.hasPrefix("iPhone1") {
                    ppi = 163
                } else if model.hasPrefix("iPhone2") {
                    ppi = 163
                } else if model.hasPrefix("iPhone3") {
                    ppi = 326
                } else if model.hasPrefix("iPhone4") {
                    ppi = 326
                } else if model.hasPrefix("iPhone5") {
                    ppi = 326
                } else if model.hasPrefix("iPhone6") {
                    ppi = 326
                } else if model.hasPrefix("iPhone7,1") {
                    ppi = 401
                } else if model.hasPrefix("iPhone7,2") {
                    ppi = 326
                } else if model.hasPrefix("iPhone8,1") {
                    ppi = 401
                } else if model.hasPrefix("iPhone8,2") {
                    ppi = 326
                } else if model.hasPrefix("iPhone8,4") {
                    ppi = 326
                } else if model.hasPrefix("iPhone9,1") {
                    ppi = 326
                } else if model.hasPrefix("iPhone9,3") {
                    ppi = 326
                } else if model.hasPrefix("iPhone9,2") {
                    ppi = 401
                } else if model.hasPrefix("iPhone9,4") {
                    ppi = 401
                } else if model.hasPrefix("iPhone10,1") {
                    ppi = 326
                } else if model.hasPrefix("iPhone10,4") {
                    ppi = 326
                } else if model.hasPrefix("iPhone10,2") {
                    ppi = 401
                } else if model.hasPrefix("iPhone10,5") {
                    ppi = 401
                } else if model.hasPrefix("iPhone10,3") {
                    ppi = 458
                } else if model.hasPrefix("iPhone10,6") {
                    ppi = 458
                }
            } else if model.hasPrefix("iPod") {
                if model.hasPrefix("iPod1") {
                    ppi = 163
                } else if model.hasPrefix("iPod2") {
                    ppi = 163
                } else if model.hasPrefix("iPod3") {
                    ppi = 163
                } else if model.hasPrefix("iPod4") {
                    ppi = 326
                } else if model.hasPrefix("iPod5") {
                    ppi = 326
                } else if model.hasPrefix("iPod7") {
                    ppi = 326
                }
                
            } else if model.hasPrefix("iPad") {
                if model.hasPrefix("iPad1") {
                    ppi = 132
                } else if model.hasPrefix("iPad2") {
                    ppi = 132
                } else if model.hasPrefix("iPad3") {
                    ppi = 132
                } else if model.hasPrefix("iPad4") {
                    ppi = 132
                } else if model.hasPrefix("iPad5") {
                    ppi = 264
                } else if model.hasPrefix("iPad6,3") {
                    ppi = 264
                } else if model.hasPrefix("iPad6,4") {
                    ppi = 264
                } else if model.hasPrefix("iPad6,7") {
                    ppi = 264
                } else if model.hasPrefix("iPad6,8") {
                    ppi = 264
                } else if model.hasPrefix("iPad7,1") {
                    ppi = 264
                } else if model.hasPrefix("iPad7,2") {
                    ppi = 264
                } else if model.hasPrefix("iPad7,3") {
                    ppi = 264
                } else if model.hasPrefix("iPad7,4") {
                    ppi = 264
                }
            }
        }
        return ppi == 0 ? 326 : ppi
    }
}
