//
//  UICollectionView+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/4/15.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    public func register(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: className)
    }
    
    public func register(cellTypes: [UICollectionViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach {
            self.register(cellType: $0, bundle: bundle)
        }
    }
    
    public func register(reusableViewType: UICollectionReusableView.Type, ofKind kind: String = UICollectionView.elementKindSectionHeader, bundle: Bundle? = nil) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: bundle)
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
    public func register(reusableViewTypes: [UICollectionReusableView.Type], ofKind kind: String = UICollectionView.elementKindSectionHeader, bundle: Bundle? = nil) {
        reusableViewTypes.forEach {
            self.register(reusableViewType: $0, ofKind: kind, bundle: bundle)
        }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    public func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type, for indexPath: IndexPath, ofKind kind: String = UICollectionView.elementKindSectionHeader) -> T {
        self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
}
