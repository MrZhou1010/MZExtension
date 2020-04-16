//
//  UITableView+Extension.swift
//  MZExtension
//
//  Created by Mr.Z on 2020/4/15.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func register(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: className)
    }
    
    public func register(cellTypes: [UITableViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach {
            self.register(cellType: $0, bundle: bundle)
        }
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    public func tableHeaderViewSizeToFit() {
        self.tableHeaderOrFooterViewSizeToFit(\.tableHeaderView)
    }
    
    public func tableFooterViewSizeToFit() {
        self.tableHeaderOrFooterViewSizeToFit(\.tableFooterView)
    }
    
    private func tableHeaderOrFooterViewSizeToFit(_ keyPath: ReferenceWritableKeyPath<UITableView, UIView?>) {
        guard let headerOrFooterView = self[keyPath: keyPath] else {
            return
        }
        let height = headerOrFooterView.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
        guard headerOrFooterView.frame.height != height else {
            return
        }
        headerOrFooterView.frame.size.height = height
        self[keyPath: keyPath] = headerOrFooterView
    }
    
    public func deselectRow(animated: Bool) {
        guard let indexPathForSelectedRow = self.indexPathForSelectedRow else {
            return
        }
        self.deselectRow(at: indexPathForSelectedRow, animated: animated)
    }
    
    public func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}
