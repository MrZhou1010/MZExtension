//
//  UITableViewCell+CardCell.h
//  MZExtension
//
//  Created by Mr.Z on 2020/5/11.
//  Copyright © 2020 Mr.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (CardCell)

/// 每一组section下的Cell添加圆角,使Cell变成卡片效果
- (void)createCellCornerWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
