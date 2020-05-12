//
//  UITableViewCell+CardCell.m
//  MZExtension
//
//  Created by 木木 on 2020/5/11.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

#import "UITableViewCell+CardCell.h"

@implementation UITableViewCell (CardCell)

- (void)createCellCornerWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)cornerRadius {
    // 每组只有一行的时候
    if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        [self setCorner:UIRectCornerAllCorners radii:cornerRadius];
    } else if (indexPath.row == 0) {
        [self setCorner:UIRectCornerTopLeft | UIRectCornerTopRight  radii:cornerRadius];
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        [self setCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight  radii:cornerRadius];
    } else {
        
    }
}

/// 设置某几个角的圆角
- (void)setCorner:(UIRectCorner)rectCorners radii:(CGFloat)radii {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
