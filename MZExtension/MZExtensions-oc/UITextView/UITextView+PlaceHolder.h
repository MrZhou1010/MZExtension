//
//  UITextView+PlaceHolder.h
//  MZExtension
//
//  Created by Mr.Z on 2019/12/13.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (PlaceHolder)

/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *mz_placeHolder;

/**
 *  IQKeyboardManager等第三方框架会读取placeholder属性并创建UIToolbar展示
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *mz_placeHolderColor;

@end

NS_ASSUME_NONNULL_END
